import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { crearUser, getUserEmail } from "../models/usuario.js"; // ← corregido

const JWT_SECRET = process.env.JWT_SECRET;

if (!JWT_SECRET) {
  console.error("❌ JWT_SECRET no está definido en el archivo .env");
  process.exit(1);
}

// Registro de usuario
export const registro = async (req, res) => {
  try {
    const { nombre, email, password } = req.body;

    if (!nombre || !email || !password) {
      return res.status(400).json({
        error: "Faltan campos obligatorios (nombre, email, password)",
      });
    }

    if (password.length < 6) {
      return res
        .status(400)
        .json({ error: "La contraseña debe tener al menos 6 caracteres" });
    }

    const { data: usuarioExiste } = await getUserEmail(email);
    if (usuarioExiste) {
      return res.status(400).json({ error: "El email ya está registrado" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const { data: nuevoUsuario, error } = await crearUser(
      nombre,
      email,
      hashedPassword,
      "usuario",
    );

    if (error) {
      console.error("Error en el registro:", error);
      return res.status(500).json({ error: "Error al crear el usuario" });
    }

    return res.status(201).json({
      message: "Usuario creado exitosamente",
      usuario: {
        id: nuevoUsuario.id,
        nombre: nuevoUsuario.nombre,
        email: nuevoUsuario.email,
        rol: nuevoUsuario.rol,
      },
    });
  } catch (error) {
    console.error("Error en el registro:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};

// Login de usuario
export const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ error: "Email y password son requeridos" });
    }

    const { data: usuario, error } = await getUserEmail(email);
    if (error || !usuario) {
      return res.status(401).json({ error: "Credenciales incorrectas" });
    }

    const passwordValido = await bcrypt.compare(password, usuario.password);
    if (!passwordValido) {
      return res.status(401).json({ error: "Credenciales incorrectas" });
    }

    const token = jwt.sign(
      { id: usuario.id, email: usuario.email, rol: usuario.rol },
      JWT_SECRET,
      { expiresIn: "2h" },
    );

    return res.json({
      message: "Login exitoso",
      usuario: {
        id: usuario.id,
        nombre: usuario.nombre,
        email: usuario.email,
        rol: usuario.rol,
      },
      token,
    });
  } catch (error) {
    console.error("Error en login:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};
