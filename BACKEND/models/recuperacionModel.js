//----------------------------------------------------------//
// Modelo de Recuperación de Contraseña - Operaciones con Supabase
import { supabase } from "../config/supabase.js";

//----------------------------------------------------------//
// Campos públicos
const CAMPOS_PUBLICOS = "id, usuario_id, codigo, usado, fecha_creacion, fecha_expira";

//----------------------------------------------------------//
// Crear código de recuperación (expira en 10 minutos)
export const crearCodigoRecuperacion = async (usuario_id, codigo) => {
  const fecha_expira = new Date(Date.now() + 10 * 60 * 1000).toISOString();

  const { data, error } = await supabase
    .from("recuperacion_password")
    .insert({ usuario_id, codigo, fecha_expira })
    .select(CAMPOS_PUBLICOS)
    .single();
  return { data, error };
};

//----------------------------------------------------------//
// Buscar código válido (no usado y no expirado)
export const obtenerCodigoValido = async (usuario_id, codigo) => {
  const ahora = new Date().toISOString();

  const { data, error } = await supabase
    .from("recuperacion_password")
    .select(CAMPOS_PUBLICOS)
    .eq("usuario_id", usuario_id)
    .eq("codigo", codigo)
    .eq("usado", false)
    .gt("fecha_expira", ahora)
    .order("id", { ascending: false })
    .limit(1)
    .maybeSingle();

  return { data, error };
};

//----------------------------------------------------------//
// Marcar código como usado
export const marcarCodigoUsado = async (id) => {
  const { data, error } = await supabase
    .from("recuperacion_password")
    .update({ usado: true })
    .eq("id", id)
    .select(CAMPOS_PUBLICOS)
    .single();
  return { data, error };
};

//----------------------------------------------------------//
// Invalidar códigos anteriores del usuario
export const invalidarCodigosAnteriores = async (usuario_id) => {
  const { data, error } = await supabase
    .from("recuperacion_password")
    .update({ usado: true })
    .eq("usuario_id", usuario_id)
    .eq("usado", false);
  return { data, error };
};