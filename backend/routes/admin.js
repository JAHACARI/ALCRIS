import { Router } from "express";
import { supabase } from "../config/supabase.js"; // cliente con SERVICE_ROLE_KEY

const router = Router();

// ───────── AJUSTA ESTOS VALORES A TU BASE ─────────
const ESTADOS = ['pendiente','confirmada','recibido','diagnostico','en_proceso','pintura','listo','entregado','rechazada','cancelada'];
const ESTADOS_FINALES = ['entregado','rechazada','cancelada'];
const ESTADO_PENDIENTE  = 'pendiente';
const ESTADO_CONFIRMADA = 'confirmada';
const ESTADO_RECHAZADA  = 'rechazada';
const FORMA_EFECTIVO    = 'efectivo';
const CATEGORIA_POR_DEFECTO = null;
const nombreUsuario = u => u?.nombre ?? '';
const textoVehiculo = v => v ? [v.marca, v.modelo, v.placa].filter(Boolean).join(' ') : '';
// ────────────────────────────────────────────────────

// La autenticación (verificarToken + soloAdmin) se aplica en index.js al montar este router.
const fail = (res, e, code = 500) => res.status(code).json({ error: e.message || e });
const num = x => Math.round(Number(x));

// ───────── RESUMEN ─────────
router.get('/resumen', async (req, res) => {
  const [r, p, s] = await Promise.all([
    supabase.from('reservas').select('estado'),
    supabase.from('pagos').select('estado, monto'),
    supabase.from('servicios').select('id', { count: 'exact', head: true }).eq('activo', true),
  ]);
  const err = r.error || p.error || s.error;
  if (err) return fail(res, err);
  const porEstado = {};
  r.data.forEach(x => { porEstado[x.estado] = (porEstado[x.estado] || 0) + 1; });
  res.json({
    totalReservas: r.data.length,
    reservasPorEstado: porEstado,
    pagosPendientes: p.data.filter(x => x.estado === 'revision').length,
    ingresosAprobados: p.data.filter(x => x.estado === 'aprobado').reduce((a, x) => a + num(x.monto), 0),
    serviciosActivos: s.count,
  });
});

// ───────── SERVICIOS (con paquetes) ─────────
const tiempoTexto = (min, max) => {
  if (min == null && max == null) return '';
  const a = min ?? max, b = max ?? min;
  return a === b ? `${a} ${a === 1 ? 'día' : 'días'}` : `${a}-${b} días`;
};
const outPaquete = p => ({
  id: p.id, nombre: p.nombre, descripcion: p.descripcion ?? '', precio: num(p.precio),
  diasMin: p.duracion_dias_min, diasMax: p.duracion_dias_max, destacado: !!p.destacado,
  tiempo: tiempoTexto(p.duracion_dias_min, p.duracion_dias_max),
});
const outServicio = s => ({
  id: s.id, nombre: s.nombre, descripcion: s.descripcion, precio: num(s.precio_base),
  paquetes: (s.paquetes_servicio ?? []).filter(p => p.activo).sort((a, b) => a.precio - b.precio).map(outPaquete),
});
const SELECT_SERVICIO =
  '*, paquetes_servicio(id, nombre, descripcion, precio, duracion_dias_min, duracion_dias_max, destacado, activo)';

async function servicioCompleto(id) {
  const { data, error } = await supabase.from('servicios').select(SELECT_SERVICIO).eq('id', id).single();
  if (error) throw error;
  return outServicio(data);
}

router.get('/servicios', async (req, res) => {
  const { data, error } = await supabase.from('servicios').select(SELECT_SERVICIO).eq('activo', true).order('id');
  if (error) return fail(res, error);
  res.json(data.map(outServicio));
});

