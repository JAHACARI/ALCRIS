import * as model from "../../models/servicio/paqueteModel.js";

const CAMPOS = [
  "servicio_id",
  "nombre",
  "descripcion",
  "precio",
  "duracion_dias_min",
  "duracion_dias_max",
  "destacado",
  "activo",
];

const pick = (obj) =>
  Object.fromEntries(Object.entries(obj).filter(([k]) => CAMPOS.includes(k)));

export const crear = async (req, res) => {
  try {
    const { servicio_id, nombre, precio } = req.body;
    if (!servicio_id || !nombre || precio === undefined) {
      return res
        .status(400)
        .json({ error: "servicio_id, nombre y precio son requeridos" });
    }

    const { data, error } = await model.crearPaquete(pick(req.body));
    if (error) return res.status(500).json({ error: error.message });
    return res.status(201).json({ message: "Paquete creado", paquete: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const listar = async (req, res) => {
  try {
    const { servicio_id } = req.query;
    const { data, error } = servicio_id
      ? await model.obtenerPaquetesPorServicio(servicio_id)
      : await model.obtenerPaquetes();
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
      pick(req.body),
    );
    if (error) return res.status(500).json({ error: error.message });
    if (!data)
      return res.status(404).json({ error: "Paquete no encontrado" });
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
    if (!data)
      return res.status(404).json({ error: "Paquete no encontrado" });
    return res
      .status(200)
      .json({ message: "Paquete eliminado", paquete: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};