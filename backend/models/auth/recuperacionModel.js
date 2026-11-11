import { supabase } from "../../config/supabase.js";

export const crearRecuperacion = async ({
  usuario_id,
  codigo,
  fecha_expira,
}) => {
  const { data, error } = await supabase
    .from("recuperacion_password")
    .insert({ usuario_id, codigo, fecha_expira })
    .select("*")
    .single();
  return { data, error };
};

export const obtenerRecuperacionValida = async (usuario_id, codigo) => {
  const { data, error } = await supabase
    .from("recuperacion_password")
    .select("*")
    .eq("usuario_id", usuario_id)
    .eq("codigo", codigo)
    .eq("usado", false)
    .gt("fecha_expira", new Date().toISOString())
    .order("fecha_creacion", { ascending: false })
    .limit(1)
    .maybeSingle();
  return { data, error };
};

export const marcarRecuperacionUsada = async (id) => {
  const { data, error } = await supabase
    .from("recuperacion_password")
    .update({ usado: true })
    .eq("id", id)
    .select("*")
    .single();
  return { data, error };
};
