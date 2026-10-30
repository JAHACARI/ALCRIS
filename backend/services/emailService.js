import "dotenv/config";

/**
 * Función auxiliar para enviar correos vía la API HTTP oficial de Resend
 * (Evita bloqueos de red en Render y crasheos de librerías antiguas)
 */
const enviarEmailPorAPI = async (mailOptions) => {
  // CORRECCIÓN: URL oficial de la API de Resend para el envío de correos
  const url = "https://resend.com";

  const datosEmail = {
    from: '"Alcris" <onboarding@resend.dev>', // Remitente gratuito obligatorio de Resend para pruebas
    to: [mailOptions.to],
    subject: mailOptions.subject,
    html: mailOptions.html,
  };

  try {
    const response = await fetch(url, {
      method: "POST",
      headers: {
        // CORRECCIÓN: Leemos la variable limpia RESEND_API_KEY
        "Authorization": `Bearer ${process.env.RESEND_API_KEY?.trim()}`, 
        "Content-Type": "application/json"
      },
      body: JSON.stringify(datosEmail)
    });

    const resultado = await response.json();

    if (!response.ok) {
      console.error("❌ ERROR EN LA API DE RESEND:", resultado.message || resultado);
      return { success: false, error: resultado.message };
    }

    console.log("✨ Correo enviado con éxito mediante la API de Resend. ID:", resultado.id);
    return { success: true, messageId: resultado.id };
  } catch (error) {
    console.error("❌ ERROR CRÍTICO EN LA PETICIÓN HTTP DE RESEND:", error.message);
    return { success: false, error: error.message };
  }
};

/**
 * Envía el código de verificación de cuenta
 */
export const enviarCodigoVerificacion = async (email, codigo, nombre = "Usuario") => {
  const htmlContent = `
   <div style="font-family: 'Segoe UI', Arial, sans-serif; max-width: 480px; margin: 0 auto; background-color: #ffffff; border: 1px solid #e2e8f0; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);">
  
  <div style="background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%); padding: 32px 24px; text-align: center;">
    <h1 style="color: #ffffff; margin: 0; font-size: 24px; font-weight: 600; letter-spacing: 0.5px;">Alcris</h1>
    <p style="color: #94a3b8; margin: 4px 0 0 0; font-size: 13px;">Latonería y Pintura</p>
  </div>

  <div style="padding: 32px 24px;">
    <h2 style="color: #0f172a; margin-top: 0; font-size: 20px; font-weight: 600;">Hola ${nombre},</h2>
    <p style="color: #334155; font-size: 15px; line-height: 1.6; margin: 0 0 24px 0;">
      Tu código de verificación para completar el proceso de seguridad es el siguiente:
    </p>
    
    <div style="background-color: #f1f5f9; padding: 24px; text-align: center; border-radius: 12px; margin: 24px 0; border: 1px solid #e2e8f0;">
      <span style="font-size: 36px; font-weight: 700; letter-spacing: 6px; color: #e06666; display: inline-block;">${codigo}</span>
    </div>
    
    <p style="color: #475569; font-size: 14px; margin: 0 0 24px 0;">
      ⏱️ Este código expira en <strong style="color: #0f172a;">15 minutos</strong>.
    </p>
    
    <hr style="border: none; border-top: 1px solid #e2e8f0; margin: 32px 0 24px 0;">
    
    <p style="color: #94a3b8; font-size: 12px; line-height: 1.5; margin: 0;">
      Si no solicitaste este código, puedes ignorar este correo de forma segura. Ningún cambio se aplicará en tu cuenta.
    </p>
  </div>

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
