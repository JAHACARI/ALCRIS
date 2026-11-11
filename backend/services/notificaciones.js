import { supabase } from "../config/supabase.js";

const enviarCorreo = async ({ para, nombre, asunto, html }) => {
  const resp = await fetch("https://api.brevo.com/v3/smtp/email", {
    method: "POST",
    headers: {
      accept: "application/json",
      "content-type": "application/json",
      "api-key": process.env.BREVO_API_KEY_NOTIFICACIONES,
    },
    body: JSON.stringify({
      sender: { name: "Alcris", email: process.env.BREVO_SENDER_EMAIL },
      to: [{ email: para, name: nombre }],
      subject: asunto,
      htmlContent: html,
    }),
  });

  if (!resp.ok) {
    const detalle = await resp.text();
    throw new Error(`Brevo ${resp.status}: ${detalle}`);
  }
};

const obtenerUsuario = async (usuarioId) => {
  const { data } = await supabase
    .from("usuario")
    .select("nombre, email")
    .eq("id", usuarioId)
    .single();
  return data;
};

export const notificarReservaAceptada = async (reserva) => {
  const usuario = await obtenerUsuario(reserva.usuario_id);
  if (!usuario?.email) return;

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
  if (!usuario?.email) return;

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