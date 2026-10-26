// Montar en app.js:  app.use("/api/admin", verificarToken, adminRoutes);
// El middleware de auth debe poner req.user = { id, rol }.
import { Router } from "express";
import { supabase } from "../config/supabase.js";

const router = Router();

// ───────── AJUSTA ESTOS VALORES A TU BASE ─────────
// Deben coincidir EXACTAMENTE con los valores de tu enum estado_reserva.
const ESTADOS = ['pendiente','confirmada','recibido','diagnostico','en_proceso','pintura','listo','entregado','rechazada'];
const ESTADO_CONFIRMADA = 'confirmada';
const ESTADO_RECHAZADA  = 'rechazada';
const ESTADOS_FINALES   = ['entregado','rechazada'];
// categoria_id (FK de servicios). Si tu columna es obligatoria, pon aquí una categoría por defecto.
const CATEGORIA_POR_DEFECTO = null;
// Columnas de nombre en usuario / vehiculos (ajusta si se llaman distinto).
const nombreUsuario = u => u?.nombre ?? '';
const textoVehiculo = v => v ? [v.marca, v.modelo, v.placa].filter(Boolean).join(' ') : '';
// ────────────────────────────────────────────────────

const fail = (res, e, code = 500) => res.status(code).json({ error: e.message || e });
const num = x => Math.round(Number(x));  // numeric llega como 1500000.0; Flutter espera int

// ───────── SERVICIOS ─────────
const outServicio = s => ({ id: s.id, nombre: s.nombre, descripcion: s.descripcion, precio: num(s.precio_base) });

router.get('/servicios', async (req, res) => {
  const { data, error } = await supabase.from('servicios').select('*').eq('activo', true).order('id');
  if (error) return fail(res, error);
  res.json(data.map(outServicio));
});

function validarServicio(b) {
  const nombre = String(b.nombre ?? '').trim();
  const descripcion = String(b.descripcion ?? '').trim();
  const precio = Number(b.precio);
  if (!nombre || !descripcion || !(precio > 0)) return null;
  return { nombre, descripcion, precio_base: Math.round(precio) };
}

router.post('/servicios', async (req, res) => {
  const s = validarServicio(req.body);
  if (!s) return res.status(400).json({ error: 'Nombre, descripción y precio son obligatorios' });
  const categoria_id = req.body.categoria_id ?? CATEGORIA_POR_DEFECTO;
  if (categoria_id != null) s.categoria_id = categoria_id;
  const { data, error } = await supabase.from('servicios').insert(s).select().single();
  if (error) return fail(res, error.code === '23505' ? 'Ya existe un servicio con ese nombre' : error,
                         error.code === '23505' ? 409 : 500);
  res.status(201).json(outServicio(data));
});

router.put('/servicios/:id', async (req, res) => {
  const s = validarServicio(req.body);
  if (!s) return res.status(400).json({ error: 'Nombre, descripción y precio son obligatorios' });
  const { data, error } = await supabase.from('servicios').update(s).eq('id', req.params.id).select().single();
  if (error) return fail(res, error.code === '23505' ? 'Ya existe un servicio con ese nombre' : error,
                         error.code === '23505' ? 409 : 500);
  res.json(outServicio(data));
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

// ───────── PAGOS NEQUI ─────────
router.get('/pagos', async (req, res) => {
  const estado = req.query.estado || 'revision';
  const { data, error } = await supabase.from('pagos')
    .select(`id, monto, ref_nequi, comprobante_path, creado_en,
             reserva:reservas(codigo_reserva, total, usuario(nombre), vehiculos(marca, modelo, placa), servicios(nombre))`)
    .eq('estado', estado).order('creado_en');
  if (error) return fail(res, error);
  const out = await Promise.all(data.map(async p => {
    const { data: s } = await supabase.storage.from('comprobantes').createSignedUrl(p.comprobante_path, 3600);
    const r = p.reserva;
    return {
      id: p.id, monto: num(p.monto), refNequi: p.ref_nequi, creadoEn: p.creado_en,
      comprobanteUrl: s?.signedUrl ?? '',
      referencia: r.codigo_reserva, cliente: nombreUsuario(r.usuario), vehiculo: textoVehiculo(r.vehiculos),
      servicio: r.servicios?.nombre ?? '', precioServicio: num(r.total),
    };
  }));
  res.json(out);
});

async function revisarPago(id, estadoPago, estadoReserva, motivo) {
  const { data: pago, error } = await supabase.from('pagos')
    .update({ estado: estadoPago, motivo: motivo ?? null })
    .eq('id', id).eq('estado', 'revision')            // evita revisar dos veces
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
router.get('/reservas', async (req, res) => {
  const { data, error } = await supabase.from('reservas')
    .select('*, servicios(nombre)').order('fecha_cita');
  if (error) return fail(res, error);
  res.json(data);
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

export default router;