// Valida el cuerpo. Si hay paquetes, el precio base del servicio es el del paquete más barato.
function validarServicio(b) {
  const nombre = String(b.nombre ?? '').trim();
  const descripcion = String(b.descripcion ?? '').trim();
  if (!nombre || !descripcion) return { error: 'Nombre y descripción son obligatorios' };

  let paquetes = null;
  if (Array.isArray(b.paquetes)) {
    if (b.paquetes.length > 10) return { error: 'Máximo 10 paquetes por servicio' };
    paquetes = [];
    for (const p of b.paquetes) {
      const pn = String(p.nombre ?? '').trim();
      const pd = String(p.descripcion ?? '').trim();
      const precio = Math.round(Number(p.precio));
      if (!pn || !(precio > 0)) return { error: 'Cada paquete necesita nombre y un precio mayor a 0' };
      const id = p.id == null ? null : Number(p.id);
      if (id !== null && !Number.isInteger(id)) return { error: 'Paquete inválido' };
      const dmin = Number(p.dias_min), dmax = Number(p.dias_max);
      if (![dmin, dmax].every(x => Number.isInteger(x) && x >= 1 && x <= 365))
        return { error: 'Los días de cada paquete deben ser enteros entre 1 y 365' };
      if (dmin > dmax) return { error: 'Los días mínimos no pueden superar a los máximos' };
      paquetes.push({ id, nombre: pn, descripcion: pd, precio, dias_min: dmin, dias_max: dmax, destacado: !!p.destacado });
    }
  }

  let precio_base;
  if (paquetes && paquetes.length) precio_base = Math.min(...paquetes.map(p => p.precio));
  else {
    precio_base = Math.round(Number(b.precio));
    if (!(precio_base > 0)) return { error: 'Pon un precio o agrega al menos un paquete' };
  }
  return { servicio: { nombre, descripcion, precio_base }, paquetes };
}

// Sincroniza: actualiza los existentes, crea los nuevos y desactiva los que ya no vienen.
// (Se desactivan, no se borran, porque las reservas antiguas pueden apuntar a ellos.)
async function guardarPaquetes(servicioId, paquetes) {
  const ids = paquetes.filter(p => p.id).map(p => p.id);
  let q = supabase.from('paquetes_servicio').update({ activo: false }).eq('servicio_id', servicioId);
  if (ids.length) q = q.not('id', 'in', `(${ids.join(',')})`);
  const { error: e0 } = await q;
  if (e0) throw e0;

  for (const p of paquetes) {
    const fila = {
      nombre: p.nombre, descripcion: p.descripcion, precio: p.precio,
      duracion_dias_min: p.dias_min, duracion_dias_max: p.dias_max,
      destacado: p.destacado, activo: true,
    };
    const { error } = p.id
      ? await supabase.from('paquetes_servicio').update(fila).eq('id', p.id).eq('servicio_id', servicioId)
      : await supabase.from('paquetes_servicio').insert({ ...fila, servicio_id: servicioId });
    if (error) throw error;
  }
}

router.post('/servicios', async (req, res) => {
  const v = validarServicio(req.body);
  if (v.error) return res.status(400).json({ error: v.error });
  const s = v.servicio;
  const categoria_id = req.body.categoria_id ?? CATEGORIA_POR_DEFECTO;
  if (categoria_id != null) s.categoria_id = categoria_id;
  const { data, error } = await supabase.from('servicios').insert(s).select('id').single();
  if (error) return fail(res, error.code === '23505' ? 'Ya existe un servicio con ese nombre' : error,
                         error.code === '23505' ? 409 : 500);
  try {
    if (v.paquetes?.length) await guardarPaquetes(data.id, v.paquetes);
    res.status(201).json(await servicioCompleto(data.id));
  } catch (e) { fail(res, e); }
});

router.put('/servicios/:id', async (req, res) => {
  const v = validarServicio(req.body);
  if (v.error) return res.status(400).json({ error: v.error });
  const { error } = await supabase.from('servicios').update(v.servicio).eq('id', req.params.id);
  if (error) return fail(res, error.code === '23505' ? 'Ya existe un servicio con ese nombre' : error,
                         error.code === '23505' ? 409 : 500);
  try {
    if (v.paquetes) await guardarPaquetes(Number(req.params.id), v.paquetes);
    res.json(await servicioCompleto(req.params.id));
  } catch (e) { fail(res, e); }
});

