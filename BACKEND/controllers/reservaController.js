//----------------------------------------------------------//
// Controlador de Reservas

import {
  crearReserva,
  obtenerReservas,
  obtenerReservasPorUsuario,
  obtenerReservaPorId,
  obtenerReservaPorCodigo,
  actualizarReserva,
  eliminarReserva,
} from "../models/reservaModel.js";

//----------------------------------------------------------//
// Valores permitidos (enums)

const FORMAS_PAGO = ["efectivo", "transferencia"];
const ESTADOS = ["pendiente", "confirmada", "en_proceso", "completada", "cancelada"];

//----------------------------------------------------------//
// Campos que se pueden actualizar libremente

const CAMPOS_PERMITIDOS = [
  "vehiculo_id",
  "servicio_id",
  "paquete_id",
  "tecnico_id",
  "color_id",
  "acabado_id",
  "fecha_cita",
  "hora_cita",
  "subtotal",
  "materiales",
  "descuento",
  "total",
  "forma_pago",
];

//----------------------------------------------------------//
// Generar código de reserva único (ej: RES-20260824-4831)

const generarCodigoReserva = () => {
  const fecha = new Date();
  const año = fecha.getFullYear();
  const mes = String(fecha.getMonth() + 1).padStart(2, "0");
  const dia = String(fecha.getDate()).padStart(2, "0");
  const random = Math.floor(1000 + Math.random() * 9000);
  return `RES-${año}${mes}${dia}-${random}`;
};

//----------------------------------------------------------//
// Crear reserva

