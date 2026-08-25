import { supabase } from '../config/supabase.js';

export const obtenerTecnicos = async () => {
    const { data, error } = await supabase
        .from('tecnicos')
        .select('*')
        .order('nombre', { ascending: true });
    return { data, error };
};

export const obtenerTecnicoPorId = async (id) => {
    const { data, error } = await supabase
        .from('tecnicos')
        .select('*')
        .eq('id', id)
        .single();
    return { data, error };
};

export const crearTecnico = async (nombre, telefono, especialidad, activo = true) => {
    const { data, error } = await supabase
        .from('tecnicos')
        .insert({ nombre, telefono, especialidad, activo })
        .select();
    return { data, error };
};

export const actualizarTecnico = async (id, campos) => {
    const { data, error } = await supabase
        .from('tecnicos')
        .update(campos)
        .eq('id', id)
        .select();
    return { data, error };
};

export const eliminarTecnico = async (id) => {
    const { data, error } = await supabase
        .from('tecnicos')
        .delete()
        .eq('id', id)
        .select();
    return { data, error };
};