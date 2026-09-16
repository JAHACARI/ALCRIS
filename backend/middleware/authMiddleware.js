import jwt from "jsonwebtoken";

const JWT_SECRET = process.env.JWT_SECRET;

if (!JWT_SECRET) {
  console.error("❌ Falta JWT_SECRET en el archivo .env");
  process.exit(1);
}

/**
 * Verifica que el request traiga un JWT válido.
 * Agrega req.usuario = { id, email, rol }
 */
export const verificarToken = (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({ error: "Token no proporcionado" });
  }

  const token = authHeader.split(" ")[1];

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.usuario = decoded;
    next();
  } catch {
    return res.status(401).json({ error: "Token inválido o expirado" });
  }
};

/**
 * Solo permite acceso a usuarios con rol "admin"
 */
export const soloAdmin = (req, res, next) => {
  if (req.usuario?.rol !== "admin") {
    return res
      .status(403)
      .json({ error: "Acceso denegado. Se requiere rol de administrador" });
  }
  next();
};

/**
 * Solo permite acceso a admin o al propio usuario
 */
export const adminOPropio = (req, res, next) => {
  const idParam = req.params.id;
  if (
    req.usuario?.rol === "admin" ||
    String(req.usuario?.id) === String(idParam)
  ) {
    return next();
  }
  return res.status(403).json({ error: "No tienes permiso para esta acción" });
};
