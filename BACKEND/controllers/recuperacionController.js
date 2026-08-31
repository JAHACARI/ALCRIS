//----------------------------------------------------------//
// Controlador de Recuperación de Contraseña
import bcrypt from "bcrypt";
import nodemailer from "nodemailer";
import {
  crearCodigoRecuperacion,
  obtenerCodigoValido,
  marcarCodigoUsado,
  invalidarCodigosAnteriores,
} from "../models/recuperacionModel.js";
import { obtenerPorCorreo, actualizarUsuario } from "../models/userModel.js";

//----------------------------------------------------------//
// Configurar nodemailer (Gmail)
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});

//----------------------------------------------------------//
// Generar código de 6 dígitos
const generarCodigo = () => {
  return Math.floor(100000 + Math.random() * 900000).toString();
};

//----------------------------------------------------------//
// Solicitar código
export const solicitarCodigo = async (req, res) => {
  try {
    const { correo } = req.body;

    if (!correo) {
      return res.status(400).json({ error: "El correo es obligatorio" });
    }

    const { data: usuario, error } = await obtenerPorCorreo(correo);

    // Por seguridad: siempre respondemos igual
    if (error || !usuario) {
      return res.status(200).json({
        message: "Si el correo está registrado, recibirás un código de recuperación",
      });
    }

    await invalidarCodigosAnteriores(usuario.id);

    const codigo = generarCodigo();
    const { error: errorCrear } = await crearCodigoRecuperacion(usuario.id, codigo);

    if (errorCrear) {
      console.error("Error al crear código:", errorCrear);
      return res.status(500).json({ error: "Error al generar el código" });
    }

    // Enviar correo
    await transporter.sendMail({
      from: process.env.EMAIL_USER,
      to: correo,
      subject: "Código de Recuperación - AlCRIS",
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
          <h2 style="color: #2c3e50;">Código de Recuperación</h2>
          <p>Has solicitado recuperar tu contraseña. Tu código es:</p>
          <div style="background: #f4f4f4; padding: 20px; text-align: center; font-size: 28px; letter-spacing: 8px; border-radius: 8px;">
            <strong>${codigo}</strong>
          </div>
          <p>Este código expira en <strong>10 minutos</strong>.</p>
          <p>Si no solicitaste este cambio, ignora este correo.</p>
        </div>
      `,
    });

    return res.status(200).json({
      message: "Si el correo está registrado, recibirás un código de recuperación",
    });
  } catch (error) {
    console.error("Error en solicitarCodigo:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};

//----------------------------------------------------------//
// Verificar código y cambiar contraseña
export const resetearContrasena = async (req, res) => {
  try {
    const { correo, codigo, nueva_contrasena } = req.body;

    if (!correo || !codigo || !nueva_contrasena) {
      return res.status(400).json({
        error: "Correo, código y nueva contraseña son obligatorios",
      });
    }

    if (nueva_contrasena.length < 6) {
      return res.status(400).json({
        error: "La contraseña debe tener al menos 6 caracteres",
      });
    }

    const { data: usuario, error } = await obtenerPorCorreo(correo);
    if (error || !usuario) {
      return res.status(400).json({ error: "Código inválido o expirado" });
    }

    const { data: registro, error: errorCodigo } = await obtenerCodigoValido(
      usuario.id,
      codigo
    );

    if (errorCodigo || !registro) {
      return res.status(400).json({ error: "Código inválido o expirado" });
    }

    const hashedPassword = await bcrypt.hash(nueva_contrasena, 10);

    const { error: errorUpdate } = await actualizarUsuario(usuario.id, {
      contrasena: hashedPassword,
    });

    if (errorUpdate) {
      console.error("Error al actualizar contraseña:", errorUpdate);
      return res.status(500).json({ error: "Error al actualizar la contraseña" });
    }

    await marcarCodigoUsado(registro.id);

    return res.status(200).json({
      message: "Contraseña actualizada correctamente",
    });
  } catch (error) {
    console.error("Error en resetearContrasena:", error);
    return res.status(500).json({ error: "Error interno del servidor" });
  }
};