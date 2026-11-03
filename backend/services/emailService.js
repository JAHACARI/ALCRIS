import "dotenv/config";

/* ------------------------------------------------------------------ */
/*  Colores de marca                                                   */
/* ------------------------------------------------------------------ */
const C = {
  azulOscuro: "#0b2a6f",
  azul: "#1d4ed8",
  azulSuave: "#eaf1ff",
  azulBorde: "#c7d9ff",
  rojo: "#dc2626",
  rojoOscuro: "#b91c1c",
  rojoSuave: "#fef2f2",
  texto: "#1e293b",
  gris: "#64748b",
  fondo: "#eef2f9",
};

const escapeHtml = (valor = "") =>
  String(valor)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");

/* ------------------------------------------------------------------ */
/*  Envío vía API HTTP de Brevo (funciona en Render sin SMTP)          */
/* ------------------------------------------------------------------ */
const enviarEmailPorAPI = async (mailOptions) => {
  const url = "https://api.brevo.com/v3/smtp/email";

  const datosEmail = {
    sender: {
      name: process.env.EMAIL_FROM_NAME || "Alcris",
      email: process.env.EMAIL_USER, // debe ser el remitente verificado en Brevo
    },
    to: [{ email: mailOptions.to }],
    subject: mailOptions.subject,
    htmlContent: mailOptions.html,
    textContent: mailOptions.text,
  };

  try {
    const response = await fetch(url, {
      method: "POST",
      headers: {
        "api-key": process.env.BREVO_API_KEY?.trim(),
        "Content-Type": "application/json",
        accept: "application/json",
      },
      body: JSON.stringify(datosEmail),
    });

    const resultado = await response.json();

    if (!response.ok) {
      console.error("❌ ERROR EN LA API DE BREVO:", resultado.message || resultado);
      return { success: false, error: resultado.message };
    }

    console.log("✨ Correo enviado con éxito mediante Brevo. ID:", resultado.messageId);
    return { success: true, messageId: resultado.messageId };
  } catch (error) {
    console.error("❌ ERROR CRÍTICO EN LA PETICIÓN HTTP DE BREVO:", error.message);
    return { success: false, error: error.message };
  }
};

