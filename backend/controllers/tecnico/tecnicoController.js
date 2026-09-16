import * as model from "../../models/tecnico/tecnicoModel.js";

export const crear = async (req, res) => {
  try {
    const { usuario_id, especialidad } = req.body;
    if (!usuario_id) return res.status(400).json({ error: "usuario_id es requerido" });

    const { data, error } = await model.crearTecnico({ usuario_id, especialidad });
    if (error) return res.status(500).json({ error: error.message });
    return res.status(201).json({ message: "Técnico creado", tecnico: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const listar = async (req, res) => {
  try {
    const { data, error } = await model.obtenerTecnicos();
    if (error) return res.status(500).json({ error: error.message });
    return res.status(200).json({ tecnicos: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const obtener = async (req, res) => {
  try {
    const { data, error } = await model.obtenerTecnicoPorId(req.params.id);
    if (error || !data) return res.status(404).json({ error: "Técnico no encontrado" });
    return res.status(200).json({ tecnico: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const actualizar = async (req, res) => {
  try {
    const { data, error } = await model.actualizarTecnico(req.params.id, req.body);
    if (error) return res.status(500).json({ error: error.message });
    return res.status(200).json({ message: "Técnico actualizado", tecnico: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const eliminar = async (req, res) => {
  try {
    const { data, error } = await model.eliminarTecnico(req.params.id);
    if (error) return res.status(500).json({ error: error.message });
    return res.status(200).json({ message: "Técnico eliminado", tecnico: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};
