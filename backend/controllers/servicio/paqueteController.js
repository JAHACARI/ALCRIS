import * as model from "../../models/servicio/paqueteModel.js";
const CAMPOS = ["servicio_id", "nombre", "descripcion", "etiqueta", "precio", "duracion_horas", "activo"];
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

export const actualizarPaquete = async (id, campos) => {
  const { data, error } = await supabase
    .from("paquetes_servicio")
    .update(campos)
    .eq("id", id)
    .select("*")
    .maybeSingle();
  return { data, error };
};

export const eliminarPaquete = async (id) => {
  const { data, error } = await supabase
    .from("paquetes_servicio")
    .update({ activo: false })
    .eq("id", id)
    .select("*")
    .maybeSingle();
  return { data, error };
};
if (!data) return res.status(404).json({ error: "Paquete no encontrado" });
