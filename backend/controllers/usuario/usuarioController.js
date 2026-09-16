import bcrypt from "bcryptjs";
import {
  obtenerUsuarios,
  obtenerUsuarioPorId,
  actualizarUsuario,
  eliminarUsuario,
} from "../../models/usuario/usuarioModel.js";

export const getUsuarios = async (req, res) => {
  try {
    const { data, error } = await obtenerUsuarios();
    if (error) return res.status(500).json({ error: error.message });
    return res.status(200).json({ usuarios: data });
  } catch (error) {
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};

export const getUsuarioPorId = async (req, res) => {
  try {
    const { id } = req.params;
    const { data, error } = await obtenerUsuarioPorId(id);

    if (error || !data) {
      return res.status(404).json({ error: "Usuario no encontrado" });
    }

    // Solo admin o el propio usuario
    if (req.usuario.rol !== "admin" && String(req.usuario.id) !== String(id)) {
      return res
        .status(403)
        .json({ error: "No tienes permiso para ver este usuario" });
    }

    return res.status(200).json({ usuario: data });
  } catch (error) {
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};

export const updateUsuario = async (req, res) => {
  try {
    const { id } = req.params;
    const body = req.body;

    // Solo admin o el propio usuario
    if (req.usuario.rol !== "admin" && String(req.usuario.id) !== String(id)) {
      return res
        .status(403)
        .json({ error: "No tienes permiso para actualizar este usuario" });
    }

    const { data: existente } = await obtenerUsuarioPorId(id);
    if (!existente) {
      return res.status(404).json({ error: "Usuario no encontrado" });
    }

    const CAMPOS_PERMITIDOS = ["nombre", "telefono", "localidad", "avatar"];
    const campos = {};

    for (const campo of CAMPOS_PERMITIDOS) {
      if (body[campo] !== undefined) {
        campos[campo] = body[campo];
      }
    }

    // Solo admin puede cambiar rol o activo
    if (req.usuario.rol === "admin") {
      if (body.rol !== undefined) campos.rol = body.rol;
      if (body.activo !== undefined) campos.activo = body.activo;
    }

    // Cambiar contraseña
    if (body.contrasena) {
      if (body.contrasena.length < 6) {
        return res
          .status(400)
          .json({ error: "La contraseña debe tener al menos 6 caracteres" });
      }
      campos.contrasena = await bcrypt.hash(body.contrasena, 10);
    }

    if (Object.keys(campos).length === 0) {
      return res
        .status(400)
        .json({ error: "No se enviaron campos válidos para actualizar" });
    }

    const { data, error } = await actualizarUsuario(id, campos);
    if (error) return res.status(500).json({ error: error.message });

    return res
      .status(200)
      .json({ message: "Usuario actualizado", usuario: data });
  } catch (error) {
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};

export const deleteUsuario = async (req, res) => {
  try {
    const { id } = req.params;

    const { data: existente } = await obtenerUsuarioPorId(id);
    if (!existente) {
      return res.status(404).json({ error: "Usuario no encontrado" });
    }

    const { data, error } = await eliminarUsuario(id);
    if (error) return res.status(500).json({ error: error.message });

    return res
      .status(200)
      .json({ message: "Usuario eliminado", usuario: data });
  } catch (error) {
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};
