import {
  crearReserva,
  obtenerReservas,
  obtenerReservasPorUsuario,
  obtenerReservaPorId,
  actualizarReserva,
  eliminarReserva,
} from "../../models/reserva/reservaModel.js";
import {
  crearSeguimiento,
  obtenerSeguimientoPorReserva,
} from "../../models/reserva/seguimientoModel.js";
import { obtenerEtapas } from "../../models/catalogo/etapaModel.js";

export const crear = async (req, res) => {
  try {
    const {
      vehiculo_id,
      servicio_id,
      paquete_id,
      tecnico_id,
      color_id,
      acabado_id,
      fecha_cita,
      hora_cita,
      subtotal = 0,
      materiales = 0,
      descuento = 0,
      total = 0,
      forma_pago = "efectivo",
      notas,
    } = req.body;

    if (!servicio_id || !fecha_cita || !hora_cita) {
      return res
        .status(400)
        .json({ error: "servicio_id, fecha_cita y hora_cita son requeridos" });
    }

    const { data, error } = await crearReserva({
      usuario_id: req.usuario.id,
      vehiculo_id,
      servicio_id,
      paquete_id,
      tecnico_id,
      color_id,
      acabado_id,
      fecha_cita,
      hora_cita,
      subtotal,
      materiales,
      descuento,
      total,
      forma_pago,
      notas,
    });

    if (error) return res.status(500).json({ error: error.message });

    // Crear seguimiento inicial con todas las etapas
    const { data: etapas } = await obtenerEtapas();
    if (etapas && etapas.length > 0) {
      for (const etapa of etapas) {
        await crearSeguimiento({
          reserva_id: data.id,
          etapa_id: etapa.id,
          estado: etapa.orden === 1 ? "en_curso" : "pendiente",
        });
      }
    }

    return res.status(201).json({ message: "Reserva creada", reserva: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const listar = async (req, res) => {
  try {
    const { data, error } =
      req.usuario.rol === "admin"
        ? await obtenerReservas()
        : await obtenerReservasPorUsuario(req.usuario.id);

    if (error) return res.status(500).json({ error: error.message });
    return res.status(200).json({ reservas: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const obtener = async (req, res) => {
  try {
    const { data, error } = await obtenerReservaPorId(req.params.id);
    if (error || !data)
      return res.status(404).json({ error: "Reserva no encontrada" });

    if (
      req.usuario.rol !== "admin" &&
      String(data.usuario_id) !== String(req.usuario.id)
    ) {
      return res.status(403).json({ error: "No tienes permiso" });
    }

    const { data: seguimiento } = await obtenerSeguimientoPorReserva(data.id);

    return res
      .status(200)
      .json({ reserva: data, seguimiento: seguimiento || [] });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const actualizar = async (req, res) => {
  try {
    const { data: existente } = await obtenerReservaPorId(req.params.id);
    if (!existente)
      return res.status(404).json({ error: "Reserva no encontrada" });

    const campos = { ...req.body };
    if (req.usuario.rol !== "admin") {
      delete campos.estado;
      delete campos.tecnico_id;
      if (req.body.estado && req.body.estado !== "cancelada") {
        return res
          .status(403)
          .json({ error: "Solo puedes cancelar tu reserva" });
      }
    }

    const { data, error } = await actualizarReserva(req.params.id, campos);
    if (error) return res.status(500).json({ error: error.message });

    return res
      .status(200)
      .json({ message: "Reserva actualizada", reserva: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const eliminar = async (req, res) => {
  try {
    const { data, error } = await eliminarReserva(req.params.id);
    if (error) return res.status(500).json({ error: error.message });
    return res
      .status(200)
      .json({ message: "Reserva eliminada", reserva: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};
