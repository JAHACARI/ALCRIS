import { supabase } from '../config/supabase.js';

export const obtenerServicios = async () => {
    const { data, error } = await supabase
        .from('servicios')
        .select('*')
        .order('nombre', { ascending: true });
    return { data, error };
};

export const obtenerServicioPorId = async (id) => {
    const { data, error } = await supabase
        .from('servicios')
        .select('*')
        .eq('id', id)
        .single();
    return { data, error };
};

export const crearServicio = async (nombre, descripcion, precio, duracion_minutos) => {
    const { data, error } = await supabase
        .from('servicios')
        .insert({ nombre, descripcion, precio, duracion_minutos })
        .select();
    return { data, error };
};

export const actualizarServicio = async (id, campos) => {
    const { data, error } = await supabase
        .from('servicios')
        .update(campos)
        .eq('id', id)
        .select();
    return { data, error };
};

export const eliminarServicio = async (id) => {
    const { data, error } = await supabase
        .from('servicios')
        .delete()
        .eq('id', id)
        .select();
    return { data, error };
};