import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import { OAuth2Client } from "google-auth-library";
import {
  crearUsuario,
  crearUsuarioGoogle,
  obtenerPorEmail,
  obtenerPorGoogleId,
  actualizarUsuario,
} from "../../models/usuario/usuarioModel.js";
import {
  crearRecuperacion,
  obtenerRecuperacionValida,
  marcarRecuperacionUsada,
} from "../../models/auth/recuperacionModel.js";
import {
  enviarCodigoVerificacion,
  enviarCodigoRecuperacion,
} from "../../services/emailService.js";

const JWT_SECRET = process.env.JWT_SECRET;
const googleClient = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

const generarToken = (usuario) => {
  return jwt.sign(
    { id: usuario.id, email: usuario.email, rol: usuario.rol },
    JWT_SECRET,
    { expiresIn: "7d" },
  );
};

const generarCodigo = () =>
  Math.floor(100000 + Math.random() * 900000).toString();

// ---------- REGISTRO ----------
export const registro = async (req, res) => {
  try {
    const { nombre, email, contrasena, telefono, localidad } = req.body;

    if (!nombre || !email || !contrasena || !telefono || !localidad) {
      return res.status(400).json({
        error:
          "Todos los campos son requeridos: nombre, email, contrasena, telefono, localidad",
      });
    }

    if (contrasena.length < 6) {
      return res
        .status(400)
        .json({ error: "La contraseña debe tener al menos 6 caracteres" });
    }

    const { data: existe } = await obtenerPorEmail(email);
    if (existe) {
      return res.status(400).json({ error: "El email ya está registrado" });
    }

    const hashed = await bcrypt.hash(contrasena, 10);
    const codigo = generarCodigo();
    const expira = new Date(Date.now() + 15 * 60 * 1000).toISOString();

    const { data: nuevo, error } = await crearUsuario({
      nombre,
      email,
      contrasena: hashed,
      telefono,
      localidad,
      codigo_verificacion: codigo,
      codigo_verificacion_expira: expira,
    });

    if (error) {
      console.error("Error al crear usuario:", error);
      return res
        .status(500)
        .json({ error: "Error al crear el usuario", detalle: error.message });
    }

    // Control optimizado del servicio de emails basado en la respuesta del transporter
    const resultadoEmail = await enviarCodigoVerificacion(email, codigo, nombre);
    
    if (!resultadoEmail || !resultadoEmail.success) {
      console.error("❌ El servicio de Nodemailer reportó un fallo:", resultadoEmail?.error || "Fallo desconocido");
      return res.status(201).json({
        message: "Usuario registrado, pero hubo un problema al enviar el correo de verificación. Revisa la consola.",
        codigo_debug: codigo,
        usuario: nuevo,
      });
    }

    return res.status(201).json({
      message:
        "Usuario registrado. Revisa tu correo para el código de verificación.",
      usuario: nuevo,
    });
  } catch (error) {
    console.error("Error en registro:", error);
    return res.status(500).json({ error: error.message });
  }
};

// ---------- VERIFICAR CUENTA ----------
export const verificarCuenta = async (req, res) => {
  try {
    const { email, codigo } = req.body;

    if (!email || !codigo) {
      return res.status(400).json({ error: "Email y código son requeridos" });
    }

    const { data: usuario, error } = await obtenerPorEmail(email);
    if (error || !usuario) {
      return res.status(404).json({ error: "Usuario no encontrado" });
    }

    if (usuario.is_verified) {
      return res.status(400).json({ error: "La cuenta ya está verificada" });
    }

    if (String(usuario.codigo_verificacion).trim() !== String(codigo).trim()) {
      return res
        .status(400)
        .json({ error: "Código de verificación incorrecto" });
    }

    if (new Date() > new Date(usuario.codigo_verificacion_expira)) {
      return res
        .status(400)
        .json({ error: "El código ha expirado. Solicita uno nuevo." });
    }

    await actualizarUsuario(usuario.id, {
      is_verified: true,
      codigo_verificacion: null,
      codigo_verificacion_expira: null,
    });

    return res.status(200).json({
      message: "Cuenta verificada correctamente. Ya puedes iniciar sesión.",
    });
  } catch (error) {
    console.error("Error en verificarCuenta:", error);
    return res.status(500).json({ error: error.message });
  }
};

// ---------- REENVIAR CÓDIGO DE VERIFICACIÓN ----------
export const reenviarCodigo = async (req, res) => {
  try {
    const { email } = req.body;

    if (!email) {
      return res.status(400).json({ error: "El email es requerido" });
    }

    const { data: usuario, error } = await obtenerPorEmail(email);
    if (error || !usuario) {
      return res.status(404).json({ error: "Usuario no encontrado" });
    }

    if (usuario.is_verified) {
      return res.status(400).json({
        error: "La cuenta ya está verificada. Puedes iniciar sesión.",
      });
    }

    const codigo = generarCodigo();
    const expira = new Date(Date.now() + 15 * 60 * 1000).toISOString();

    const { error: errorUpdate } = await actualizarUsuario(usuario.id, {
      codigo_verificacion: codigo,
      codigo_verificacion_expira: expira,
    });

    if (errorUpdate) {
      return res.status(500).json({ error: "No se pudo generar un nuevo código" });
    }

    // Control optimizado del servicio de emails basado en la respuesta del transporter
    const resultadoEmail = await enviarCodigoVerificacion(email, codigo, usuario.nombre);
    
    if (!resultadoEmail || !resultadoEmail.success) {
      console.error("❌ Fallo al reenviar el código de verificación:", resultadoEmail?.error || "Fallo desconocido");
      return res.status(200).json({
        message: "Código generado. Si no llega el correo, revisa spam o usa el código de prueba.",
        codigo_debug: codigo,
      });
    }

    return res.status(200).json({
      message: "Se envió un nuevo código de verificación a tu correo. Válido por 15 minutos.",
    });
  } catch (error) {
    console.error("Error en reenviarCodigo:", error);
    return res.status(500).json({ error: error.message });
  }
};

