import { supabase } from '../config/supabase.js';

// Crear nuevo usuario
export const crearUsuario = async (nombre, correo, contrasena, telefono, localidad, rol) => {
    const { data, error } = await supabase
        .from('usuario')
        .insert({ nombre, correo, contrasena, telefono, localidad, rol })
        .select();
    return { data, error };
};

// Obtener todos los usuarios
export const obtenerUsuarios = async () => {
    const { data, error } = await supabase
        .from('usuario')
        .select('*');
    return { data, error };
};

// Buscar usuario por correo (para login)
export const obtenerPorEmail = async (correo) => {
    const { data, error } = await supabase
        .from('usuario')
        .select('*')
        .eq('correo', correo)
        .single();
    return { data, error };
};

// Obtener usuario por ID
export const obtenerUsuarioPorId = async (id) => {
    const { data, error } = await supabase
        .from('usuario')
        .select('*')
        .eq('id', id)
        .single();
    return { data, error };
};

// Actualizar usuario
export const actualizarUsuario = async (id, campos) => {
    const { data, error } = await supabase
        .from('usuario')
        .update(campos)
        .eq('id', id)
        .select('id, nombre, correo, telefono, localidad, rol');
    return { data, error };
};

// Eliminar usuario
export const eliminarUsuario = async (id) => {
    const { data, error } = await supabase
        .from('usuario')
        .delete()
        .eq('id', id)
        .select('id, nombre, correo, telefono, localidad, rol');
    return { data, error };
};
