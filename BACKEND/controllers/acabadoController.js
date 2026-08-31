//----------------------------------------------------------//
// Controlador de Acabados de Pintura
import {
  crearAcabado,
  obtenerAcabados,
  obtenerAcabadoPorId,
  actualizarAcabado,
  eliminarAcabado,
} from "../models/acabadoModel.js";

//----------------------------------------------------------//
// Crear acabado (solo admin)
export const createAcabado = async (req, res) => {
  try {
    const { nombre } = req.body;

    if (!nombre || nombre.trim() === "") {
      return res.status(400).json({ error: "El nombre es obligatorio" });
    }

    const { data, error } = await crearAcabado(nombre.trim());

    if (error) {
      console.error("Error al crear acabado:", error);
      return res.status(500).json({ error: error.message });
    }

    return res.status(201).json({
      message: "Acabado creado exitosamente",
      acabado: data,
    });
  } catch (error) {
    console.error("Error al crear acabado:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};

//----------------------------------------------------------//
// Obtener todos los acabados
export const getAcabados = async (req, res) => {
  try {
    const { data, error } = await obtenerAcabados();
    if (error) {
      return res.status(500).json({ error: error.message });
    }
    return res.status(200).json({ acabados: data });
  } catch (error) {
    console.error("Error al obtener acabados:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};

//----------------------------------------------------------//
// Obtener acabado por ID
export const getAcabadoPorId = async (req, res) => {
  try {
    const { id } = req.params;
    const { data, error } = await obtenerAcabadoPorId(id);

    if (error || !data) {
      return res.status(404).json({ error: "Acabado no encontrado" });
    }

    return res.status(200).json({ acabado: data });
  } catch (error) {
    console.error("Error al obtener acabado:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};

//----------------------------------------------------------//
// Actualizar acabado (solo admin)
export const updateAcabado = async (req, res) => {
  try {
    const { id } = req.params;
    const { nombre } = req.body;

    if (!nombre || nombre.trim() === "") {
      return res.status(400).json({ error: "El nombre es obligatorio" });
    }

    const { data: existente, error: errorExistente } = await obtenerAcabadoPorId(id);
    if (errorExistente || !existente) {
      return res.status(404).json({ error: "Acabado no encontrado" });
    }

    const { data, error } = await actualizarAcabado(id, { nombre: nombre.trim() });
    if (error) {
      return res.status(500).json({ error: error.message });
    }

    return res.status(200).json({
      message: "Acabado actualizado correctamente",
      acabado: data,
    });
  } catch (error) {
    console.error("Error al actualizar acabado:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};

//----------------------------------------------------------//
// Eliminar acabado (solo admin)
export const deleteAcabado = async (req, res) => {
  try {
    const { id } = req.params;

    const { data: existente, error: errorExistente } = await obtenerAcabadoPorId(id);
    if (errorExistente || !existente) {
      return res.status(404).json({ error: "Acabado no encontrado" });
    }

    const { data, error } = await eliminarAcabado(id);
    if (error) {
      return res.status(500).json({ error: error.message });
    }

    return res.status(200).json({
      message: "Acabado eliminado correctamente",
      acabado: data,
    });
  } catch (error) {
    console.error("Error al eliminar acabado:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};