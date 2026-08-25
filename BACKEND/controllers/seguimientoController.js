//----------------------------------------------------------//
// Controlador de Seguimiento de Reserva
//----------------------------------------------------------//
import {
  crearSeguimiento,
  crearSeguimientosMultiples,
  obtenerSeguimientosPorReserva,
  obtenerSeguimientoPorId,
  actualizarSeguimiento,
  eliminarSeguimiento,
} from "../models/seguimientoModel.js";
import { obtenerReservaPorId } from "../models/reservaModel.js";

//----------------------------------------------------------//
// Estados permitidos
//----------------------------------------------------------//
const ESTADOS = ["pendiente", "en_curso", "completado"];

//----------------------------------------------------------//
// Crear un seguimiento
//----------------------------------------------------------//
export const createSeguimiento = async (req, res) => {
  try {
    const { reserva_id, etapa_id, estado } = req.body;

    if (!reserva_id || !etapa_id) {
      return res.status(400).json({
        error: "Faltan campos obligatorios (reserva_id, etapa_id)",
      });
    }

    // Verificar que la reserva exista
    const { data: reserva, error: errorReserva } = await obtenerReservaPorId(reserva_id);
    if (errorReserva || !reserva) {
      return res.status(404).json({ error: "Reserva no encontrada" });
    }

    // Solo admin puede crear seguimientos (o el dueño, según tu regla)
    if (req.usuario.rol !== "admin" && req.usuario.id !== reserva.usuario_id) {
      return res.status(403).json({ error: "No tienes permiso para crear seguimiento en esta reserva" });
    }

    const estadoFinal = estado || "pendiente";
    if (!ESTADOS.includes(estadoFinal)) {
      return res.status(400).json({
        error: `estado inválido. Valores permitidos: ${ESTADOS.join(", ")}`,
      });
    }

    const datos = {
      reserva_id,
      etapa_id,
      estado: estadoFinal,
      fecha_actualizacion: new Date().toISOString(),
    };

    const { data, error } = await crearSeguimiento(datos);

    if (error) {
      // Error de unique constraint (reserva_id + etapa_id ya existe)
      if (error.code === "23505") {
        return res.status(400).json({
          error: "Ya existe un seguimiento para esta reserva y etapa",
        });
      }
      console.error("Error al crear seguimiento:", error);
      return res.status(500).json({ error: error.message });
    }

    return res.status(201).json({
      message: "Seguimiento creado exitosamente",
      seguimiento: data,
    });
  } catch (error) {
    console.error("Error al crear seguimiento:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};

//----------------------------------------------------------//
// Obtener seguimientos de una reserva
//----------------------------------------------------------//
export const getSeguimientosPorReserva = async (req, res) => {
  try {
    const { reservaId } = req.params;

    // Verificar que la reserva exista y permisos
    const { data: reserva, error: errorReserva } = await obtenerReservaPorId(reservaId);
    if (errorReserva || !reserva) {
      return res.status(404).json({ error: "Reserva no encontrada" });
    }

    if (req.usuario.rol !== "admin" && req.usuario.id !== reserva.usuario_id) {
      return res.status(403).json({ error: "No tienes permiso para ver el seguimiento de esta reserva" });
    }

    const { data, error } = await obtenerSeguimientosPorReserva(reservaId);
    if (error) {
      return res.status(500).json({ error: error.message });
    }

    return res.status(200).json({ seguimientos: data });
  } catch (error) {
    console.error("Error al obtener seguimientos:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};

//----------------------------------------------------------//
// Obtener un seguimiento por ID
//----------------------------------------------------------//
export const getSeguimientoPorId = async (req, res) => {
  try {
    const { id } = req.params;
    const { data, error } = await obtenerSeguimientoPorId(id);

    if (error || !data) {
      return res.status(404).json({ error: "Seguimiento no encontrado" });
    }

    // Verificar permisos a través de la reserva
    const { data: reserva } = await obtenerReservaPorId(data.reserva_id);
    if (!reserva) {
      return res.status(404).json({ error: "Reserva asociada no encontrada" });
    }

    if (req.usuario.rol !== "admin" && req.usuario.id !== reserva.usuario_id) {
      return res.status(403).json({ error: "No tienes permiso para ver este seguimiento" });
    }

    return res.status(200).json({ seguimiento: data });
  } catch (error) {
    console.error("Error al obtener seguimiento:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};

//----------------------------------------------------------//
// Actualizar estado de un seguimiento
//----------------------------------------------------------//
export const updateSeguimiento = async (req, res) => {
  try {
    const { id } = req.params;
    const { estado } = req.body;

    if (!estado) {
      return res.status(400).json({ error: "El campo estado es obligatorio" });
    }

    if (!ESTADOS.includes(estado)) {
      return res.status(400).json({
        error: `estado inválido. Valores permitidos: ${ESTADOS.join(", ")}`,
      });
    }

    // Verificar que exista
    const { data: seguimientoExistente, error: errorExistente } = await obtenerSeguimientoPorId(id);
    if (errorExistente || !seguimientoExistente) {
      return res.status(404).json({ error: "Seguimiento no encontrado" });
    }

    // Verificar permisos
    const { data: reserva } = await obtenerReservaPorId(seguimientoExistente.reserva_id);
    if (!reserva) {
      return res.status(404).json({ error: "Reserva asociada no encontrada" });
    }

    // Solo admin puede cambiar el estado del seguimiento (puedes relajar esta regla)
    if (req.usuario.rol !== "admin") {
      return res.status(403).json({ error: "Solo un administrador puede actualizar el seguimiento" });
    }

    const campos = {
      estado,
      fecha_actualizacion: new Date().toISOString(),
    };

    const { data, error } = await actualizarSeguimiento(id, campos);
    if (error) {
      return res.status(500).json({ error: error.message });
    }

    return res.status(200).json({
      message: "Seguimiento actualizado correctamente",
      seguimiento: data,
    });
  } catch (error) {
    console.error("Error al actualizar seguimiento:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};

//----------------------------------------------------------//
// Eliminar seguimiento (solo admin)
//----------------------------------------------------------//
export const deleteSeguimiento = async (req, res) => {
  try {
    const { id } = req.params;

    const { data: seguimientoExistente, error: errorExistente } = await obtenerSeguimientoPorId(id);
    if (errorExistente || !seguimientoExistente) {
      return res.status(404).json({ error: "Seguimiento no encontrado" });
    }

    const { data, error } = await eliminarSeguimiento(id);
    if (error) {
      return res.status(500).json({ error: error.message });
    }

    return res.status(200).json({
      message: "Seguimiento eliminado correctamente",
      seguimiento: data,
    });
  } catch (error) {
    console.error("Error al eliminar seguimiento:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};