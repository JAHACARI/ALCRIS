import { supabase } from "../../config/supabase.js";

export const crearSeguimiento = async ({
  reserva_id,
  etapa_id,
  estado = "pendiente",
  notas,
}) => {
  const { data, error } = await supabase
    .from("seguimiento_reserva")
    .insert({ reserva_id, etapa_id, estado, notas })
    .select("*")
    .single();
  return { data, error };
};

export const obtenerSeguimientoPorReserva = async (reserva_id) => {
  const { data, error } = await supabase
    .from("seguimiento_reserva")
    .select("*, etapas_proceso(id, nombre, orden)")
    .eq("reserva_id", reserva_id)
    .order("id");
  return { data, error };
};

export const actualizarSeguimiento = async (id, campos) => {
  const { data, error } = await supabase
    .from("seguimiento_reserva")
    .update({ ...campos, fecha_actualizacion: new Date().toISOString() })
    .eq("id", id)
    .select("*")
    .single();
  return { data, error };
};
