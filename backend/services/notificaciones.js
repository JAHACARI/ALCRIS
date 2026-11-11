import { supabase } from "../config/supabase.js";

const enviarCorreo = async ({ para, nombre, asunto, html }) => {
  if (!process.env.BREVO_API_KEY_NOTIFICACIONES || !process.env.BREVO_SENDER_EMAIL) {
    throw new Error("Faltan variables de entorno de Brevo en el servidor");
  }

  const resp = await fetch("https://api.brevo.com/v3/smtp/email", {
    method: "POST",
    headers: {
      accept: "application/json",
      "content-type": "application/json",
      "api-key": process.env.BREVO_API_KEY_NOTIFICACIONES,
    },
    body: JSON.stringify({
      sender: { name: "Alcris", email: process.env.BREVO_SENDER_EMAIL },
      to: [{ email: para, name: nombre || "Cliente" }],
      subject: asunto,
      htmlContent: html,
    }),
  });

  if (!resp.ok) {
    const detalle = await resp.text();
    throw new Error(`Brevo ${resp.status}: ${detalle}`);
  }

  console.log(`Correo enviado exitosamente a ${para}`);
};

const obtenerUsuario = async (usuarioId) => {
  const { data, error } = await supabase
    .from("usuario") // Verifica si en Supabase es "usuario" o "usuarios"
    .select("nombre, email")
    .eq("id", usuarioId)
    .single();

  if (error) {
    console.error("Error consultando usuario en Supabase:", error.message);
    return null;
  }

  return data;
};

export const notificarReservaAceptada = async (reserva) => {
  console.log("Iniciando notificación para reserva:", reserva.id, "usuario_id:", reserva.usuario_id);

  const usuario = await obtenerUsuario(reserva.usuario_id);
  if (!usuario?.email) {
    console.warn("Notificación cancelada: No se encontró email para el usuario", reserva.usuario_id);
    return;
  }

  await enviarCorreo({
    para: usuario.email,
    nombre: usuario.nombre,
    asunto: "¡Tu reserva fue aceptada!",
    html: `
      <p>Hola ${usuario.nombre},</p>
      <p>Tu reserva para el <b>${reserva.fecha_cita}</b> a las
      <b>${String(reserva.hora_cita).slice(0, 5)}</b> fue aceptada.</p>
      <p>¡Te esperamos!</p>
    `,
  });
};

export const notificarReservaRechazada = async (reserva, motivo) => {
  const usuario = await obtenerUsuario(reserva.usuario_id);
  if (!usuario?.email) {
    console.warn("Notificación cancelada: No se encontró email para el usuario", reserva.usuario_id);
    return;
  }

  await enviarCorreo({
    para: usuario.email,
    nombre: usuario.nombre,
    asunto: "Tu reserva fue rechazada",
    html: `
      <p>Hola ${usuario.nombre},</p>
      <p>Lamentablemente tu reserva del <b>${reserva.fecha_cita}</b> a las
      <b>${String(reserva.hora_cita).slice(0, 5)}</b> fue rechazada.</p>
      <p><b>Motivo:</b> ${motivo || "No especificado"}</p>
      <p>Puedes hacer una nueva reserva cuando quieras.</p>
    `,
  });
};