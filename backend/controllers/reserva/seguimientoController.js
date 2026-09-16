import {
  actualizarSeguimiento,
  obtenerSeguimientoPorReserva,
} from "../../models/reserva/seguimientoModel.js";
import { obtenerEtapas } from "../../models/catalogo/etapaModel.js";

export const actualizarEstado = async (req, res) => {
  try {
    const { id } = req.params;
    const { estado, notas } = req.body;

    if (!estado || !["pendiente", "en_curso", "completado"].includes(estado)) {
      return res.status(400).json({
        error: "Estado inválido. Usa: pendiente, en_curso, completado",
      });
    }

    const { data, error } = await actualizarSeguimiento(id, { estado, notas });
    if (error) return res.status(500).json({ error: error.message });

    return res
      .status(200)
      .json({ message: "Seguimiento actualizado", seguimiento: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const listarPorReserva = async (req, res) => {
  try {
    const { reserva_id } = req.params;
    const { data, error } = await obtenerSeguimientoPorReserva(reserva_id);
    if (error) return res.status(500).json({ error: error.message });
    return res.status(200).json({ seguimiento: data || [] });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const listarEtapas = async (req, res) => {
  try {
    const { data, error } = await obtenerEtapas();
    if (error) return res.status(500).json({ error: error.message });
    return res.status(200).json({ etapas: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};
