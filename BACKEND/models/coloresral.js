import {supabase} from '../config/supabase.js'; // ajusta la ruta según tu proyecto
 
const TABLA = 'colores_ral';
 
export const insertarColor = async (color) => {
  const { data, error } = await supabase
    .from(TABLA)
    .insert([color])
    .select()
    .single();
 
  if (error) throw error;
  return data;
};
 
export const listarColores = async () => {
  const { data, error } = await supabase
    .from(TABLA)
    .select('*')
    .order('id', { ascending: true });
 
  if (error) throw error;
  return data;
};
 
export const buscarColorPorId = async (id) => {
  const { data, error } = await supabase
    .from(TABLA)
    .select('*')
    .eq('id', id)
    .single();
 
  if (error) {
    if (error.code === 'PGRST116') return null;
    throw error;
  }
  return data;
};
 
export const actualizarColorPorId = async (id, campos) => {
  const { data, error } = await supabase
    .from(TABLA)
    .update(campos)
    .eq('id', id)
    .select()
    .single();
 
  if (error) {
    if (error.code === 'PGRST116') return null;
    throw error;
  }
  return data;
};
 
export const eliminarColorPorId = async (id) => {
  const { data, error } = await supabase
    .from(TABLA)
    .delete()
    .eq('id', id)
    .select()
    .single();
 
  if (error) {
    if (error.code === 'PGRST116') return null;
    throw error;
  }
  return data;
};