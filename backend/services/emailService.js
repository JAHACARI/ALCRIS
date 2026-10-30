import { Resend } from "resend";
import "dotenv/config";

// Inicialización limpia y directa sin constructores conflictivos
// (Asegúrate de que process.env.EMAIL_PASS sea tu API Key de Resend)
const resend = new Resend(process.env.EMAIL_PASS?.trim());

/**
 * Función auxiliar para enviar correos vía la API oficial de Resend
 * (Evita bloqueos de red en Render y fallos de librerías antiguas)
 */
const enviarEmailPorAPI = async (mailOptions) => {
  try {
    const { data, error } = await resend.emails.send({
      from: '"Alcris" <onboarding@resend.dev>', // Correo de prueba gratuito de Resend
      to: [mailOptions.to],
      subject: mailOptions.subject,
      html: mailOptions.html,
    });

    if (error) {
      console.error("❌ ERROR EN LA API DE RESEND:", error.message || error);
      return { success: false, error: error.message };
    }

    console.log("✨ Correo enviado con éxito mediante Resend. ID:", data?.id);
    return { success: true, messageId: data?.id };
  } catch (error) {
    console.error("❌ ERROR CRÍTICO EN EL SERVICIO DE RESEND:", error.message);
    return { success: false, error: error.message };
  }
};

/**
 * Envía el código de verificación de cuenta
 */
export const enviarCodigoVerificacion = async (email, codigo, nombre = "Usuario") => {
  const htmlContent = `
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
    
    <!-- Bloque del Código -->
    <div style="background-color: #f1f5f9; padding: 24px; text-align: center; border-radius: 12px; margin: 24px 0; border: 1px solid #e2e8f0;">
      <span style="font-size: 36px; font-weight: 700; letter-spacing: 6px; color: #e06666; display: inline-block;">${codigo}</span>
    </div>
    
    <!-- Nota de Expiración -->
    <p style="color: #475569; font-size: 14px; margin: 0 0 24px 0;">
      ⏱️ Este código expira en <strong style="color: #0f172a;">15 minutos</strong>.
    </p>
    
    <hr style="border: none; border-top: 1px solid #e2e8f0; margin: 32px 0 24px 0;">
    
    <p style="color: #94a3b8; font-size: 12px; line-height: 1.5; margin: 0;">
      Si no solicitaste este código, puedes ignorar este correo de forma segura. Ningún cambio se aplicará en tu cuenta.
    </p>
  </div>

  <!-- Pie de Página Fijo -->
  <div style="background-color: #f8fafc; padding: 16px; text-align: center; border-top: 1px solid #e2e8f0;">
    <p style="color: #64748b; font-size: 11px; margin: 0;">Alcris - Latonería y Pintura</p>
  </div>
</div>
  `;

  return await enviarEmailPorAPI({
    to: email,
    subject: "Código de verificación - Alcris",
    html: htmlContent
  });
};

/**
 * Envía el código de recuperación de contraseña
 */
export const enviarCodigoRecuperacion = async (email, codigo, nombre = "Usuario") => {
  const htmlContent = `
        <div style="font-family: 'Segoe UI', Arial, sans-serif; max-width: 480px; margin: 0 auto; background-color: #ffffff; border: 1px solid #e1e8ed; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.05);">
        
        <div style="background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%); padding: 32px 24px; text-align: center;">
          <h1 style="color: #ffffff; margin: 0; font-size: 24px; font-weight: 600; letter-spacing: 0.5px;">Alcris</h1>
          <p style="color: #94a3b8; margin: 4px 0 0 0; font-size: 13px;">Latonería y Pintura</p>
        </div>

        <div style="padding: 32px 24px; background-color: #ffffff;">
          <h2 style="color: #0f172a; margin-top: 0; font-size: 20px; font-weight: 600;">Hola, ${nombre}</h2>
          <p style="color: #334155; font-size: 15px; line-height: 1.6; margin: 0 0 24px 0;">
            Recibimos una solicitud para restablecer la contraseña de tu cuenta. No te preocupes, utiliza el siguiente código de seguridad para continuar con el proceso.
          </p>
          
          <div style="background-color: #f1f5f9; padding: 24px; text-align: center; border-radius: 12px; margin: 24px 0; border: 1px solid #e2e8f0;">
            <p style="color: #64748b; font-size: 12px; text-transform: uppercase; letter-spacing: 1.5px; margin: 0 0 12px 0; font-weight: 600;">Tu código de verificación</p>
            <span style="font-size: 36px; font-weight: 700; letter-spacing: 6px; color: #e06666; display: inline-block;">${codigo}</span>
          </div>
          
          <div style="display: flex; align-items: center; margin-bottom: 24px;">
            <p style="color: #475569; font-size: 14px; margin: 0;">
              ⏱️ Este código expira en <strong style="color: #0f172a;">15 minutos</strong>.
            </p>
          </div>
          
          <hr style="border: none; border-top: 1px solid #e2e8f0; margin: 32px 0 24px 0;">
          
          <p style="color: #94a3b8; font-size: 12px; line-height: 1.5; margin: 0; text-align: center;">
            Si tú no solicitaste este cambio, puedes ignorar este correo de forma segura. Tu contraseña actual seguirá siendo la misma.
          </p>
        </div>

        <div style="background-color: #f8fafc; padding: 16px; text-align: center; border-top: 1px solid #e2e8f0;">
          <p style="color: #64748b; font-size: 11px; margin: 0;">&copy; 2026 Alcris. Todos los derechos reservados.</p>
        </div>

      </div>
  `;

  return await enviarEmailPorAPI({
    to: email,
    subject: "Recuperación de contraseña - Alcris",
    html: htmlContent
  });
};