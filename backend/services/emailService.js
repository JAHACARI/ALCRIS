import nodemailer from "nodemailer";
import "dotenv/config";

const transporter = nodemailer.createTransport({
  host: "://gmail.com",
  port: 465,
  secure: true,
  logger: true, // <-- Agrega esto para ver el flujo en la consola
  debug: true,  // <-- Agrega esto para ver errores detallados
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
   <div style="font-family: 'Segoe UI', Arial, sans-serif; max-width: 480px; margin: 0 auto; background-color: #ffffff; border: 1px solid #e2e8f0; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);">
  
  <!-- Encabezado con Degradado Azul Marino / Negro -->
  <div style="background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%); padding: 32px 24px; text-align: center;">
    <h1 style="color: #ffffff; margin: 0; font-size: 24px; font-weight: 600; letter-spacing: 0.5px;">Alcris</h1>
    <p style="color: #94a3b8; margin: 4px 0 0 0; font-size: 13px;">Latonería y Pintura</p>
  </div>

  <!-- Contenido Principal -->
  <div style="padding: 32px 24px;">
    <h2 style="color: #0f172a; margin-top: 0; font-size: 20px; font-weight: 600;">Hola ${nombre},</h2>
    <p style="color: #334155; font-size: 15px; line-height: 1.6; margin: 0 0 24px 0;">
      Tu código de verificación para completar el proceso de seguridad es el siguiente:
    </p>
    
    <!-- Bloque del Código (Fondo Gris/Azulado Sutil) -->
    <div style="background-color: #f1f5f9; padding: 24px; text-align: center; border-radius: 12px; margin: 24px 0; border: 1px solid #e2e8f0;">
      <!-- Código en Rojo Pastel -->
      <span style="font-size: 36px; font-weight: 700; letter-spacing: 6px; color: #e06666; display: inline-block;">${codigo}</span>
    </div>
    
    <!-- Nota de Expiración -->
    <p style="color: #475569; font-size: 14px; margin: 0 0 24px 0;">
      ⏱️ Este código expira en <strong style="color: #0f172a;">15 minutos</strong>.
    </p>
    
    <hr style="border: none; border-top: 1px solid #e2e8f0; margin: 32px 0 24px 0;">
    
    <!-- Texto de Seguridad Alternativo -->
    <p style="color: #94a3b8; font-size: 12px; line-height: 1.5; margin: 0;">
      Si no solicitaste este código, puedes ignorar este correo de forma segura. Ningún cambio se aplicará en tu cuenta.
    </p>
  </div>

  <!-- Pie de Página Fijo -->
  <div style="background-color: #f8fafc; padding: 16px; text-align: center; border-top: 1px solid #e2e8f0;">
    <p style="color: #64748b; font-size: 11px; margin: 0;">Alcris - Latonería y Pintura</p>
  </div>
</div>
    `,
  };

  try {
    const info = await transporter.sendMail(mailOptions);
    console.log("Correo de verificación enviado con éxito. ID:", info.messageId);
    return { success: true, messageId: info.messageId };
  } catch (error) {
    console.error("Error crítico enviando email de verificación:", error);
    return { success: false, error: error.message };
  }
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
        <div style="font-family: 'Segoe UI', Arial, sans-serif; max-width: 480px; margin: 0 auto; background-color: #ffffff; border: 1px solid #e1e8ed; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.05);">
        
        <!-- Encabezado / Banner Superior -->
        <div style="background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%); padding: 32px 24px; text-align: center;">
          <h1 style="color: #ffffff; margin: 0; font-size: 24px; font-weight: 600; letter-spacing: 0.5px;">Alcris</h1>
          <p style="color: #94a3b8; margin: 4px 0 0 0; font-size: 13px;">Latonería y Pintura</p>
        </div>

        <!-- Contenido Principal -->
        <div style="padding: 32px 24px; background-color: #ffffff;">
          <h2 style="color: #0f172a; margin-top: 0; font-size: 20px; font-weight: 600;">Hola, ${nombre}</h2>
          <p style="color: #334155; font-size: 15px; line-height: 1.6; margin: 0 0 24px 0;">
            Recibimos una solicitud para restablecer la contraseña de tu cuenta. No te preocupes, utiliza el siguiente código de seguridad para continuar con el proceso.
          </p>
          
          <!-- Contenedor del Código (Azul Claro/Grisáceo sutil) -->
          <div style="background-color: #f1f5f9; padding: 24px; text-align: center; border-radius: 12px; margin: 24px 0; border: 1px solid #e2e8f0;">
            <p style="color: #64748b; font-size: 12px; text-transform: uppercase; letter-spacing: 1.5px; margin: 0 0 12px 0; font-weight: 600;">Tu código de verificación</p>
            <!-- Código en Rojo Pastel -->
            <span style="font-size: 36px; font-weight: 700; letter-spacing: 6px; color: #e06666; display: inline-block;">${codigo}</span>
          </div>
          
          <!-- Nota de Expiración -->
          <div style="display: flex; align-items: center; margin-bottom: 24px;">
            <p style="color: #475569; font-size: 14px; margin: 0;">
              ⏱️ Este código expira en <strong style="color: #0f172a;">15 minutos</strong>.
            </p>
          </div>
          
          <hr style="border: none; border-top: 1px solid #e2e8f0; margin: 32px 0 24px 0;">
          
          <!-- Pie de página informativo -->
          <p style="color: #94a3b8; font-size: 12px; line-height: 1.5; margin: 0; text-align: center;">
            Si tú no solicitaste este cambio, puedes ignorar este correo de forma segura. Tu contraseña actual seguirá siendo la misma.
          </p>
        </div>

        <!-- Fondo del correo / Copyright -->
        <div style="background-color: #f8fafc; padding: 16px; text-align: center; border-top: 1px solid #e2e8f0;">
          <p style="color: #64748b; font-size: 11px; margin: 0;">&copy; ${new Date().getFullYear()} Alcris. Todos los derechos reservados.</p>
        </div>

      </div>
    `,
  };

  try {
    const info = await transporter.sendMail(mailOptions);
    console.log("Correo de recuperación enviado con éxito. ID:", info.messageId);
    return { success: true, messageId: info.messageId };
  } catch (error) {
    console.error("Error crítico enviando email de recuperación:", error);
    return { success: false, error: error.message };
  }
};

