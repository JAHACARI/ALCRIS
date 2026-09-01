import {supabase} from '../config/supabase.js'; // ajusta la ruta según tu proyecto
 
const TABLA = 'categorias_servicio';
 
export const insertarCategoria = async (categoria) => {
  const { data, error } = await supabase
    .from(TABLA)
    .insert([categoria])
    .select()
    .single();
 
  if (error) throw error;
  return data;
};
 
export const listarCategorias = async () => {
  const { data, error } = await supabase
    .from(TABLA)
    .select('*')
    .order('id', { ascending: true });
 
  if (error) throw error;
  return data;
};
 
export const buscarCategoriaPorId = async (id) => {
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
 
export const actualizarCategoriaPorId = async (id, campos) => {
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
 
export const eliminarCategoriaPorId = async (id) => {
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
 