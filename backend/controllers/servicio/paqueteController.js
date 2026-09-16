import * as model from "../../models/servicio/paqueteModel.js";

export const crear = async (req, res) => {
  try {
    const { servicio_id, nombre, precio } = req.body;
    if (!servicio_id || !nombre || precio === undefined) {
      return res
        .status(400)
        .json({ error: "servicio_id, nombre y precio son requeridos" });
    }

    const { data, error } = await model.crearPaquete(req.body);
    if (error) return res.status(500).json({ error: error.message });
    return res.status(201).json({ message: "Paquete creado", paquete: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const listar = async (req, res) => {
  try {
    const { data, error } = await model.obtenerPaquetes();
    if (error) return res.status(500).json({ error: error.message });
    return res.status(200).json({ paquetes: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const obtener = async (req, res) => {
  try {
    const { data, error } = await model.obtenerPaquetePorId(req.params.id);
    if (error || !data)
      return res.status(404).json({ error: "Paquete no encontrado" });
    return res.status(200).json({ paquete: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const actualizar = async (req, res) => {
  try {
    const { data, error } = await model.actualizarPaquete(
      req.params.id,
      req.body,
    );
    if (error) return res.status(500).json({ error: error.message });
    return res
      .status(200)
      .json({ message: "Paquete actualizado", paquete: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const eliminar = async (req, res) => {
  try {
    const { data, error } = await model.eliminarPaquete(req.params.id);
    if (error) return res.status(500).json({ error: error.message });
    return res
      .status(200)
      .json({ message: "Paquete eliminado", paquete: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};
