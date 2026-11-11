import { supabase } from "../../config/supabase.js";

export const solicitarRecuperacion = async (req, res) => {
  try {
    const { email } = req.body;
    if (!email) return res.status(400).json({ error: "Email requerido" });

    const { data: usuario } = await obtenerPorEmail(email);
    if (!usuario) return res.status(404).json({ error: "Usuario no encontrado" });

    const codigo = generarCodigo();
    const expira = new Date(Date.now() + 15 * 60 * 1000).toISOString();

    // CORREGIDO: Pasar un objeto con los nombres exactos de las columnas
    const { error: errorRec } = await crearRecuperacion({
      usuario_id: usuario.id,
      codigo: codigo,
      fecha_expira: expira,
    });

    if (errorRec) {
      console.error("Error al guardar código en Supabase:", errorRec);
      return res.status(500).json({ error: "No se pudo generar el código de recuperación" });
    }

    await enviarCodigoRecuperacion(email, codigo, usuario.nombre);

    return res.status(200).json({ message: "Código de recuperación enviado" });
  } catch (error) {
    console.error("Error en solicitarRecuperacion:", error);
    return res.status(500).json({ error: error.message });
  }
};

export const obtenerRecuperacionValida = async (usuario_id, codigo) => {
  const { data, error } = await supabase
    .from("recuperacion_password")
    .select("*")
    .eq("usuario_id", usuario_id)
    .eq("codigo", codigo)
    .eq("usado", false)
    .gt("fecha_expira", new Date().toISOString())
    .order("fecha_creacion", { ascending: false })
    .limit(1)
    .maybeSingle();
  return { data, error };
};

export const marcarRecuperacionUsada = async (id) => {
  const { data, error } = await supabase
    .from("recuperacion_password")
    .update({ usado: true })
    .eq("id", id)
    .select("*")
    .single();
  return { data, error };
};