export const createReserva = async (req, res) => {
  try {
    const body = req.body;

    // Campos obligatorios
    if (!body.servicio_id || !body.fecha_cita || !body.hora_cita || !body.forma_pago) {
      return res.status(400).json({
        error: "Faltan campos obligatorios (servicio_id, fecha_cita, hora_cita, forma_pago)",
      });
    }

    // Validar forma de pago
    if (!FORMAS_PAGO.includes(body.forma_pago)) {
      return res.status(400).json({
        error: `forma_pago inválida. Valores permitidos: ${FORMAS_PAGO.join(", ")}`,
      });
    }

    // El usuario_id siempre se toma del token (no del body)
    const usuario_id = req.usuario.id;

    // Generar código único
    let codigo_reserva = generarCodigoReserva();
    // Verificar que no exista (muy raro, pero por seguridad)
    const { data: existe } = await obtenerReservaPorCodigo(codigo_reserva);
    if (existe) {
      codigo_reserva = generarCodigoReserva(); // reintentar una vez
    }

    const datos = {
      codigo_reserva,
      usuario_id,
      vehiculo_id: body.vehiculo_id || null,
      servicio_id: body.servicio_id,
      paquete_id: body.paquete_id || null,
      tecnico_id: body.tecnico_id || null,
      color_id: body.color_id || null,
      acabado_id: body.acabado_id || null,
      fecha_cita: body.fecha_cita,
      hora_cita: body.hora_cita,
      subtotal: body.subtotal ?? 0,
      materiales: body.materiales ?? 0,
      descuento: body.descuento ?? 0,
      total: body.total ?? 0,
      forma_pago: body.forma_pago,
      estado: "pendiente",
    };

    const { data, error } = await crearReserva(datos);

    if (error) {
      console.error("Error al crear reserva:", error);
      return res.status(500).json({ error: error.message });
    }

    return res.status(201).json({
      message: "Reserva creada exitosamente",
      reserva: data,
    });
  } catch (error) {
    console.error("Error al crear reserva:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};

//----------------------------------------------------------//
// Obtener todas las reservas (solo admin)

export const getReservas = async (req, res) => {
  try {
    const { data, error } = await obtenerReservas();
    if (error) {
      return res.status(500).json({ error: error.message });
    }
    return res.status(200).json({ reservas: data });
  } catch (error) {
    console.error("Error al obtener reservas:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};

//----------------------------------------------------------//
// Obtener mis reservas (usuario autenticado)

export const getMisReservas = async (req, res) => {
  try {
    const { data, error } = await obtenerReservasPorUsuario(req.usuario.id);
    if (error) {
      return res.status(500).json({ error: error.message });
    }
    return res.status(200).json({ reservas: data });
  } catch (error) {
    console.error("Error al obtener mis reservas:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};

//----------------------------------------------------------//
// Obtener reserva por ID

export const getReservaPorId = async (req, res) => {
  try {
    const { id } = req.params;
    const { data, error } = await obtenerReservaPorId(id);

    if (error || !data) {
      return res.status(404).json({ error: "Reserva no encontrada" });
    }

    // Solo admin o el dueño de la reserva
    if (req.usuario.rol !== "admin" && req.usuario.id !== data.usuario_id) {
      return res.status(403).json({ error: "No tienes permiso para ver esta reserva" });
    }

    return res.status(200).json({ reserva: data });
  } catch (error) {
    console.error("Error al obtener reserva:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};

//----------------------------------------------------------//
// Obtener reserva por código

export const getReservaPorCodigo = async (req, res) => {
  try {
    const { codigo } = req.params;
    const { data, error } = await obtenerReservaPorCodigo(codigo);

    if (error || !data) {
      return res.status(404).json({ error: "Reserva no encontrada" });
    }

    // Solo admin o el dueño
    if (req.usuario.rol !== "admin" && req.usuario.id !== data.usuario_id) {
      return res.status(403).json({ error: "No tienes permiso para ver esta reserva" });
    }

    return res.status(200).json({ reserva: data });
  } catch (error) {
    console.error("Error al obtener reserva por código:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};

//----------------------------------------------------------//
// Actualizar reserva

export const updateReserva = async (req, res) => {
  try {
    const { id } = req.params;
    const body = req.body;

    // Verificar que exista
    const { data: reservaExistente, error: errorExistente } = await obtenerReservaPorId(id);
    if (errorExistente || !reservaExistente) {
      return res.status(404).json({ error: "Reserva no encontrada" });
    }

    // Solo admin o el dueño
    if (req.usuario.rol !== "admin" && req.usuario.id !== reservaExistente.usuario_id) {
      return res.status(403).json({ error: "No tienes permiso para actualizar esta reserva" });
    }

    // Filtrar campos permitidos
    const campos = {};
    for (const campo of CAMPOS_PERMITIDOS) {
      if (body[campo] !== undefined) {
        campos[campo] = body[campo];
      }
    }

    // Solo admin puede cambiar el estado
    if (body.estado !== undefined) {
      if (req.usuario.rol !== "admin") {
        return res.status(403).json({ error: "No tienes permiso para cambiar el estado" });
      }
      if (!ESTADOS.includes(body.estado)) {
        return res.status(400).json({
          error: `estado inválido. Valores permitidos: ${ESTADOS.join(", ")}`,
        });
      }
      campos.estado = body.estado;
    }

    // Validar forma_pago si viene
    if (campos.forma_pago && !FORMAS_PAGO.includes(campos.forma_pago)) {
      return res.status(400).json({
        error: `forma_pago inválida. Valores permitidos: ${FORMAS_PAGO.join(", ")}`,
      });
    }

    if (Object.keys(campos).length === 0) {
      return res.status(400).json({ error: "No se enviaron campos válidos para actualizar" });
    }

    const { data, error } = await actualizarReserva(id, campos);
    if (error) {
      return res.status(500).json({ error: error.message });
    }

    return res.status(200).json({
      message: "Reserva actualizada correctamente",
      reserva: data,
    });
  } catch (error) {
    console.error("Error al actualizar reserva:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};

//----------------------------------------------------------//
// Eliminar reserva (solo admin)

export const deleteReserva = async (req, res) => {
  try {
    const { id } = req.params;

    const { data: reservaExistente, error: errorExistente } = await obtenerReservaPorId(id);
    if (errorExistente || !reservaExistente) {
      return res.status(404).json({ error: "Reserva no encontrada" });
    }

    const { data, error } = await eliminarReserva(id);
    if (error) {
      return res.status(500).json({ error: error.message });
    }

    return res.status(200).json({
      message: "Reserva eliminada correctamente",
      reserva: data,
    });
  } catch (error) {
    console.error("Error al eliminar reserva:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};