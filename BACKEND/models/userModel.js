//----------------------------------------------------------//
// Modelo de Usuario - Operaciones con Supabase
//----------------------------------------------------------//
import { supabase } from "../config/supabase.js";

//----------------------------------------------------------//
// Campos públicos (nunca se devuelve la contraseña)
//----------------------------------------------------------//
const CAMPOS_PUBLICOS = "id, nombre, correo, telefono, localidad, rol, created_at";

//----------------------------------------------------------//
// Crear nuevo usuario
//----------------------------------------------------------//
export const crearUsuario = async (nombre, correo, contrasena, rol = "usuario") => {
  const { data, error } = await supabase
    .from("usuario")
    .insert({ nombre, correo, contrasena, rol })
    .select(CAMPOS_PUBLICOS)
    .single();
  return { data, error };
};

//----------------------------------------------------------//
// Obtener todos los usuarios
//----------------------------------------------------------//
export const obtenerUsuarios = async () => {
  const { data, error } = await supabase
    .from("usuario")
    .select(CAMPOS_PUBLICOS)
    .order("id", { ascending: true });
  return { data, error };
};

//----------------------------------------------------------//
// Buscar usuario por correo (login) - incluye contraseña
//----------------------------------------------------------//
export const obtenerPorCorreo = async (correo) => {
  const { data, error } = await supabase
    .from("usuario")
    .select("*")
    .eq("correo", correo)
    .single();
  return { data, error };
};

//----------------------------------------------------------//
// Obtener usuario por ID
//----------------------------------------------------------//
export const obtenerUsuarioPorId = async (id) => {
  const { data, error } = await supabase
    .from("usuario")
    .select(CAMPOS_PUBLICOS)
    .eq("id", id)
    .single();
  return { data, error };
};

//----------------------------------------------------------//
// Actualizar usuario
//----------------------------------------------------------//
export const actualizarUsuario = async (id, campos) => {
  const { data, error } = await supabase
    .from("usuario")
    .update(campos)
    .eq("id", id)
    .select(CAMPOS_PUBLICOS)
    .single();
  return { data, error };
};

//----------------------------------------------------------//
// Eliminar usuario
//----------------------------------------------------------//
export const eliminarUsuario = async (id) => {
  const { data, error } = await supabase
    .from("usuario")
    .delete()
    .eq("id", id)
    .select(CAMPOS_PUBLICOS)
    .single();
  return { data, error };
};