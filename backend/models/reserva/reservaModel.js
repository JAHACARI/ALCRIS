import { supabase } from "../../config/supabase.js";

const generarCodigoReserva = () => {
  const fecha = new Date();
  const y = fecha.getFullYear().toString().slice(-2);
  const m = String(fecha.getMonth() + 1).padStart(2, "0");
  const d = String(fecha.getDate()).padStart(2, "0");
  const rand = Math.floor(1000 + Math.random() * 9000);
  return `ALC-${y}${m}${d}-${rand}`;
};

export const crearReserva = async (campos) => {
  const codigo_reserva = generarCodigoReserva();

  const { data, error } = await supabase
    .from("reservas")
    .insert({ ...campos, codigo_reserva })
    .select("*")
    .single();

  return { data, error };
};

export const obtenerReservas = async () => {
  const { data, error } = await supabase
    .from("reservas")
    .select(
      `
      *,
      usuario(id, nombre, email, telefono),
      vehiculos(id, marca, modelo, placa),
      servicios(id, nombre),
      paquetes_servicio(id, nombre, precio),
      tecnicos(id, especialidad, usuario(nombre)),
      colores_ral(id, nombre_color, codigo_hex),
      acabados_pintura(id, nombre)
    `,
    )
    .order("created_at", { ascending: false });

  return { data, error };
};

export const obtenerReservasPorUsuario = async (usuario_id) => {
  const { data, error } = await supabase
    .from("reservas")
    .select(
      `
      *,
      vehiculos(id, marca, modelo, placa),
      servicios(id, nombre),
      paquetes_servicio(id, nombre, precio),
      tecnicos(id, especialidad, usuario(nombre)),
      colores_ral(id, nombre_color, codigo_hex),
      acabados_pintura(id, nombre)
    `,
    )
    .eq("usuario_id", usuario_id)
    .order("created_at", { ascending: false });

  return { data, error };
};

export const obtenerReservaPorId = async (id) => {
  const { data, error } = await supabase
    .from("reservas")
    .select(
      `
      *,
      usuario(id, nombre, email, telefono),
      vehiculos(id, marca, modelo, placa, anio),
      servicios(id, nombre),
      paquetes_servicio(id, nombre, precio),
      tecnicos(id, especialidad, usuario(nombre)),
      colores_ral(id, nombre_color, codigo_ral, codigo_hex),
      acabados_pintura(id, nombre)
    `,
    )
    .eq("id", id)
    .single();

  return { data, error };
};

export const actualizarReserva = async (id, campos) => {
  const { data, error } = await supabase
    .from("reservas")
    .update({ ...campos, updated_at: new Date().toISOString() })
    .eq("id", id)
    .select("*")
    .single();

  return { data, error };
};

export const eliminarReserva = async (id) => {
  const { data, error } = await supabase
    .from("reservas")
    .delete()
    .eq("id", id)
    .select("*")
    .single();

  return { data, error };
};
