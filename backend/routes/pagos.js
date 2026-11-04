import { Router } from "express";
import { supabase } from "../config/supabase.js";

const router = Router();

const ESTADO_PENDIENTE = "pendiente";
const FORMA_TRANSFERENCIA = "transferencia";

const fail = (res, e, code = 500) => res.status(code).json({ error: e.message || e });

// Reservas del cliente pagadas por transferencia que aún se pueden pagar
router.get("/mis-reservas", async (req, res) => {
  const { data: rs, error } = await supabase
    .from("reservas")
    .select("id, codigo_reserva, fecha_cita, hora_cita, total, estado, servicios(nombre)")
    .eq("usuario_id", req.usuario.id)
    .eq("estado", ESTADO_PENDIENTE)
    .eq("forma_pago", FORMA_TRANSFERENCIA)
    .order("fecha_cita");
  if (error) return fail(res, error);

  let pagos = [];
  if (rs.length) {
    const { data } = await supabase.from("pagos").select("reserva_id, estado").in("reserva_id", rs.map((r) => r.id));
    pagos = data ?? [];
  }
  res.json(
    rs.map((r) => ({
      id: r.id,
      codigo: r.codigo_reserva,
      servicio: r.servicios?.nombre ?? "",
      fecha: r.fecha_cita,
      hora: String(r.hora_cita ?? ""),
      total: Math.round(Number(r.total)),
      enRevision: pagos.some((p) => p.reserva_id === r.id && p.estado === "revision"),
    }))
  );
});

export default router;