/* ------------------------------------------------------------------ */
/*  Plantilla base (tablas + estilos en línea para que se vea bien     */
/*  en Gmail, Outlook y celulares)                                     */
/* ------------------------------------------------------------------ */
const plantillaCodigo = ({
  preheader,
  nombre,
  titulo,
  mensaje,
  etiquetaCodigo,
  codigo,
  minutos,
  aviso,
}) => `
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="color-scheme" content="light">
  <title>${escapeHtml(titulo)}</title>
</head>
<body style="margin:0; padding:0; background-color:${C.fondo}; font-family:'Segoe UI', Helvetica, Arial, sans-serif;">

  <!-- Texto de vista previa en la bandeja de entrada -->
  <div style="display:none; max-height:0; overflow:hidden; opacity:0; font-size:1px; line-height:1px; color:${C.fondo};">
    ${escapeHtml(preheader)}
  </div>

  <table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:${C.fondo};">
    <tr>
      <td align="center" style="padding:32px 12px;">

        <table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0"
               style="max-width:520px; background-color:#ffffff; border-radius:16px; overflow:hidden; border:1px solid ${C.azulBorde};">

          <!-- Encabezado azul -->
          <tr>
            <td align="center" bgcolor="${C.azulOscuro}"
                style="background-color:${C.azulOscuro}; background-image:linear-gradient(135deg, ${C.azulOscuro} 0%, ${C.azul} 100%); padding:36px 24px 30px 24px;">
              <div style="font-size:30px; font-weight:700; color:#ffffff; letter-spacing:1px; line-height:1.1;">Alcris</div>
              <div style="font-size:14px; color:#bfd3ff; margin-top:6px;">Latonería y Pintura</div>
            </td>
          </tr>

          <!-- Franja roja -->
          <tr>
            <td height="5" bgcolor="${C.rojo}" style="background-color:${C.rojo}; font-size:0; line-height:0;">&nbsp;</td>
          </tr>

          <!-- Contenido -->
          <tr>
            <td style="padding:36px 32px 8px 32px;">
              <h1 style="margin:0 0 12px 0; font-size:22px; line-height:1.3; color:${C.azulOscuro}; font-weight:700;">
                Hola, ${escapeHtml(nombre)}
              </h1>
              <p style="margin:0; font-size:15px; line-height:1.65; color:${C.texto};">
                ${mensaje}
              </p>
            </td>
          </tr>

          <!-- Código -->
          <tr>
            <td style="padding:24px 32px 8px 32px;">
              <table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0"
                     style="background-color:${C.azulSuave}; border:1px solid ${C.azulBorde}; border-left:6px solid ${C.rojo}; border-radius:12px;">
                <tr>
                  <td align="center" style="padding:22px 16px;">
                    <div style="font-size:13px; color:${C.azul}; font-weight:600; margin-bottom:10px;">
                      ${escapeHtml(etiquetaCodigo)}
                    </div>
                    <div style="font-family:'Courier New', Consolas, monospace; font-size:40px; font-weight:700; letter-spacing:10px; color:${C.rojo}; line-height:1.1; padding-left:10px;">
                      ${escapeHtml(codigo)}
                    </div>
                  </td>
                </tr>
              </table>
            </td>
          </tr>

          <!-- Tiempo de expiración -->
          <tr>
            <td align="center" style="padding:20px 32px 8px 32px;">
              <table role="presentation" cellpadding="0" cellspacing="0" border="0">
                <tr>
                  <td style="background-color:${C.rojoSuave}; border:1px solid #fecaca; border-radius:999px; padding:8px 18px; font-size:14px; color:${C.rojoOscuro};">
                    El código expira en <strong>${minutos} minutos</strong>
                  </td>
                </tr>
              </table>
            </td>
          </tr>

          <!-- Aviso de seguridad -->
          <tr>
            <td style="padding:28px 32px 36px 32px;">
              <div style="border-top:1px solid ${C.azulBorde}; padding-top:20px; font-size:13px; line-height:1.6; color:${C.gris}; text-align:center;">
                ${aviso}
              </div>
            </td>
          </tr>

          <!-- Pie -->
          <tr>
            <td align="center" bgcolor="${C.azulOscuro}" style="background-color:${C.azulOscuro}; padding:18px 16px;">
              <div style="font-size:12px; color:#bfd3ff;">
                &copy; ${new Date().getFullYear()} Alcris &middot; Latonería y Pintura
              </div>
            </td>
          </tr>

        </table>

      </td>
    </tr>
  </table>
</body>
</html>
`;

/* ------------------------------------------------------------------ */
/*  Correo: código de verificación de cuenta                           */
/* ------------------------------------------------------------------ */
export const enviarCodigoVerificacion = async (email, codigo, nombre = "Usuario") => {
  const html = plantillaCodigo({
    preheader: `Tu código de verificación es ${codigo}`,
    nombre,
    titulo: "Código de verificación - Alcris",
    mensaje:
      "Gracias por registrarte en Alcris. Usa este código para verificar tu cuenta y terminar el proceso.",
    etiquetaCodigo: "Tu código de verificación",
    codigo,
    minutos: 15,
    aviso:
      "Si no creaste una cuenta en Alcris, puedes ignorar este correo. No se hará ningún cambio.",
  });

  const text = `Hola ${nombre}, tu código de verificación de Alcris es ${codigo}. Expira en 15 minutos. Si no lo solicitaste, ignora este correo.`;

  return await enviarEmailPorAPI({
    to: email,
    subject: "Código de verificación - Alcris",
    html,
    text,
  });
};

/* ------------------------------------------------------------------ */
/*  Correo: código de recuperación de contraseña                       */
/* ------------------------------------------------------------------ */
export const enviarCodigoRecuperacion = async (email, codigo, nombre = "Usuario") => {
  const html = plantillaCodigo({
    preheader: `Tu código para restablecer la contraseña es ${codigo}`,
    nombre,
    titulo: "Recuperación de contraseña - Alcris",
    mensaje:
      "Recibimos una solicitud para restablecer la contraseña de tu cuenta. Ingresa este código para continuar.",
    etiquetaCodigo: "Tu código de recuperación",
    codigo,
    minutos: 15,
    aviso:
      "Si no solicitaste este cambio, ignora este correo. Tu contraseña actual seguirá siendo la misma.",
  });

  const text = `Hola ${nombre}, tu código para restablecer la contraseña de Alcris es ${codigo}. Expira en 15 minutos. Si no lo solicitaste, ignora este correo.`;

  return await enviarEmailPorAPI({
    to: email,
    subject: "Recuperación de contraseña - Alcris",
    html,
    text,
  });
};