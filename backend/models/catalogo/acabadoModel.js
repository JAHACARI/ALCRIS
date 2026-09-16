import { supabase } from "../../config/supabase.js";

export const crearAcabado = async ({ nombre, descripcion }) => {
  const { data, error } = await supabase
    .from("acabados_pintura")
    .insert({ nombre, descripcion })
    .select("*")
    .single();
  return { data, error };
};

export const obtenerAcabados = async () => {
  const { data, error } = await supabase
    .from("acabados_pintura")
    .select("*")
    .order("nombre");
  return { data, error };
};

export const obtenerAcabadoPorId = async (id) => {
  const { data, error } = await supabase
    .from("acabados_pintura")
    .select("*")
    .eq("id", id)
    .single();
  return { data, error };
};

export const actualizarAcabado = async (id, campos) => {
  const { data, error } = await supabase
    .from("acabados_pintura")
    .update(campos)
    .eq("id", id)
    .select("*")
    .single();
  return { data, error };
};

export const eliminarAcabado = async (id) => {
  const { data, error } = await supabase
    .from("acabados_pintura")
    .delete()
    .eq("id", id)
    .select("*")
    .single();
  return { data, error };
};
