import * as model from "../../models/servicio/servicioModel.js";

export const crearServicio = async ({
  categoria_id,
  nombre,
  descripcion,
  precio_base,
  tipo,
}) => {
  const { data, error } = await supabase
    .from("servicios")
    .insert({ categoria_id, nombre, descripcion, precio_base, tipo })
    .select("*")
    .single();
  return { data, error };
};

export const listar = async (req, res) => {
  try {
    const { data, error } = await model.obtenerServicios();
    if (error) return res.status(500).json({ error: error.message });
    return res.status(200).json({ servicios: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const obtener = async (req, res) => {
  try {
    const { data, error } = await model.obtenerServicioPorId(req.params.id);
    if (error || !data)
      return res.status(404).json({ error: "Servicio no encontrado" });
    return res.status(200).json({ servicio: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const actualizar = async (req, res) => {
  try {
    const { data, error } = await model.actualizarServicio(
      req.params.id,
      req.body,
    );
    if (error) return res.status(500).json({ error: error.message });
    return res
      .status(200)
      .json({ message: "Servicio actualizado", servicio: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const eliminar = async (req, res) => {
  try {
    const { data, error } = await model.eliminarServicio(req.params.id);
    if (error) return res.status(500).json({ error: error.message });
    return res
      .status(200)
      .json({ message: "Servicio eliminado", servicio: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};
