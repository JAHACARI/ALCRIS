import { supabase } from "../../config/supabase.js";

/**
 * Guarda uno o varios mensajes en mensajes_chat
 */
export const guardarMensajes = async (registros) => {
  const { data, error } = await supabase
    .from("mensajes_chat")
    .insert(registros)
    .select("*");

  return { data, error };
};

/**
 * Obtiene el historial de una sesión ordenado por fecha
 */
export const obtenerHistorialPorSesion = async (sesion_id) => {
  const { data, error } = await supabase
    .from("mensajes_chat")
    .select("emisor, mensaje, created_at")
    .eq("sesion_id", sesion_id)
    .order("created_at", { ascending: true });

  return { data, error };
};

/**
 * Catálogo para el contexto del chatbot:
 * servicios + paquetes + colores + acabados
 */
export const obtenerCatalogoParaChat = async () => {
  const [servicios, paquetes, colores, acabados] = await Promise.all([
    supabase
      .from("servicios")
      .select("id, nombre, descripcion, precio_base, categorias_servicio(nombre)")
      .eq("activo", true),
    supabase
      .from("paquetes_servicio")
      .select("id, nombre, descripcion, precio, duracion_dias_min, duracion_dias_max, destacado, servicios(nombre)")
      .eq("activo", true),
    supabase
      .from("colores_ral")
      .select("nombre_color, codigo_ral, codigo_hex")
      .order("codigo_ral")
      .limit(40),
    supabase
      .from("acabados_pintura")
      .select("nombre, descripcion")
      .order("nombre"),
  ]);

  return {
    servicios: servicios.data || [],
    paquetes: paquetes.data || [],
    colores: colores.data || [],
    acabados: acabados.data || [],
    error:
      servicios.error ||
      paquetes.error ||
      colores.error ||
      acabados.error ||
      null,
  };
};