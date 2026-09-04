//----------------------------------------------------------//
// Modelo de Etapas de Proceso - Operaciones con Supabase

import { supabase } from "../config/supabase.js";

//----------------------------------------------------------//
// Campos públicos

const CAMPOS_PUBLICOS = "id, nombre, orden";

//----------------------------------------------------------//
// Crear etapa

export const crearEtapa = async (nombre, orden) => {
  const { data, error } = await supabase
    .from("etapas_proceso")
    .insert({ nombre, orden })
    .select(CAMPOS_PUBLICOS)
    .single();
  return { data, error };
};

//----------------------------------------------------------//
// Obtener todas las etapas (ordenadas)

export const obtenerEtapas = async () => {
  const { data, error } = await supabase
    .from("etapas_proceso")
    .select(CAMPOS_PUBLICOS)
    .order("orden", { ascending: true });
  return { data, error };
};

//----------------------------------------------------------//
// Obtener etapa por ID

export const obtenerEtapaPorId = async (id) => {
  const { data, error } = await supabase
    .from("etapas_proceso")
    .select(CAMPOS_PUBLICOS)
    .eq("id", id)
    .single();
  return { data, error };
};

//----------------------------------------------------------//
// Actualizar etapa

export const actualizarEtapa = async (id, campos) => {
  const { data, error } = await supabase
    .from("etapas_proceso")
    .update(campos)
    .eq("id", id)
    .select(CAMPOS_PUBLICOS)
    .single();
  return { data, error };
};

//----------------------------------------------------------//
// Eliminar etapa

export const eliminarEtapa = async (id) => {
  const { data, error } = await supabase
    .from("etapas_proceso")
    .delete()
    .eq("id", id)
    .select(CAMPOS_PUBLICOS)
    .single();
  return { data, error };
};