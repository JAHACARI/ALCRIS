import { supabase } from "../../config/supabase.js";

export const crearTecnico = async ({ usuario_id, especialidad }) => {
  const { data, error } = await supabase
    .from("tecnicos")
    .insert({ usuario_id, especialidad })
    .select("*, usuario(id, nombre, email, telefono)")
    .single();
  return { data, error };
};

export const obtenerTecnicos = async () => {
  const { data, error } = await supabase
    .from("tecnicos")
    .select("*, usuario(id, nombre, email, telefono)")
    .eq("activo", true)
    .order("id");
  return { data, error };
};

export const obtenerTecnicoPorId = async (id) => {
  const { data, error } = await supabase
    .from("tecnicos")
    .select("*, usuario(id, nombre, email, telefono)")
    .eq("id", id)
    .single();
  return { data, error };
};

export const actualizarTecnico = async (id, campos) => {
  const { data, error } = await supabase
    .from("tecnicos")
    .update(campos)
    .eq("id", id)
    .select("*")
    .single();
  return { data, error };
};

export const eliminarTecnico = async (id) => {
  const { data, error } = await supabase
    .from("tecnicos")
    .delete()
    .eq("id", id)
    .select("*")
    .single();
  return { data, error };
};
