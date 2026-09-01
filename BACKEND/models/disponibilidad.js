import { supabase } from '../config/supabase.js';

// Obtener toda la disponibilidad
export const obtenerDisponibilidad = async () => {
    const { data, error } = await supabase
        .from('disponibilidad')
        .select('*')
        .order('fecha', { ascending: true });
    return { data, error };
};

// Obtener disponibilidad por técnico
export const obtenerDisponibilidadPorTecnico = async (tecnico_id) => {
    const { data, error } = await supabase
        .from('disponibilidad')
        .select('*')
        .eq('tecnico_id', tecnico_id)
        .order('fecha', { ascending: true });
    return { data, error };
};

// Obtener slots disponibles (opcionalmente filtrados por fecha)
export const obtenerSlotsDisponibles = async (fecha = null) => {
    let query = supabase
        .from('disponibilidad')
        .select('*')
        .eq('disponible', true);

    if (fecha) {
        query = query.eq('fecha', fecha);
    }

    const { data, error } = await query.order('fecha', { ascending: true });
    return { data, error };
};

// Obtener un slot por ID
export const obtenerDisponibilidadPorId = async (id) => {
    const { data, error } = await supabase
        .from('disponibilidad')
        .select('*')
        .eq('id', id)
        .single();
    return { data, error };
};

// Crear disponibilidad
export const crearDisponibilidad = async (tecnico_id, fecha, hora, disponible = true) => {
    const { data, error } = await supabase
        .from('disponibilidad')
        .insert({ tecnico_id, fecha, hora, disponible })
        .select();
    return { data, error };
};

// Actualizar disponibilidad
export const actualizarDisponibilidad = async (id, campos) => {
    const { data, error } = await supabase
        .from('disponibilidad')
        .update(campos)
        .eq('id', id)
        .select();
    return { data, error };
};

// Eliminar disponibilidad
export const eliminarDisponibilidad = async (id) => {
    const { data, error } = await supabase
        .from('disponibilidad')
        .delete()
        .eq('id', id)
        .select();
    return { data, error };
};