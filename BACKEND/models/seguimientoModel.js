//----------------------------------------------------------//
// Modelo de Seguimiento de Reserva - Operaciones con Supabase

import { supabase } from "../config/supabase.js";

//----------------------------------------------------------//
// Campos públicos

const CAMPOS_PUBLICOS =
  "id, reserva_id, etapa_id, estado, fecha_actualizacion";

//----------------------------------------------------------//
// Crear seguimiento

export const crearSeguimiento = async (datos) => {
  const { data, error } = await supabase
    .from("seguimiento_reserva")
    .insert(datos)
    .select(CAMPOS_PUBLICOS)
    .single();
  return { data, error };
};

//----------------------------------------------------------//
// Crear varios seguimientos a la vez (útil al crear una reserva)

export const crearSeguimientosMultiples = async (lista) => {
  const { data, error } = await supabase
    .from("seguimiento_reserva")
    .insert(lista)
    .select(CAMPOS_PUBLICOS);
  return { data, error };
};

//----------------------------------------------------------//
// Obtener todos los seguimientos de una reserva

export const obtenerSeguimientosPorReserva = async (reservaId) => {
  const { data, error } = await supabase
    .from("seguimiento_reserva")
    .select(CAMPOS_PUBLICOS)
    .eq("reserva_id", reservaId)
    .order("id", { ascending: true });
  return { data, error };
};

//----------------------------------------------------------//
// Obtener un seguimiento por ID

export const obtenerSeguimientoPorId = async (id) => {
  const { data, error } = await supabase
    .from("seguimiento_reserva")
    .select(CAMPOS_PUBLICOS)
    .eq("id", id)
    .single();
  return { data, error };
};

//----------------------------------------------------------//
// Actualizar seguimiento

export const actualizarSeguimiento = async (id, campos) => {
  const { data, error } = await supabase
    .from("seguimiento_reserva")
    .update(campos)
    .eq("id", id)
    .select(CAMPOS_PUBLICOS)
    .single();
  return { data, error };
};

//----------------------------------------------------------//
// Eliminar seguimiento

export const eliminarSeguimiento = async (id) => {
  const { data, error } = await supabase
    .from("seguimiento_reserva")
    .delete()
    .eq("id", id)
    .select(CAMPOS_PUBLICOS)
    .single();
  return { data, error };
};