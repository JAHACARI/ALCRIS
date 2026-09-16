import {
  crearVehiculo,
  obtenerVehiculosPorUsuario,
  obtenerVehiculoPorId,
  actualizarVehiculo,
  eliminarVehiculo,
} from "../../models/vehiculo/vehiculoModel.js";

export const crear = async (req, res) => {
  try {
    const { marca, modelo, anio, placa, color } = req.body;
    const usuario_id = req.usuario.id;

    if (!marca || !modelo) {
      return res.status(400).json({ error: "Marca y modelo son requeridos" });
    }

    const { data, error } = await crearVehiculo({
      usuario_id,
      marca,
      modelo,
      anio,
      placa,
      color,
    });
    if (error) return res.status(500).json({ error: error.message });

    return res.status(201).json({ message: "Vehículo creado", vehiculo: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const listarMisVehiculos = async (req, res) => {
  try {
    const { data, error } = await obtenerVehiculosPorUsuario(req.usuario.id);
    if (error) return res.status(500).json({ error: error.message });
    return res.status(200).json({ vehiculos: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const obtener = async (req, res) => {
  try {
    const { id } = req.params;
    const { data, error } = await obtenerVehiculoPorId(id);

    if (error || !data) {
      return res.status(404).json({ error: "Vehículo no encontrado" });
    }

    if (
      req.usuario.rol !== "admin" &&
      String(data.usuario_id) !== String(req.usuario.id)
    ) {
      return res.status(403).json({ error: "No tienes permiso" });
    }

    return res.status(200).json({ vehiculo: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const actualizar = async (req, res) => {
  try {
    const { id } = req.params;
    const { data: existente } = await obtenerVehiculoPorId(id);

    if (!existente) {
      return res.status(404).json({ error: "Vehículo no encontrado" });
    }

    if (
      req.usuario.rol !== "admin" &&
      String(existente.usuario_id) !== String(req.usuario.id)
    ) {
      return res.status(403).json({ error: "No tienes permiso" });
    }

    const { marca, modelo, anio, placa, color } = req.body;
    const campos = {};
    if (marca !== undefined) campos.marca = marca;
    if (modelo !== undefined) campos.modelo = modelo;
    if (anio !== undefined) campos.anio = anio;
    if (placa !== undefined) campos.placa = placa;
    if (color !== undefined) campos.color = color;

    const { data, error } = await actualizarVehiculo(id, campos);
    if (error) return res.status(500).json({ error: error.message });

    return res
      .status(200)
      .json({ message: "Vehículo actualizado", vehiculo: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const eliminar = async (req, res) => {
  try {
    const { id } = req.params;
    const { data: existente } = await obtenerVehiculoPorId(id);

    if (!existente) {
      return res.status(404).json({ error: "Vehículo no encontrado" });
    }

    if (
      req.usuario.rol !== "admin" &&
      String(existente.usuario_id) !== String(req.usuario.id)
    ) {
      return res.status(403).json({ error: "No tienes permiso" });
    }

    const { data, error } = await eliminarVehiculo(id);
    if (error) return res.status(500).json({ error: error.message });

    return res
      .status(200)
      .json({ message: "Vehículo eliminado", vehiculo: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};
