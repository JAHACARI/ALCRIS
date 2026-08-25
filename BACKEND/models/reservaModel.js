//----------------------------------------------------------//
// Modelo de Reservas - Operaciones con Supabase
//----------------------------------------------------------//
import { supabase } from "../config/supabase.js";

//----------------------------------------------------------//
// Campos públicos
//----------------------------------------------------------//
const CAMPOS_PUBLICOS =
  "id, codigo_reserva, usuario_id, vehiculo_id, servicio_id, paquete_id, tecnico_id, color_id, acabado_id, fecha_cita, hora_cita, subtotal, materiales, descuento, total, forma_pago, estado, fecha_creacion";

//----------------------------------------------------------//
// Crear nueva reserva
//----------------------------------------------------------//
export const crearReserva = async (datos) => {
  const { data, error } = await supabase
    .from("reservas")
    .insert(datos)
    .select(CAMPOS_PUBLICOS)
    .single();
  return { data, error };
};

//----------------------------------------------------------//
// Obtener todas las reservas
//----------------------------------------------------------//
export const obtenerReservas = async () => {
  const { data, error } = await supabase
    .from("reservas")
    .select(CAMPOS_PUBLICOS)
    .order("id", { ascending: false });
  return { data, error };
};

//----------------------------------------------------------//
// Obtener reservas de un usuario
//----------------------------------------------------------//
export const obtenerReservasPorUsuario = async (usuarioId) => {
  const { data, error } = await supabase
    .from("reservas")
    .select(CAMPOS_PUBLICOS)
    .eq("usuario_id", usuarioId)
    .order("id", { ascending: false });
  return { data, error };
};

//----------------------------------------------------------//
// Obtener reserva por ID
//----------------------------------------------------------//
export const obtenerReservaPorId = async (id) => {
  const { data, error } = await supabase
    .from("reservas")
    .select(CAMPOS_PUBLICOS)
    .eq("id", id)
    .single();
  return { data, error };
};

//----------------------------------------------------------//
// Obtener reserva por código
//----------------------------------------------------------//
export const obtenerReservaPorCodigo = async (codigo) => {
  const { data, error } = await supabase
    .from("reservas")
    .select(CAMPOS_PUBLICOS)
    .eq("codigo_reserva", codigo)
    .single();
  return { data, error };
};

//----------------------------------------------------------//
// Actualizar reserva
//----------------------------------------------------------//
export const actualizarReserva = async (id, campos) => {
  const { data, error } = await supabase
    .from("reservas")
    .update(campos)
    .eq("id", id)
    .select(CAMPOS_PUBLICOS)
    .single();
  return { data, error };
};

//----------------------------------------------------------//
// Eliminar reserva
//----------------------------------------------------------//
export const eliminarReserva = async (id) => {
  const { data, error } = await supabase
    .from("reservas")
    .delete()
    .eq("id", id)
    .select(CAMPOS_PUBLICOS)
    .single();
  return { data, error };
};