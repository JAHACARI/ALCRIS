import * as model from "../../models/tecnico/horarioModel.js";

export const crear = async (req, res) => {
  try {
    const { tecnico_id, fecha, hora, disponible } = req.body;
    if (!tecnico_id || !fecha || !hora) {
      return res.status(400).json({ error: "tecnico_id, fecha y hora son requeridos" });
    }

    const { data, error } = await model.crearHorario({ tecnico_id, fecha, hora, disponible });
    if (error) return res.status(500).json({ error: error.message });
    return res.status(201).json({ message: "Horario creado", horario: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const listar = async (req, res) => {
  try {
    const { tecnico_id } = req.params;
    const fecha = req.query.fecha || null;
    const { data, error } = await model.obtenerHorariosPorTecnico(tecnico_id, fecha);
    if (error) return res.status(500).json({ error: error.message });
    return res.status(200).json({ horarios: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const actualizar = async (req, res) => {
  try {
    const { data, error } = await model.actualizarHorario(req.params.id, req.body);
    if (error) return res.status(500).json({ error: error.message });
    return res.status(200).json({ message: "Horario actualizado", horario: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const eliminar = async (req, res) => {
  try {
    const { data, error } = await model.eliminarHorario(req.params.id);
    if (error) return res.status(500).json({ error: error.message });
    return res.status(200).json({ message: "Horario eliminado", horario: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};
