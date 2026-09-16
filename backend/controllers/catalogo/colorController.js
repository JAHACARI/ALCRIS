import * as model from "../../models/catalogo/colorModel.js";

export const crear = async (req, res) => {
  try {
    const { nombre_color, codigo_ral, codigo_hex } = req.body;
    if (!nombre_color || !codigo_ral || !codigo_hex) {
      return res.status(400).json({
        error: "nombre_color, codigo_ral y codigo_hex son requeridos",
      });
    }
    const { data, error } = await model.crearColor({
      nombre_color,
      codigo_ral,
      codigo_hex,
    });
    if (error) return res.status(500).json({ error: error.message });
    return res.status(201).json({ message: "Color creado", color: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const listar = async (req, res) => {
  try {
    const { data, error } = await model.obtenerColores();
    if (error) return res.status(500).json({ error: error.message });
    return res.status(200).json({ colores: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const obtener = async (req, res) => {
  try {
    const { data, error } = await model.obtenerColorPorId(req.params.id);
    if (error || !data)
      return res.status(404).json({ error: "Color no encontrado" });
    return res.status(200).json({ color: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const actualizar = async (req, res) => {
  try {
    const { data, error } = await model.actualizarColor(
      req.params.id,
      req.body,
    );
    if (error) return res.status(500).json({ error: error.message });
    return res.status(200).json({ message: "Color actualizado", color: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const eliminar = async (req, res) => {
  try {
    const { data, error } = await model.eliminarColor(req.params.id);
    if (error) return res.status(500).json({ error: error.message });
    return res.status(200).json({ message: "Color eliminado", color: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};
