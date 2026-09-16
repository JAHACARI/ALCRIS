import nodemailer from "nodemailer";
import "dotenv/config";

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});

/**
 * Envía el código de verificación de cuenta
 */
export const enviarCodigoVerificacion = async (email, codigo, nombre = "Usuario") => {
  const mailOptions = {
    from: `"${process.env.EMAIL_FROM_NAME || "Alcris"}" <${process.env.EMAIL_USER}>`,
    to: email,
    subject: "Código de verificación - Alcris",
    html: `
      <div style="font-family: Arial, sans-serif; max-width: 500px; margin: 0 auto;">
        <h2 style="color: #1a2714;">Hola ${nombre},</h2>
        <p>Tu código de verificación es:</p>
        <div style="background: #f4f7f2; padding: 20px; text-align: center; border-radius: 8px; margin: 20px 0;">
          <span style="font-size: 32px; font-weight: bold; letter-spacing: 8px; color: #2d8400;">${codigo}</span>
        </div>
        <p>Este código expira en <strong>15 minutos</strong>.</p>
        <p style="color: #666; font-size: 13px;">Si no solicitaste este código, ignora este correo.</p>
        <hr style="border: none; border-top: 1px solid #eee; margin: 24px 0;">
        <p style="color: #999; font-size: 12px;">Alcris - Latonería y Pintura</p>
      </div>
    `,
  };

  await transporter.sendMail(mailOptions);
};

/**
 * Envía el código de recuperación de contraseña
 */
export const enviarCodigoRecuperacion = async (email, codigo, nombre = "Usuario") => {
  const mailOptions = {
    from: `"${process.env.EMAIL_FROM_NAME || "Alcris"}" <${process.env.EMAIL_USER}>`,
    to: email,
    subject: "Recuperación de contraseña - Alcris",
    html: `
      <div style="font-family: Arial, sans-serif; max-width: 500px; margin: 0 auto;">
        <h2 style="color: #1a2714;">Hola ${nombre},</h2>
        <p>Recibimos una solicitud para restablecer tu contraseña.</p>
        <p>Tu código de recuperación es:</p>
        <div style="background: #fff5f0; padding: 20px; text-align: center; border-radius: 8px; margin: 20px 0;">
          <span style="font-size: 32px; font-weight: bold; letter-spacing: 8px; color: #ff6b00;">${codigo}</span>
        </div>
        <p>Este código expira en <strong>15 minutos</strong>.</p>
        <p style="color: #666; font-size: 13px;">Si no solicitaste este cambio, ignora este correo.</p>
        <hr style="border: none; border-top: 1px solid #eee; margin: 24px 0;">
        <p style="color: #999; font-size: 12px;">Alcris - Latonería y Pintura</p>
      </div>
    `,
  };

  await transporter.sendMail(mailOptions);
};