// Baja lógica: las reservas anteriores conservan su servicio y precio.
router.delete('/servicios/:id', async (req, res) => {
  const { count, error: e1 } = await supabase.from('reservas')
    .select('id', { count: 'exact', head: true })
    .eq('servicio_id', req.params.id)
    .not('estado', 'in', `(${ESTADOS_FINALES.join(',')})`);
  if (e1) return fail(res, e1);
  if (count > 0) return res.status(409).json({ error: `No se puede eliminar: tiene ${count} reserva(s) activa(s)` });
  const { error } = await supabase.from('servicios').update({ activo: false }).eq('id', req.params.id);
  if (error) return fail(res, error);
  res.status(204).end();
});
// ───────── PAGOS NEQUI (transferencia) ─────────
// Los comprobantes los sube el cliente en /api/pagos (ver pagos.js).
router.get('/pagos', async (req, res) => {
  const estado = req.query.estado || 'revision';
  const { data, error } = await supabase.from('pagos')
    .select(`id, monto, ref_nequi, comprobante_path, creado_en,
             reserva:reservas(codigo_reserva, total, usuario(nombre), vehiculos(marca, modelo, placa), servicios(nombre))`)
    .eq('estado', estado).order('creado_en');
  if (error) return fail(res, error);
  res.json(data.map(p => {
    const r = p.reserva;
    return {
      id: p.id, monto: num(p.monto), refNequi: p.ref_nequi, creadoEn: p.creado_en,
      comprobanteUrl: p.comprobante_path, // URL de Cloudinary
      referencia: r.codigo_reserva, cliente: nombreUsuario(r.usuario), vehiculo: textoVehiculo(r.vehiculos),
      servicio: r.servicios?.nombre ?? '', precioServicio: num(r.total),
    };
  }));
});

async function revisarPago(id, estadoPago, estadoReserva, motivo) {
  const { data: pago, error } = await supabase.from('pagos')
    .update({ estado: estadoPago, motivo: motivo ?? null })
    .eq('id', id).eq('estado', 'revision')
    .select('reserva_id').single();
  if (error || !pago) throw new Error('El pago ya fue revisado o no existe');
  const { error: e2 } = await supabase.from('reservas').update({ estado: estadoReserva }).eq('id', pago.reserva_id);
  if (e2) throw e2;
}

router.post('/pagos/:id/aceptar', async (req, res) => {
  try { await revisarPago(req.params.id, 'aprobado', ESTADO_CONFIRMADA); res.json({ ok: true }); }
  catch (e) { fail(res, e, 409); }
});

router.post('/pagos/:id/rechazar', async (req, res) => {
  const motivo = String(req.body.motivo ?? '').trim();
  if (!motivo) return res.status(400).json({ error: 'El motivo es obligatorio' });
  try { await revisarPago(req.params.id, 'rechazado', ESTADO_RECHAZADA, motivo); res.json({ ok: true }); }
  catch (e) { fail(res, e, 409); }
});

// ───────── RESERVAS ─────────
router.get('/estados', (req, res) => res.json(ESTADOS));

router.get('/reservas', async (req, res) => {
  const { data, error } = await supabase.from('reservas')
    .select('id, codigo_reserva, fecha_cita, hora_cita, total, estado, forma_pago, usuario(nombre), vehiculos(marca, modelo, placa), servicios(nombre)')
    .order('fecha_cita', { ascending: false });
  if (error) return fail(res, error);
  res.json(data.map(r => ({
    id: r.id, codigo: r.codigo_reserva, fecha: r.fecha_cita, hora: r.hora_cita,
    total: num(r.total), estado: r.estado, formaPago: r.forma_pago,
    confirmable: r.forma_pago === FORMA_EFECTIVO && r.estado === ESTADO_PENDIENTE,
    cliente: nombreUsuario(r.usuario), vehiculo: textoVehiculo(r.vehiculos),
    servicio: r.servicios?.nombre ?? '',
  })));
});

// El cliente pagó en efectivo en el taller: el admin confirma la reserva
router.post('/reservas/:id/confirmar-efectivo', async (req, res) => {
  const { data, error } = await supabase.from('reservas')
    .update({ estado: ESTADO_CONFIRMADA })
    .eq('id', req.params.id)
    .eq('forma_pago', FORMA_EFECTIVO)
    .eq('estado', ESTADO_PENDIENTE)
    .select('id').single();
  if (error || !data) return fail(res, 'La reserva no es de efectivo o ya no está pendiente', 409);
  res.json({ ok: true });
});

