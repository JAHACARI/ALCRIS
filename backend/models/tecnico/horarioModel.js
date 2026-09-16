import { supabase } from "../../config/supabase.js";

export const crearHorario = async ({
  tecnico_id,
  fecha,
  hora,
  disponible = true,
}) => {
  const { data, error } = await supabase
    .from("horarios_disponibles")
    .insert({ tecnico_id, fecha, hora, disponible })
    .select("*")
    .single();
  return { data, error };
};

export const obtenerHorariosPorTecnico = async (tecnico_id, fecha = null) => {
  let query = supabase
    .from("horarios_disponibles")
    .select("*")
    .eq("tecnico_id", tecnico_id)
    .order("fecha")
    .order("hora");

  if (fecha) {
    query = query.eq("fecha", fecha);
  }

  const { data, error } = await query;
  return { data, error };
};

export const actualizarHorario = async (id, campos) => {
  const { data, error } = await supabase
    .from("horarios_disponibles")
    .update(campos)
    .eq("id", id)
    .select("*")
    .single();
  return { data, error };
};

export const eliminarHorario = async (id) => {
  const { data, error } = await supabase
    .from("horarios_disponibles")
    .delete()
    .eq("id", id)
    .select("*")
    .single();
  return { data, error };
};
