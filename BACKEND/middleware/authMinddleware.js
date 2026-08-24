//----------------------------------------------------------//
// Middleware de Autenticación JWT
//----------------------------------------------------------//
import jwt from "jsonwebtoken";

const JWT_SECRET = process.env.JWT_SECRET;

export const verificarToken = (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({ error: "Token no proporcionado" });
  }

  const token = authHeader.split(" ")[1];

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.usuario = decoded; // { id, correo, rol }
    next();
  } catch (error) {
    return res.status(401).json({ error: "Token inválido o expirado" });
  }
};

// Solo permite acceso a administradores
export const soloAdmin = (req, res, next) => {
  if (req.usuario?.rol !== "admin") {
    return res.status(403).json({ error: "Acceso denegado. Se requiere rol de administrador" });
  }
  next();
};