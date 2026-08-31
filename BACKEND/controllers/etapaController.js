//----------------------------------------------------------//
// Controlador de Etapas de Proceso
import {
  crearEtapa,
  obtenerEtapas,
  obtenerEtapaPorId,
  actualizarEtapa,
  eliminarEtapa,
} from "../models/etapaModel.js";

//----------------------------------------------------------//
// Crear etapa (solo admin)
export const createEtapa = async (req, res) => {
  try {
    const { nombre, orden } = req.body;

    if (!nombre || nombre.trim() === "") {
      return res.status(400).json({ error: "El nombre es obligatorio" });
    }

    if (orden === undefined || orden === null || isNaN(orden)) {
      return res.status(400).json({ error: "El orden es obligatorio y debe ser un número" });
    }

    const { data, error } = await crearEtapa(nombre.trim(), Number(orden));

    if (error) {
      console.error("Error al crear etapa:", error);
      return res.status(500).json({ error: error.message });
    }

    return res.status(201).json({
      message: "Etapa creada exitosamente",
      etapa: data,
    });
  } catch (error) {
    console.error("Error al crear etapa:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};

//----------------------------------------------------------//
// Obtener todas las etapas
export const getEtapas = async (req, res) => {
  try {
    const { data, error } = await obtenerEtapas();
    if (error) {
      return res.status(500).json({ error: error.message });
    }
    return res.status(200).json({ etapas: data });
  } catch (error) {
    console.error("Error al obtener etapas:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};

//----------------------------------------------------------//
// Obtener etapa por ID
export const getEtapaPorId = async (req, res) => {
  try {
    const { id } = req.params;
    const { data, error } = await obtenerEtapaPorId(id);

    if (error || !data) {
      return res.status(404).json({ error: "Etapa no encontrada" });
    }

    return res.status(200).json({ etapa: data });
  } catch (error) {
    console.error("Error al obtener etapa:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};

//----------------------------------------------------------//
// Actualizar etapa (solo admin)
export const updateEtapa = async (req, res) => {
  try {
    const { id } = req.params;
    const { nombre, orden } = req.body;

    const { data: existente, error: errorExistente } = await obtenerEtapaPorId(id);
    if (errorExistente || !existente) {
      return res.status(404).json({ error: "Etapa no encontrada" });
    }

    const campos = {};
    if (nombre !== undefined) {
      if (nombre.trim() === "") {
        return res.status(400).json({ error: "El nombre no puede estar vacío" });
      }
      campos.nombre = nombre.trim();
    }
    if (orden !== undefined) {
      if (isNaN(orden)) {
        return res.status(400).json({ error: "El orden debe ser un número" });
      }
      campos.orden = Number(orden);
    }

    if (Object.keys(campos).length === 0) {
      return res.status(400).json({ error: "No se enviaron campos válidos para actualizar" });
    }

    const { data, error } = await actualizarEtapa(id, campos);
    if (error) {
      return res.status(500).json({ error: error.message });
    }

    return res.status(200).json({
      message: "Etapa actualizada correctamente",
      etapa: data,
    });
  } catch (error) {
    console.error("Error al actualizar etapa:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};

//----------------------------------------------------------//
// Eliminar etapa (solo admin)
export const deleteEtapa = async (req, res) => {
  try {
    const { id } = req.params;

    const { data: existente, error: errorExistente } = await obtenerEtapaPorId(id);
    if (errorExistente || !existente) {
      return res.status(404).json({ error: "Etapa no encontrada" });
    }

    const { data, error } = await eliminarEtapa(id);
    if (error) {
      return res.status(500).json({ error: error.message });
    }

    return res.status(200).json({
      message: "Etapa eliminada correctamente",
      etapa: data,
    });
  } catch (error) {
    console.error("Error al eliminar etapa:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};