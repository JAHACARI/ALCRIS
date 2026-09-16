import * as model from "../../models/catalogo/acabadoModel.js";

export const crear = async (req, res) => {
  try {
    const { nombre, descripcion } = req.body;
    if (!nombre)
      return res.status(400).json({ error: "El nombre es obligatorio" });

    const { data, error } = await model.crearAcabado({ nombre, descripcion });
    if (error) return res.status(500).json({ error: error.message });
    return res.status(201).json({ message: "Acabado creado", acabado: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const listar = async (req, res) => {
  try {
    const { data, error } = await model.obtenerAcabados();
    if (error) return res.status(500).json({ error: error.message });
    return res.status(200).json({ acabados: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const obtener = async (req, res) => {
  try {
    const { data, error } = await model.obtenerAcabadoPorId(req.params.id);
    if (error || !data)
      return res.status(404).json({ error: "Acabado no encontrado" });
    return res.status(200).json({ acabado: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const actualizar = async (req, res) => {
  try {
    const { data, error } = await model.actualizarAcabado(
      req.params.id,
      req.body,
    );
    if (error) return res.status(500).json({ error: error.message });
    return res
      .status(200)
      .json({ message: "Acabado actualizado", acabado: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const eliminar = async (req, res) => {
  try {
    const { data, error } = await model.eliminarAcabado(req.params.id);
    if (error) return res.status(500).json({ error: error.message });
    return res
      .status(200)
      .json({ message: "Acabado eliminado", acabado: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};
