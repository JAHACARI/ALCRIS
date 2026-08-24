//----------------------------------------------------------//
// Controlador de Usuarios
//----------------------------------------------------------//
import {
  obtenerUsuarios,
  obtenerUsuarioPorId,
  actualizarUsuario,
  eliminarUsuario,
} from "../models/userModel.js";
import bcrypt from "bcrypt";

//----------------------------------------------------------//
// Campos permitidos para actualización
//----------------------------------------------------------//
const CAMPOS_PERMITIDOS = ["nombre", "correo", "telefono", "localidad", "contrasena"];

//----------------------------------------------------------//
// Obtener todos los usuarios (solo admin)
//----------------------------------------------------------//
export const getUsuarios = async (req, res) => {
  try {
    const { data, error } = await obtenerUsuarios();
    if (error) {
      return res.status(500).json({ error: error.message });
    }
    return res.status(200).json({ usuarios: data });
  } catch (error) {
    console.error("Error al obtener usuarios:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};

//----------------------------------------------------------//
// Obtener usuario por ID
//----------------------------------------------------------//
export const getUsuarioPorId = async (req, res) => {
  try {
    const { id } = req.params;
    const { data, error } = await obtenerUsuarioPorId(id);

    if (error || !data) {
      return res.status(404).json({ error: "Usuario no encontrado" });
    }

    // Un usuario normal solo puede ver su propio perfil
    if (req.usuario.rol !== "admin" && req.usuario.id !== Number(id)) {
      return res.status(403).json({ error: "No tienes permiso para ver este usuario" });
    }

    return res.status(200).json({ usuario: data });
  } catch (error) {
    console.error("Error al obtener usuario:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};

//----------------------------------------------------------//
// Actualizar usuario
//----------------------------------------------------------//
export const updateUsuario = async (req, res) => {
  try {
    const { id } = req.params;
    const body = req.body;

    // Verificar que el usuario exista
    const { data: usuarioExistente, error: errorExistente } = await obtenerUsuarioPorId(id);
    if (errorExistente || !usuarioExistente) {
      return res.status(404).json({ error: "Usuario no encontrado" });
    }

    // Solo admin o el propio usuario pueden actualizar
    if (req.usuario.rol !== "admin" && req.usuario.id !== Number(id)) {
      return res.status(403).json({ error: "No tienes permiso para actualizar este usuario" });
    }

    // Filtrar solo campos permitidos
    const campos = {};
    for (const campo of CAMPOS_PERMITIDOS) {
      if (body[campo] !== undefined) {
        campos[campo] = body[campo];
      }
    }

    // Solo un admin puede cambiar el rol
    if (body.rol !== undefined) {
      if (req.usuario.rol !== "admin") {
        return res.status(403).json({ error: "No tienes permiso para cambiar el rol" });
      }
      campos.rol = body.rol;
    }

    if (Object.keys(campos).length === 0) {
      return res.status(400).json({ error: "No se enviaron campos válidos para actualizar" });
    }

    // Si viene contraseña, encriptarla
    if (campos.contrasena) {
      if (campos.contrasena.length < 6) {
        return res.status(400).json({ error: "La contraseña debe tener al menos 6 caracteres" });
      }
      campos.contrasena = await bcrypt.hash(campos.contrasena, 10);
    }

    const { data, error } = await actualizarUsuario(id, campos);
    if (error) {
      return res.status(500).json({ error: error.message });
    }

    return res.status(200).json({
      message: "Usuario actualizado correctamente",
      usuario: data,
    });
  } catch (error) {
    console.error("Error al actualizar usuario:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};

//----------------------------------------------------------//
// Eliminar usuario (solo admin)
//----------------------------------------------------------//
export const deleteUsuario = async (req, res) => {
  try {
    const { id } = req.params;

    // Verificar que exista
    const { data: usuarioExistente, error: errorExistente } = await obtenerUsuarioPorId(id);
    if (errorExistente || !usuarioExistente) {
      return res.status(404).json({ error: "Usuario no encontrado" });
    }

    const { data, error } = await eliminarUsuario(id);
    if (error) {
      return res.status(500).json({ error: error.message });
    }

    return res.status(200).json({
      message: "Usuario eliminado correctamente",
      usuario: data,
    });
  } catch (error) {
    console.error("Error al eliminar usuario:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
}; 