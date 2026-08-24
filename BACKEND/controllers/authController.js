//----------------------------------------------------------//
// Controlador de Autenticación
//----------------------------------------------------------//
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { crearUsuario, obtenerPorCorreo } from "../models/userModel.js";

const JWT_SECRET = process.env.JWT_SECRET;

if (!JWT_SECRET) {
  console.error("❌ JWT_SECRET no está definido en el archivo .env");
  process.exit(1);
}

//----------------------------------------------------------//
// Registro de usuario
//----------------------------------------------------------//
export const registro = async (req, res) => {
  try {
    const { nombre, correo, contrasena } = req.body;

    if (!nombre || !correo || !contrasena) {
      return res.status(400).json({
        error: "Faltan campos obligatorios (nombre, correo, contrasena)",
      });
    }

    if (contrasena.length < 6) {
      return res
        .status(400)
        .json({ error: "La contraseña debe tener al menos 6 caracteres" });
    }

    // Validación básica de correo
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(correo)) {
      return res.status(400).json({ error: "El correo no es válido" });
    }

    const { data: usuarioExiste } = await obtenerPorCorreo(correo);
    if (usuarioExiste) {
      return res.status(400).json({ error: "El correo ya está registrado" });
    }

    const hashedPassword = await bcrypt.hash(contrasena, 10);
    const { data: nuevoUsuario, error } = await crearUsuario(
      nombre,
      correo,
      hashedPassword,
      "usuario",
    );

    if (error) {
      console.error("Error en el registro:", error);
      return res.status(500).json({ error: "Error al crear el usuario" });
    }

    return res.status(201).json({
      message: "Usuario creado exitosamente",
      usuario: nuevoUsuario,
    });
  } catch (error) {
    console.error("Error en el registro:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};

//----------------------------------------------------------//
// Login de usuario
//----------------------------------------------------------//
export const login = async (req, res) => {
  try {
    const { correo, contrasena } = req.body;

    if (!correo || !contrasena) {
      return res
        .status(400)
        .json({ error: "Correo y contraseña son requeridos" });
    }

    const { data: usuario, error } = await obtenerPorCorreo(correo);
    if (error || !usuario) {
      return res.status(401).json({ error: "Credenciales incorrectas" });
    }

    const passwordValido = await bcrypt.compare(contrasena, usuario.contrasena);
    if (!passwordValido) {
      return res.status(401).json({ error: "Credenciales incorrectas" });
    }

    const token = jwt.sign(
      { id: usuario.id, correo: usuario.correo, rol: usuario.rol },
      JWT_SECRET,
      { expiresIn: "8h" },
    );

    return res.json({
      message: "Login exitoso",
      usuario: {
        id: usuario.id,
        nombre: usuario.nombre,
        correo: usuario.correo,
        rol: usuario.rol,
      },
      token,
    });
  } catch (error) {
    console.error("Error en login:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};
