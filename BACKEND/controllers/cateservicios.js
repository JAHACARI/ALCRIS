import {
  insertarCategoria, listarCategorias, buscarCategoriaPorId, actualizarCategoriaPorId, eliminarCategoriaPorId
} from '../models/categservicio.js';
 
// Crear una categoría
export const crearCategoria = async (req, res) => {
  try {
    const { nombre, descripcion, imagen, color_tema } = req.body;
 
    if (!nombre) {
      return res.status(400).json({ error: 'nombre es obligatorio' });
    }
 
    const data = await insertarCategoria({
      nombre,
      descripcion: descripcion || null,
      imagen: imagen || null,
      color_tema: color_tema || null
    });
 
    return res.status(201).json(data);
  } catch (error) {
    console.error('Error al crear categoría:', error.message);
    return res.status(500).json({ error: 'Error al crear la categoría de servicio' });
  }
};
 
// Obtener todas las categorías
export const obtenerCategorias = async (req, res) => {
  try {
    const data = await listarCategorias();
    return res.status(200).json(data);
  } catch (error) {
    console.error('Error al obtener categorías:', error.message);
    return res.status(500).json({ error: 'Error al obtener las categorías de servicio' });
  }
};
 
// Obtener una categoría por id
export const obtenerCategoriaPorId = async (req, res) => {
  try {
    const { id } = req.params;
    const data = await buscarCategoriaPorId(id);
 
    if (!data) {
      return res.status(404).json({ error: 'Categoría no encontrada' });
    }
 
    return res.status(200).json(data);
  } catch (error) {
    console.error('Error al obtener categoría:', error.message);
    return res.status(500).json({ error: 'Error al obtener la categoría de servicio' });
  }
};
 
// Actualizar una categoría
export const actualizarCategoria = async (req, res) => {
  try {
    const { id } = req.params;
    const { nombre, descripcion, imagen, color_tema } = req.body;
 
    const camposActualizar = {};
    if (nombre !== undefined) camposActualizar.nombre = nombre;
    if (descripcion !== undefined) camposActualizar.descripcion = descripcion;
    if (imagen !== undefined) camposActualizar.imagen = imagen;
    if (color_tema !== undefined) camposActualizar.color_tema = color_tema;
 
    if (Object.keys(camposActualizar).length === 0) {
      return res.status(400).json({ error: 'No se enviaron campos para actualizar' });
    }
 
    const data = await actualizarCategoriaPorId(id, camposActualizar);
 
    if (!data) {
      return res.status(404).json({ error: 'Categoría no encontrada' });
    }
 
    return res.status(200).json(data);
  } catch (error) {
    console.error('Error al actualizar categoría:', error.message);
    return res.status(500).json({ error: 'Error al actualizar la categoría de servicio' });
  }
};
 
// Eliminar una categoría
export const eliminarCategoria = async (req, res) => {
  try {
    const { id } = req.params;
    const data = await eliminarCategoriaPorId(id);
 
    if (!data) {
      return res.status(404).json({ error: 'Categoría no encontrada' });
    }
 
    return res.status(200).json({ mensaje: 'Categoría eliminada correctamente', categoria: data });
  } catch (error) {
    console.error('Error al eliminar categoría:', error.message);
    return res.status(500).json({ error: 'Error al eliminar la categoría de servicio' });
  }
};
 