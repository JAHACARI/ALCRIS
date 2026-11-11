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

export const notificarReservaAceptada = async (reserva) => {
  const { data: usuario } = await supabase
    .from("usuario") // ajusta al nombre real de tu tabla
    .select("nombre, email")
    .eq("id", reserva.usuario_id)
    .single();

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