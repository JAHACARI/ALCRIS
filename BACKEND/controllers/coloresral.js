import {
  insertarColor,
  listarColores,
  buscarColorPorId,
  actualizarColorPorId, // <-- Conectado con tu función del modelo
  eliminarColorPorId
} from '../models/coloresral.js';

// Crear un nuevo color
export const crearColor = async (req, res) => {
  try {
    const data = await insertarColor(req.body);
    return res.status(201).json(data);
  } catch (error) {
    console.error('Error al crear color:', error.message);
    return res.status(500).json({ error: 'Error al crear el color' });
  }
};

// Obtener todos los colores
export const obtenerColores = async (req, res) => {
  try {
    const data = await listarColores();
    return res.status(200).json(data);
  } catch (error) {
    console.error('Error al obtener colores:', error.message);
    return res.status(500).json({ error: 'Error al obtener los colores' });
  }
};

// Obtener un color por ID
export const obtenerColorPorId = async (req, res) => {
  try {
    const { id } = req.params;
    const data = await buscarColorPorId(id);
    if (!data) return res.status(404).json({ error: 'Color no encontrado' });
    return res.status(200).json(data);
  } catch (error) {
    console.error('Error al obtener color:', error.message);
    return res.status(500).json({ error: 'Error al obtener el color' });
  }
};

// Actualizar un color (La función que tus rutas estaban buscando)
export const actualizarColor = async (req, res) => {
  try {
    const { id } = req.params;
    const data = await actualizarColorPorId(id, req.body);
    if (!data) return res.status(404).json({ error: 'Color no encontrado o sin cambios' });
    return res.status(200).json(data);
  } catch (error) {
    console.error('Error al actualizar color:', error.message);
    return res.status(500).json({ error: 'Error al actualizar el color' });
  }
};

// Eliminar un color
export const eliminarColor = async (req, res) => {
  try {
    const { id } = req.params;
    const data = await eliminarColorPorId(id);
    if (!data) return res.status(404).json({ error: 'Color no encontrado' });
    return res.status(200).json({ mensaje: 'Color eliminado correctamente', color: data });
  } catch (error) {
    console.error('Error al eliminar color:', error.message);
    return res.status(500).json({ error: 'Error al eliminar el color' });
  }
};