router.patch('/reservas/:id', async (req, res) => {
  const cambios = {};
  if (req.body.estado !== undefined) {
    if (!ESTADOS.includes(req.body.estado)) return res.status(400).json({ error: 'Estado inválido' });
    cambios.estado = req.body.estado;
  }
  if (req.body.tecnico_id !== undefined) cambios.tecnico_id = req.body.tecnico_id;
  const { data, error } = await supabase.from('reservas').update(cambios).eq('id', req.params.id).select().single();
  if (error) return fail(res, error);
  res.json(data);
});
// ───────── HORARIOS DEL TALLER ─────────
const HORA_RE = /^([01]\d|2[0-3]):[0-5]\d$/;
const FECHA_RE = /^\d{4}-\d{2}-\d{2}$/;

router.get('/horarios', async (req, res) => {
  const hoy = new Date(Date.now() - 5 * 3600 * 1000).toISOString().slice(0, 10);
  const [h, b] = await Promise.all([
    supabase.from('horario_base').select('dia_semana, hora, cupo').order('hora'),
    supabase.from('dias_bloqueados').select('fecha, motivo').gte('fecha', hoy).order('fecha'),
  ]);
  const err = h.error || b.error;
  if (err) return fail(res, err);
  const semana = { 0: [], 1: [], 2: [], 3: [], 4: [], 5: [], 6: [] };
  h.data.forEach(r => semana[r.dia_semana].push({ hora: String(r.hora).slice(0, 5), cupo: r.cupo }));
  res.json({ semana, bloqueados: b.data });
});

// Reemplaza las horas de un día de la semana (0 = domingo ... 6 = sábado)
router.put('/horarios/:dia', async (req, res) => {
  const dia = Number(req.params.dia);
  const horas = Array.isArray(req.body.horas) ? [...new Set(req.body.horas)] : null;
  const cupo = Number(req.body.cupo ?? 1);
  if (!Number.isInteger(dia) || dia < 0 || dia > 6) return res.status(400).json({ error: 'Día inválido' });
  if (!horas || horas.length > 24 || !horas.every(h => HORA_RE.test(h)))
    return res.status(400).json({ error: 'Horas inválidas (formato HH:MM)' });
  if (!Number.isInteger(cupo) || cupo < 1 || cupo > 20)
    return res.status(400).json({ error: 'El cupo debe estar entre 1 y 20' });

  if (horas.length) {
    const { error } = await supabase.from('horario_base')
      .upsert(horas.map(hora => ({ dia_semana: dia, hora, cupo })), { onConflict: 'dia_semana,hora' });
    if (error) return fail(res, error);
  }
  let q = supabase.from('horario_base').delete().eq('dia_semana', dia);
  if (horas.length) q = q.not('hora', 'in', `(${horas.map(h => `"${h}"`).join(',')})`);
  const { error: e2 } = await q;
  if (e2) return fail(res, e2);
  res.json({ ok: true });
});

// Bloquear una fecha completa (festivo, cierre, etc.)
router.post('/dias-bloqueados', async (req, res) => {
  const fecha = String(req.body.fecha ?? '');
  const motivo = String(req.body.motivo ?? '').trim() || null;
  if (!FECHA_RE.test(fecha)) return res.status(400).json({ error: 'Fecha inválida' });
  const { error } = await supabase.from('dias_bloqueados').upsert({ fecha, motivo });
  if (error) return fail(res, error);
  // No cancela reservas existentes: avisa cuántas hay para que el admin decida
  const { count } = await supabase.from('reservas')
    .select('id', { count: 'exact', head: true })
    .eq('fecha_cita', fecha)
    .not('estado', 'in', `(${ESTADOS_FINALES.join(',')})`);
  res.status(201).json({ ok: true, reservasExistentes: count ?? 0 });
});

router.delete('/dias-bloqueados/:fecha', async (req, res) => {
  if (!FECHA_RE.test(req.params.fecha)) return res.status(400).json({ error: 'Fecha inválida' });
  const { error } = await supabase.from('dias_bloqueados').delete().eq('fecha', req.params.fecha);
  if (error) return fail(res, error);
  res.status(204).end();
});
export default router;