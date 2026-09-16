import { supabase } from "../../config/supabase.js";

export const crearPaquete = async (campos) => {
  const { data, error } = await supabase
    .from("paquetes_servicio")
    .insert(campos)
    .select("*")
    .single();
  return { data, error };
};

export const obtenerPaquetes = async () => {
  const { data, error } = await supabase
    .from("paquetes_servicio")
    .select("*, servicios(id, nombre)")
    .eq("activo", true)
    .order("nombre");
  return { data, error };
};

export const obtenerPaquetePorId = async (id) => {
  const { data, error } = await supabase
    .from("paquetes_servicio")
    .select("*, servicios(id, nombre)")
    .eq("id", id)
    .single();
  return { data, error };
};

export const actualizarPaquete = async (id, campos) => {
  const { data, error } = await supabase
    .from("paquetes_servicio")
    .update(campos)
    .eq("id", id)
    .select("*")
    .single();
  return { data, error };
};

export const eliminarPaquete = async (id) => {
  const { data, error } = await supabase
    .from("paquetes_servicio")
    .delete()
    .eq("id", id)
    .select("*")
    .single();
  return { data, error };
};
