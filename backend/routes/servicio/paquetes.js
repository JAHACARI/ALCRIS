import { Router } from "express";
import { supabase } from "../../config/supabase.js";

const router = Router();

const tiempoTexto = (min, max) => {
  if (min == null && max == null) return "";
  const a = min ?? max;
  const b = max ?? min;
  return a === b ? `${a} ${a === 1 ? "día" : "días"}` : `${a}-${b} días`;
};

// GET /api/paquetes?servicio_id=8  -> paquetes activos de un servicio
router.get("/", async (req, res) => {
  const servicioId = Number(req.query.servicio_id);
  if (!Number.isInteger(servicioId)) {
    return res.status(400).json({ error: "servicio_id inválido" });
  }
  const { data, error } = await supabase
    .from("paquetes_servicio")
    .select("id, nombre, descripcion, precio, duracion_dias_min, duracion_dias_max, destacado")
    .eq("servicio_id", servicioId)
    .eq("activo", true)
    .order("precio");
  if (error) return res.status(500).json({ error: error.message });
  res.json(
    data.map((p) => ({
      id: p.id,
      nombre: p.nombre,
      descripcion: p.descripcion ?? "",
      tiempo: tiempoTexto(p.duracion_dias_min, p.duracion_dias_max),
      destacado: !!p.destacado,
      precio: Math.round(Number(p.precio)),
    }))
  );
});

export default router;