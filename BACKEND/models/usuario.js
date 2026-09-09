// ----------------------------------------------------------//
// Modelo de Usuario - Operaciones con Supabase
//----------------------------------------------------------//
import { supabase } from "../config/supabase.js";

//----------------------------------------------------------//
// Campos públicos (nunca se devuelve la contraseña)
//----------------------------------------------------------//
const CAMPOS_PUBLICOS =
  "id, nombre, email, telefono, localidad, rol, created_at";

//----------------------------------------------------------//
// Crear el usuario
//----------------------------------------------------------//
export const crearUsuario = async (
  nombre, 
  email, 
  contrasena, 
  rol, 
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
      email, 
      contrasena, 
      rol, 
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
// 2. Función específica para los usuarios autenticados con Google
export const crearUsuarioGoogle = async ({ nombre, email, googleId, avatar = null, rol = 'usuario' }) => {
    const { data, error } = await supabase
        .from('usuario')
        .insert({
            nombre,
            email,
            contrasena: null,           // No requiere contraseña
            rol,
            isverified: true,         // Google ya validó este correo
            googleId,
            avatar,
            codigoverificacion: null,
            codigoverificacionexpiracion: null
        })
        .select('id, nombre, correo, rol, avatar')
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