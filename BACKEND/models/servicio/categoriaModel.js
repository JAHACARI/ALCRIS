import { supabase } from "../../config/supabase.js";

export const crearCategoria = async ({
  nombre,
  descripcion,
  imagen,
  color_tema,
}) => {
  const { data, error } = await supabase
    .from("categorias_servicio")
    .insert({ nombre, descripcion, imagen, color_tema })
    .select("*")
    .single();
  return { data, error };
};

export const obtenerCategorias = async () => {
  const { data, error } = await supabase
    .from("categorias_servicio")
    .select("*")
    .order("nombre");
  return { data, error };
};

export const obtenerCategoriaPorId = async (id) => {
  const { data, error } = await supabase
    .from("categorias_servicio")
    .select("*")
    .eq("id", id)
    .single();
  return { data, error };
};

export const actualizarCategoria = async (id, campos) => {
  const { data, error } = await supabase
    .from("categorias_servicio")
    .update(campos)
    .eq("id", id)
    .select("*")
    .single();
  return { data, error };
};

export const eliminarCategoria = async (id) => {
  const { data, error } = await supabase
    .from("categorias_servicio")
    .delete()
    .eq("id", id)
    .select("*")
    .single();
  return { data, error };
};