// ---------- LOGIN ----------
export const login = async (req, res) => {
  try {
    const { email, contrasena } = req.body;

    if (!email || !contrasena) {
      return res
        .status(400)
        .json({ error: "Email y contraseña son requeridos" });
    }

    const { data: usuario, error } = await obtenerPorEmail(email);
    if (error || !usuario) {
      return res.status(401).json({ error: "Credenciales incorrectas" });
    }

    if (!usuario.contrasena) {
      return res
        .status(400)
        .json({ error: "Esta cuenta usa inicio de sesión con Google" });
    }

    if (!usuario.is_verified) {
      return res
        .status(403)
        .json({ error: "Debes verificar tu cuenta antes de iniciar sesión" });
    }

    if (!usuario.activo) {
      return res.status(403).json({ error: "Tu cuenta está desactivada" });
    }

    const valido = await bcrypt.compare(contrasena, usuario.contrasena);
    if (!valido) {
      return res.status(401).json({ error: "Credenciales incorrectas" });
    }

    const token = generarToken(usuario);

    return res.status(200).json({
      message: "Login exitoso",
      token,
      usuario: {
        id: usuario.id,
        nombre: usuario.nombre,
        email: usuario.email,
        rol: usuario.rol,
        avatar: usuario.avatar,
      },
    });
  } catch (error) {
    console.error("Error en login:", error);
    return res.status(500).json({ error: error.message });
  }
};

// ---------- GOOGLE AUTH ----------
export const googleAuth = async (req, res) => {
  try {
    const { idToken } = req.body;

    if (!idToken) {
      return res.status(400).json({ error: "idToken es requerido" });
    }

    const ticket = await googleClient.verifyIdToken({
      idToken,
      audience: process.env.GOOGLE_CLIENT_ID,
    });

    const payload = ticket.getPayload();
    const { sub: google_id, email, name, picture } = payload;

    let { data: usuario } = await obtenerPorGoogleId(google_id);

    if (!usuario) {
      const { data: porEmail } = await obtenerPorEmail(email);
      if (porEmail) {
        await actualizarUsuario(porEmail.id, {
          google_id,
          avatar: picture || porEmail.avatar,
        });
        usuario = { ...porEmail, google_id };
      } else {
        const { data: nuevo, error } = await crearUsuarioGoogle({
          nombre: name,
          email,
          google_id,
          avatar: picture,
        });
        if (error) {
          return res.status(500).json({ error: "Error al crear usuario con Google" });
        }
        usuario = nuevo;
      }
    }

    const token = generarToken(usuario);
    return res.status(200).json({ token, usuario });
  } catch (error) {
    console.error("Error en googleAuth:", error);
    return res.status(500).json({ error: error.message });
  }
};

// ---------- SOLICITAR RECUPERACIÓN ----------
export const solicitarRecuperacion = async (req, res) => {
  try {
    const { email } = req.body;
    if (!email) return res.status(400).json({ error: "Email requerido" });

    const { data: usuario } = await obtenerPorEmail(email);
    if (!usuario) return res.status(404).json({ error: "Usuario no encontrado" });

    const codigo = generarCodigo();
    const expira = new Date(Date.now() + 15 * 60 * 1000).toISOString();

    await crearRecuperacion(usuario.id, codigo, expira);
    await enviarCodigoRecuperacion(email, codigo, usuario.nombre);

    return res.status(200).json({ message: "Código de recuperación enviado" });
  } catch (error) {
    console.error("Error en solicitarRecuperacion:", error);
    return res.status(500).json({ error: error.message });
  }
};

// ---------- RESTABLECER PASSWORD ----------
export const restablecerPassword = async (req, res) => {
  try {
    const { email, codigo, nuevaContrasena } = req.body;
if (!email || !codigo || !nuevaContrasena) {
return res.status(400).json({ error: "Todos los campos son requeridos" });
}
const { data: usuario } = await obtenerPorEmail(email);
if (!usuario) return res.status(404).json({ error: "Usuario no encontrado" });
const { data: rec } = await obtenerRecuperacionValida(usuario.id, codigo);
if (!rec) return res.status(400).json({ error: "Código inválido o expirado" });
const hashed = await bcrypt.hash(nuevaContrasena, 10);
await actualizarUsuario(usuario.id, { contrasena: hashed });
await marcarRecuperacionUsada(rec.id);
return res.status(200).json({ message: "Contraseña restablecida correctamente" });
} catch (error) {
console.error("Error en restablecerPassword:", error);
return res.status(500).json({ error: error.message });
}
};