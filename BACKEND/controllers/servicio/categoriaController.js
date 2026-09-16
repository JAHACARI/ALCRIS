import * as model from "../../models/servicio/categoriaModel.js";

export const crear = async (req, res) => {
  try {
    const { nombre, descripcion, imagen, color_tema } = req.body;
    if (!nombre)
      return res.status(400).json({ error: "El nombre es obligatorio" });

    const { data, error } = await model.crearCategoria({
      nombre,
      descripcion,
      imagen,
      color_tema,
    });
    if (error) return res.status(500).json({ error: error.message });
    return res
      .status(201)
      .json({ message: "Categoría creada", categoria: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const listar = async (req, res) => {
  try {
    const { data, error } = await model.obtenerCategorias();
    if (error) return res.status(500).json({ error: error.message });
    return res.status(200).json({ categorias: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const obtener = async (req, res) => {
  try {
    const { data, error } = await model.obtenerCategoriaPorId(req.params.id);
    if (error || !data)
      return res.status(404).json({ error: "Categoría no encontrada" });
    return res.status(200).json({ categoria: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const actualizar = async (req, res) => {
  try {
    const { data, error } = await model.actualizarCategoria(
      req.params.id,
      req.body,
    );
    if (error) return res.status(500).json({ error: error.message });
    return res
      .status(200)
      .json({ message: "Categoría actualizada", categoria: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const eliminar = async (req, res) => {
  try {
    const { data, error } = await model.eliminarCategoria(req.params.id);
    if (error) return res.status(500).json({ error: error.message });
    return res
      .status(200)
      .json({ message: "Categoría eliminada", categoria: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};
