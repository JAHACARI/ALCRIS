// ----------------------------------------------------------//
// Modelo de Usuario - Operaciones con Supabase
//----------------------------------------------------------//
import { supabase } from "../config/supabase.js";

//----------------------------------------------------------//
// Campos públicos (nunca se devuelve la contraseña)
//----------------------------------------------------------//
const CAMPOS_PUBLICOS =
  "id, nombre, correo, telefono, localidad, rol, created_at";

//----------------------------------------------------------//
// Crear el usuario
//----------------------------------------------------------//
export const crearUsuario = async (
  nombre, 
  correo, 
  contrasena, 
  rol, 
  cedula, 
  telefono, 
  localidad, 
  codigoverificacion, 
  codigoverificacionexpiracion
) => {
  console.log("========================================");
  console.log(">>> SÍ ESTOY USANDO EL ARCHIVO CORRECTO <<<");
  console.log("========================================");

  const { data, error } = await supabase
    .from('usuario')
    .insert({ 
      nombre, 
      correo, 
      contrasena, 
      rol, 
      cedula,
      telefono,
      localidad,
      isverified: false,
      codigoverificacion, 
      codigoverificacionexpiracion 
    })
    .select('id, nombre, correo, rol')
    .single();

  return { data, error };
};
//----------------------------------------------------------//
// Obtener todos los usuarios (¡AGREGADA!)
//----------------------------------------------------------//
export const obtenerUsuarios = async () => {
  const { data, error } = await supabase
    .from("usuario")
    .select(CAMPOS_PUBLICOS);
  return { data, error };
};


//----------------------------------------------------------//
// Obtener usuario por Email (¡AGREGADA!)
//----------------------------------------------------------//
export const obtenerPorEmail = async (correo) => {
  const { data, error } = await supabase
    .from("usuario")
    .select("*") // Se requiere todo para validar contraseña y verificación en login
    .eq("correo", correo)
    .maybeSingle(); // Evita errores molestos si el usuario no existe aún
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