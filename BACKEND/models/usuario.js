//importacion de conexion con supabase
import {supabase} from '../config/supabase.js';

// crear nuevo usuario
export const crearUsuario=async(nombre, cedula, contrasena, telefono, localidad, rol )=>{
    const {data, error}= await supabase
    .from('usuario')
    .insert({ nombre, correo, contrasena, telefono, localidad, rol})
    .select()
    return {data,error};
};
//obtener todos los usuarios
export const obtenerusuarios = async ()=> {
    const { data, error } = await supabase
        .from('usuario')
        .select('*');
    return { data, error};
};

// buscar el usuario por email para el login
export const obtenerPorEmail= async (correo)=>{
    const {data,error} =await supabase
    .from('usuario')
    .select('*')
    .eq('correo', correo)
    .single();
    return {data,error};
};

//Obtenemos el usuario por su id
export const obtenerUsuarioPorId= async (id) => {
    const {data,error} = await supabase
    .from('usuario')
    .select('*')
    .eq('id', id)
    .single();
    return {data,error};
};

//actualizar el usuario
export const actualizarUsuario = async (id, campos) => {
    const {data, error} = await supabase
    .from('usuarios')
    .update(campos)
    .eq ('id', id)
    .select('id, nombre, correo, contrasena, telefono, localidad, rol');
    return {data, error};
};

//eliminar usuario
//eliminar el usuario
export const eliminarUsuario = async (id) => {
    const {data, error} = await supabase
    .from('usuarios')
    .delete()
    .eq('id', id)
    .select('id, nombre, email, contrasena, telefono, localidad, rol');
    return {data, error};
};

