import { supabase } from "../../config/supabase.js";

export const crearColor = async ({ nombre_color, codigo_ral, codigo_hex }) => {
  const { data, error } = await supabase
    .from("colores_ral")
    .insert({ nombre_color, codigo_ral, codigo_hex })
    .select("*")
    .single();
  return { data, error };
};

export const obtenerColores = async () => {
  const { data, error } = await supabase
    .from("colores_ral")
    .select("*")
    .order("codigo_ral");
  return { data, error };
};

export const obtenerColorPorId = async (id) => {
  const { data, error } = await supabase
    .from("colores_ral")
    .select("*")
    .eq("id", id)
    .single();
  return { data, error };
};

export const actualizarColor = async (id, campos) => {
  const { data, error } = await supabase
    .from("colores_ral")
    .update(campos)
    .eq("id", id)
    .select("*")
    .single();
  return { data, error };
};

export const eliminarColor = async (id) => {
  const { data, error } = await supabase
    .from("colores_ral")
    .delete()
    .eq("id", id)
    .select("*")
    .single();
  return { data, error };
};
