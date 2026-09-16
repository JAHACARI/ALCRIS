import { supabase } from "../../config/supabase.js";

export const crearVehiculo = async ({
  usuario_id,
  marca,
  modelo,
  anio,
  placa,
  color,
}) => {
  const { data, error } = await supabase
    .from("vehiculos")
    .insert({ usuario_id, marca, modelo, anio, placa, color })
    .select("*")
    .single();

  return { data, error };
};

export const obtenerVehiculosPorUsuario = async (usuario_id) => {
  const { data, error } = await supabase
    .from("vehiculos")
    .select("*")
    .eq("usuario_id", usuario_id)
    .order("created_at", { ascending: false });

  return { data, error };
};

export const obtenerVehiculoPorId = async (id) => {
  const { data, error } = await supabase
    .from("vehiculos")
    .select("*")
    .eq("id", id)
    .single();

  return { data, error };
};

export const actualizarVehiculo = async (id, campos) => {
  const { data, error } = await supabase
    .from("vehiculos")
    .update(campos)
    .eq("id", id)
    .select("*")
    .single();

  return { data, error };
};

export const eliminarVehiculo = async (id) => {
  const { data, error } = await supabase
    .from("vehiculos")
    .delete()
    .eq("id", id)
    .select("*")
    .single();

  return { data, error };
};
