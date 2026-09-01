import {
  existeUsuario, insertarVehiculo, listarVehiculos, buscarVehiculoPorId, actualizarVehiculoPorId, eliminarVehiculoPorId
} from '../models/vehiculos.js';
 
// Crear un vehículo
export const crearVehiculo = async (req, res) => {
  try {
    const { usuario_id, marca, modelo, anio, placa } = req.body;
 
    if (!usuario_id) {
      return res.status(400).json({ error: 'usuario_id es obligatorio' });
    }
 
    if (!(await existeUsuario(usuario_id))) {
      return res.status(400).json({ error: 'El usuario_id indicado no existe' });
    }
 
    const data = await insertarVehiculo({
      usuario_id,
      marca: marca || null,
      modelo: modelo || null,
      anio: anio ?? null,
      placa: placa || null
    });
 
    return res.status(201).json(data);
  } catch (error) {
    console.error('Error al crear vehículo:', error.message);
    return res.status(500).json({ error: 'Error al crear el vehículo' });
  }
};
 
// Obtener todos los vehículos (opcionalmente filtrados por usuario_id)
export const obtenerVehiculos = async (req, res) => {
  try {
    const { usuario_id } = req.query;
    const data = await listarVehiculos({ usuario_id });
    return res.status(200).json(data);
  } catch (error) {
    console.error('Error al obtener vehículos:', error.message);
    return res.status(500).json({ error: 'Error al obtener los vehículos' });
  }
};
 
// Obtener un vehículo por id
export const obtenerVehiculoPorId = async (req, res) => {
  try {
    const { id } = req.params;
    const data = await buscarVehiculoPorId(id);
 
    if (!data) {
      return res.status(404).json({ error: 'Vehículo no encontrado' });
    }
 
    return res.status(200).json(data);
  } catch (error) {
    console.error('Error al obtener vehículo:', error.message);
    return res.status(500).json({ error: 'Error al obtener el vehículo' });
  }
};
 
// Actualizar un vehículo
export const actualizarVehiculo = async (req, res) => {
  try {
    const { id } = req.params;
    const { usuario_id, marca, modelo, anio, placa } = req.body;
 
    if (usuario_id !== undefined && !(await existeUsuario(usuario_id))) {
      return res.status(400).json({ error: 'El usuario_id indicado no existe' });
    }
 
    const camposActualizar = {};
    if (usuario_id !== undefined) camposActualizar.usuario_id = usuario_id;
    if (marca !== undefined) camposActualizar.marca = marca;
    if (modelo !== undefined) camposActualizar.modelo = modelo;
    if (anio !== undefined) camposActualizar.anio = anio;
    if (placa !== undefined) camposActualizar.placa = placa;
 
    if (Object.keys(camposActualizar).length === 0) {
      return res.status(400).json({ error: 'No se enviaron campos para actualizar' });
    }
 
    const data = await actualizarVehiculoPorId(id, camposActualizar);
 
    if (!data) {
      return res.status(404).json({ error: 'Vehículo no encontrado' });
    }
 
    return res.status(200).json(data);
  } catch (error) {
    console.error('Error al actualizar vehículo:', error.message);
    return res.status(500).json({ error: 'Error al actualizar el vehículo' });
  }
};
 
// Eliminar un vehículo
export const eliminarVehiculo = async (req, res) => {
  try {
    const { id } = req.params;
    const data = await eliminarVehiculoPorId(id);
 
    if (!data) {
      return res.status(404).json({ error: 'Vehículo no encontrado' });
    }
 
    return res.status(200).json({ mensaje: 'Vehículo eliminado correctamente', vehiculo: data });
  } catch (error) {
    console.error('Error al eliminar vehículo:', error.message);
    return res.status(500).json({ error: 'Error al eliminar el vehículo' });
  }
};