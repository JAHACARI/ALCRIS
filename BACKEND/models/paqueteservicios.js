import { supabase } from '../config/supabase.js'; 

const TABLA = 'paquetes_servicio';
 
export const existeServicio = async (servicio_id) => {
  const { data, error } = await supabase
    .from('servicios')
    .select('id')
    .eq('id', servicio_id)
    .single();
 
  return !error && !!data;
};
 
export const insertarPaquete = async (paquete) => {
  const { data, error } = await supabase
    .from(TABLA)
    .insert([paquete])
    .select()
    .single();
 
  if (error) throw error;
  return data;
};
 
export const listarPaquetes = async ({ servicio_id, destacado } = {}) => {
  let query = supabase.from(TABLA).select('*').order('id', { ascending: true });
 
  if (servicio_id) {
    query = query.eq('servicio_id', servicio_id);
  }
  if (destacado !== undefined) {
    query = query.eq('destacado', destacado);
  }
 
  const { data, error } = await query;
  if (error) throw error;
  return data;
};
 
export const buscarPaquetePorId = async (id) => {
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
 
export const actualizarPaquetePorId = async (id, campos) => {
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
 
export const eliminarPaquetePorId = async (id) => {
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