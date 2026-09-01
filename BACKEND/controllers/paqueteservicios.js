import {
  existeServicio, insertarPaquete, listarPaquetes, buscarPaquetePorId, actualizarPaquetePorId, eliminarPaquetePorId
} from '../models/paqueteservicios.js';
 
// Crear un paquete
export const crearPaquete = async (req, res) => {
  try {
    const {
      servicio_id,
      nombre,
      descripcion,
      precio,
      duracion_dias_min,
      duracion_dias_max,
      destacado
    } = req.body;
 
    if (!servicio_id || !nombre || precio === undefined) {
      return res.status(400).json({
        error: 'servicio_id, nombre y precio son obligatorios'
      });
    }
 
    if (!(await existeServicio(servicio_id))) {
      return res.status(400).json({ error: 'El servicio_id indicado no existe' });
    }
 
    const data = await insertarPaquete({
      servicio_id,
      nombre,
      descripcion: descripcion || null,
      precio,
      duracion_dias_min: duracion_dias_min ?? null,
      duracion_dias_max: duracion_dias_max ?? null,
      destacado: destacado ?? false
    });
 
    return res.status(201).json(data);
  } catch (error) {
    console.error('Error al crear paquete:', error.message);
    return res.status(500).json({ error: 'Error al crear el paquete de servicio' });
  }
};
 
// Obtener todos los paquetes (opcionalmente filtrados por servicio_id / destacado)
export const obtenerPaquetes = async (req, res) => {
  try {
    const { servicio_id, destacado } = req.query;
 
    const data = await listarPaquetes({
      servicio_id,
      destacado: destacado !== undefined ? destacado === 'true' : undefined
    });
 
    return res.status(200).json(data);
  } catch (error) {
    console.error('Error al obtener paquetes:', error.message);
    return res.status(500).json({ error: 'Error al obtener los paquetes de servicio' });
  }
};
 
// Obtener un paquete por id
export const obtenerPaquetePorId = async (req, res) => {
  try {
    const { id } = req.params;
    const data = await buscarPaquetePorId(id);
 
    if (!data) {
      return res.status(404).json({ error: 'Paquete no encontrado' });
    }
 
    return res.status(200).json(data);
  } catch (error) {
    console.error('Error al obtener paquete:', error.message);
    return res.status(500).json({ error: 'Error al obtener el paquete de servicio' });
  }
};
 
// Actualizar un paquete
export const actualizarPaquete = async (req, res) => {
  try {
    const { id } = req.params;
    const {
      servicio_id,
      nombre,
      descripcion,
      precio,
      duracion_dias_min,
      duracion_dias_max,
      destacado
    } = req.body;
 
    if (servicio_id !== undefined && !(await existeServicio(servicio_id))) {
      return res.status(400).json({ error: 'El servicio_id indicado no existe' });
    }
 
    const camposActualizar = {};
    if (servicio_id !== undefined) camposActualizar.servicio_id = servicio_id;
    if (nombre !== undefined) camposActualizar.nombre = nombre;
    if (descripcion !== undefined) camposActualizar.descripcion = descripcion;
    if (precio !== undefined) camposActualizar.precio = precio;
    if (duracion_dias_min !== undefined) camposActualizar.duracion_dias_min = duracion_dias_min;
    if (duracion_dias_max !== undefined) camposActualizar.duracion_dias_max = duracion_dias_max;
    if (destacado !== undefined) camposActualizar.destacado = destacado;
 
    if (Object.keys(camposActualizar).length === 0) {
      return res.status(400).json({ error: 'No se enviaron campos para actualizar' });
    }
 
    const data = await actualizarPaquetePorId(id, camposActualizar);
 
    if (!data) {
      return res.status(404).json({ error: 'Paquete no encontrado' });
    }
 
    return res.status(200).json(data);
  } catch (error) {
    console.error('Error al actualizar paquete:', error.message);
    return res.status(500).json({ error: 'Error al actualizar el paquete de servicio' });
  }
};
 
// Eliminar un paquete
export const eliminarPaquete = async (req, res) => {
  try {
    const { id } = req.params;
    const data = await eliminarPaquetePorId(id);
 
    if (!data) {
      return res.status(404).json({ error: 'Paquete no encontrado' });
    }
 
    return res.status(200).json({ mensaje: 'Paquete eliminado correctamente', paquete: data });
  } catch (error) {
    console.error('Error al eliminar paquete:', error.message);
    return res.status(500).json({ error: 'Error al eliminar el paquete de servicio' });
  }
};