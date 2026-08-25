import {supabase} from '../config/supabase.js'; // ajusta la ruta según tu proyecto
 
const TABLA = 'vehiculos';
 
export const existeUsuario = async (usuario_id) => {
  const { data, error } = await supabase
    .from('usuario')
    .select('id')
    .eq('id', usuario_id)
    .single();
 
  return !error && !!data;
};
 
export const insertarVehiculo = async (vehiculo) => {
  const { data, error } = await supabase
    .from(TABLA)
    .insert([vehiculo])
    .select()
    .single();
 
  if (error) throw error;
  return data;
};
 
export const listarVehiculos = async ({ usuario_id } = {}) => {
  let query = supabase.from(TABLA).select('*').order('id', { ascending: true });
 
  if (usuario_id) {
    query = query.eq('usuario_id', usuario_id);
  }
 
  const { data, error } = await query;
  if (error) throw error;
  return data;
};
 
export const buscarVehiculoPorId = async (id) => {
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
 
export const actualizarVehiculoPorId = async (id, campos) => {
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
 
export const eliminarVehiculoPorId = async (id) => {
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