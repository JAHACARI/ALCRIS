import { supabase } from "../config/supabase.js"; // Realineado para buscar correctamente en backend/config/

const INACTIVAS = ["cancelada", "rechazada"];
const pad = (n) => String(n).padStart(2, "0");

// "14:00" -> "2:00 PM" (formato que muestra la app)
export const etiqueta = (h) => {
  const [hh, mm] = h.split(":").map(Number);
  return `${hh % 12 || 12}:${pad(mm)} ${hh >= 12 ? "PM" : "AM"}`;
};

// Fecha y hora actuales en Colombia (UTC-5)
export const ahoraColombia = () => {
  const d = new Date(Date.now() - 5 * 3600 * 1000);
  return { fecha: d.toISOString().slice(0, 10), hora: `${pad(d.getUTCHours())}:${pad(d.getUTCMinutes())}` };
};

const diaSemana = (fecha) => new Date(`${fecha}T00:00:00Z`).getUTCDay(); // 0 = domingo

// Configuración que define el admin
async function cargarConfig() {
  const [h, b] = await Promise.all([
    supabase.from("horario_base").select("dia_semana, hora, cupo").order("hora"),
    supabase.from("dias_bloqueados").select("fecha"),
  ]);
  if (h.error) throw h.error;
  if (b.error) throw b.error;
  const porDia = {};
  for (const r of h.data) (porDia[r.dia_semana] ||= []).push({ hora: String(r.hora).slice(0, 5), cupo: r.cupo });
  return { porDia, bloqueados: new Set(b.data.map((x) => x.fecha)) };
}

// Franjas que el taller atiende en una fecha
const franjasDe = (fecha, cfg) => (cfg.bloqueados.has(fecha) ? [] : cfg.porDia[diaSemana(fecha)] || []);

// Reservas activas por "fecha|hora" en un rango
async function ocupacion(desde, hasta) {
  const { data, error } = await supabase
    .from("reservas")
    .select("fecha_cita, hora_cita")
    .gte("fecha_cita", desde)
    .lte("fecha_cita", hasta)
    .not("estado", "in", `(${INACTIVAS.join(",")})`);
  if (error) throw error;
  const mapa = {};
  for (const r of data) {
    const k = `${r.fecha_cita}|${String(r.hora_cita).slice(0, 5)}`;
    mapa[k] = (mapa[k] || 0) + 1;
  }
  return mapa;
}

const libres = (fecha, cfg, mapa) =>
  franjasDe(fecha, cfg).filter((s) => (mapa[`${fecha}|${s.hora}`] || 0) < s.cupo);

// Se usa al crear la reserva
export async function validarHorario(fecha, hora) {
  const cfg = await cargarConfig();
  const slot = franjasDe(fecha, cfg).find((s) => s.hora === hora);
  if (!slot) return { ok: false, codigo: 400, error: "El taller no atiende en esa fecha u hora" };
  const mapa = await ocupacion(fecha, fecha);
  if ((mapa[`${fecha}|${hora}`] || 0) >= slot.cupo)
    return { ok: false, codigo: 409, error: "Esa hora ya no está disponible. Elige otra." };
  return { ok: true };
}

// Se usa en GET /reservas/disponibilidad
export async function calcularDisponibilidad(mes, anio, fecha) {
  const cfg = await cargarConfig();
  const ultimo = new Date(anio, mes, 0).getDate();
  const desde = `${anio}-${pad(mes)}-01`;
  const hasta = `${anio}-${pad(mes)}-${pad(ultimo)}`;
  const ahora = ahoraColombia();
  const mapaMes = await ocupacion(desde, hasta);

  const dias_ocupados = [];
  for (let d = 1; d <= ultimo; d++) {
    const f = `${anio}-${pad(mes)}-${pad(d)}`;
    if (f < ahora.fecha) continue;
    if (libres(f, cfg, mapaMes).length === 0) dias_ocupados.push(f);
  }

  let horas_disponibles = [];
  if (fecha) {
    const mapaDia = fecha.slice(0, 7) === `${anio}-${pad(mes)}` ? mapaMes : await ocupacion(fecha, fecha);
    horas_disponibles = libres(fecha, cfg, mapaDia)
      .map((s) => s.hora)
      .filter((h) => fecha > ahora.fecha || h > ahora.hora) // hoy: solo horas futuras
      .map(etiqueta);
  }
  return { dias_ocupados, horas_disponibles };
}
