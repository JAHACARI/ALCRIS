import { supabase } from "../../config/supabase.js";

const CAMPOS_PUBLICOS =
  "id, nombre, email, telefono, localidad, rol, is_verified, avatar, created_at";

export const crearUsuario = async ({
  nombre,
  email,
  contrasena,
  telefono,
  localidad,
  rol = "usuario",
  codigo_verificacion,
  codigo_verificacion_expira,
}) => {
  const { data, error } = await supabase
    .from("usuario")
    .insert({
      nombre,
      email,
      contrasena,
      telefono,
      localidad,
      rol,
      is_verified: false,
      codigo_verificacion,
      codigo_verificacion_expira,
    })
    .select("id, nombre, email, rol")
    .single();

  return { data, error };
};

export const crearUsuarioGoogle = async ({
  nombre,
  email,
  google_id,
  avatar = null,
  rol = "usuario",
}) => {
  const { data, error } = await supabase
    .from("usuario")
    .insert({
      nombre,
      email,
      contrasena: null,
      google_id,
      avatar,
      rol,
      is_verified: true,
    })
    .select("id, nombre, email, rol, avatar")
    .single();

  return { data, error };
};

export const obtenerPorEmail = async (email) => {
  const { data, error } = await supabase
    .from("usuario")
    .select("*")
    .eq("email", email)
    .maybeSingle();

  return { data, error };
};

export const obtenerPorGoogleId = async (google_id) => {
  const { data, error } = await supabase
    .from("usuario")
    .select("*")
    .eq("google_id", google_id)
    .maybeSingle();

  return { data, error };
};

export const obtenerUsuarioPorId = async (id) => {
  const { data, error } = await supabase
    .from("usuario")
    .select(CAMPOS_PUBLICOS)
    .eq("id", id)
    .single();

  return { data, error };
};

export const obtenerUsuarios = async () => {
  const { data, error } = await supabase
    .from("usuario")
    .select(CAMPOS_PUBLICOS)
    .order("created_at", { ascending: false });

  return { data, error };
};

export const actualizarUsuario = async (id, campos) => {
  const { data, error } = await supabase
    .from("usuario")
    .update({ ...campos, updated_at: new Date().toISOString() })
    .eq("id", id)
    .select(CAMPOS_PUBLICOS)
    .single();

  return { data, error };
};
export const eliminarUsuario = async (id) => {
  // 1. Elimina primero las reservas asociadas a este usuario
  const { error: errorReservas } = await supabase
    .from("reservas")
    .delete()
    .eq("usuario_id", id);

  if (errorReservas) {
    return { data: null, error: errorReservas };
  }

  // (Opcional) Si tienes otras tablas con usuario_id como 'vehiculos' o 'mensajes', bórralas aquí igual:
  // await supabase.from("vehiculos").delete().eq("usuario_id", id);

  // 2. Ahora sí elimina al usuario
  return await supabase
    .from("usuario")
    .delete()
    .eq("id", id)
    .select()
    .single();
};



