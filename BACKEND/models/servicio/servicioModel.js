import { supabase } from "../../config/supabase.js";

export const crearServicio = async ({
  categoria_id,
  nombre,
  descripcion,
  precio_base,
}) => {
  const { data, error } = await supabase
    .from("servicios")
    .insert({ categoria_id, nombre, descripcion, precio_base })
    .select("*")
    .single();
  return { data, error };
};

export const obtenerServicios = async () => {
  const { data, error } = await supabase
    .from("servicios")
    .select("*, categorias_servicio(id, nombre)")
    .eq("activo", true)
    .order("nombre");
  return { data, error };
};

export const obtenerServicioPorId = async (id) => {
  const { data, error } = await supabase
    .from("servicios")
    .select("*, categorias_servicio(id, nombre)")
    .eq("id", id)
    .single();
  return { data, error };
};

export const actualizarServicio = async (id, campos) => {
  const { data, error } = await supabase
    .from("servicios")
    .update(campos)
    .eq("id", id)
    .select("*")
    .single();
  return { data, error };
};

export const eliminarServicio = async (id) => {
  const { data, error } = await supabase
    .from("servicios")
    .delete()
    .eq("id", id)
    .select("*")
    .single();
  return { data, error };
};
