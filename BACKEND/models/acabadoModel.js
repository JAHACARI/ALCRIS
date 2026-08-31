//----------------------------------------------------------//
// Modelo de Acabados de Pintura - Operaciones con Supabase
import { supabase } from "../config/supabase.js";

//----------------------------------------------------------//
// Campos públicos
const CAMPOS_PUBLICOS = "id, nombre";

//----------------------------------------------------------//
// Crear acabado
export const crearAcabado = async (nombre) => {
  const { data, error } = await supabase
    .from("acabados_pintura")
    .insert({ nombre })
    .select(CAMPOS_PUBLICOS)
    .single();
  return { data, error };
};

//----------------------------------------------------------//
// Obtener todos los acabados
export const obtenerAcabados = async () => {
  const { data, error } = await supabase
    .from("acabados_pintura")
    .select(CAMPOS_PUBLICOS)
    .order("id", { ascending: true });
  return { data, error };
};

//----------------------------------------------------------//
// Obtener acabado por ID
export const obtenerAcabadoPorId = async (id) => {
  const { data, error } = await supabase
    .from("acabados_pintura")
    .select(CAMPOS_PUBLICOS)
    .eq("id", id)
    .single();
  return { data, error };
};

//----------------------------------------------------------//
// Actualizar acabado
export const actualizarAcabado = async (id, campos) => {
  const { data, error } = await supabase
    .from("acabados_pintura")
    .update(campos)
    .eq("id", id)
    .select(CAMPOS_PUBLICOS)
    .single();
  return { data, error };
};

//----------------------------------------------------------//
// Eliminar acabado
export const eliminarAcabado = async (id) => {
  const { data, error } = await supabase
    .from("acabados_pintura")
    .delete()
    .eq("id", id)
    .select(CAMPOS_PUBLICOS)
    .single();
  return { data, error };
};