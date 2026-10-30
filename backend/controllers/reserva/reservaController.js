import {
  crearReserva,
  obtenerReservas,
  obtenerReservasPorUsuario,
  obtenerReservaPorId,
  actualizarReserva,
  eliminarReserva,
} from "../../models/reserva/reservaModel.js";
import {
  crearSeguimiento,
  obtenerSeguimientoPorReserva,
} from "../../models/reserva/seguimientoModel.js";
import { obtenerEtapas } from "../../models/catalogo/etapaModel.js";
import { supabase } from "../../config/supabase.js";
import { validarHorario, calcularDisponibilidad } from "../disponibilidad.js";
import { v2 as cloudinary } from "cloudinary";

const FORMAS_PAGO = ["efectivo", "transferencia"];

export const crear = async (req, res) => {
  try {
    const {
      vehiculo_id,
      servicio_id,
      paquete_id,
      tecnico_id,
      color_id,
      acabado_id,
      fecha_cita,
      hora_cita,
      forma_pago = "efectivo",
      notas,
    } = req.body;

    if (!servicio_id || !fecha_cita || !hora_cita) {
      return res
        .status(400)
        .json({ error: "servicio_id, fecha_cita y hora_cita son requeridos" });
    }
    if (!FORMAS_PAGO.includes(forma_pago)) {
      return res.status(400).json({ error: "Forma de pago inválida" });
    }

    // Fecha pasada (hoy en Colombia, UTC-5)
    const hoy = new Date(Date.now() - 5 * 3600 * 1000).toISOString().slice(0, 10);
    if (String(fecha_cita) < hoy) {
      return res.status(400).json({ error: "La fecha de la cita no puede ser pasada" });
    }

    // Validación integrada del horario y cupo mediante la función externa
    const horaFormateada = hora_cita ? String(hora_cita).slice(0, 5) : '';
    const v = await validarHorario(fecha_cita, horaFormateada);
    if (!v.ok) {
      return res.status(v.codigo || 400).json({ error: v.error });
    }

    // El precio sale de la base de datos, nunca del cliente
    const { data: servicio, error: eServ } = await supabase
      .from("servicios")
      .select("precio_base")
      .eq("id", servicio_id)
      .eq("activo", true)
      .single();
    if (eServ || !servicio) {
      return res
        .status(404)
        .json({ error: "El servicio no existe o ya no está disponible" });
    }
    const subtotal = Math.round(Number(servicio.precio_base));
    const materiales = 0;
    const descuento = 0;
    const total = subtotal + materiales - descuento;

    const { data, error } = await crearReserva({
      usuario_id: req.usuario.id,
      vehiculo_id,
      servicio_id,
      paquete_id,
      tecnico_id,
      color_id,
      acabado_id,
      fecha_cita,
      hora_cita,
      subtotal,
      materiales,
      descuento,
      total,
      forma_pago,
      notas,
    });

    if (error) return res.status(500).json({ error: error.message });

    // Crear seguimiento inicial con todas las etapas
    const { data: etapas } = await obtenerEtapas();
    if (etapas && etapas.length > 0) {
      for (const etapa of etapas) {
        await crearSeguimiento({
          reserva_id: data.id,
          etapa_id: etapa.id,
          estado: etapa.orden === 1 ? "en_curso" : "pendiente",
        });
      }
    }

    return res.status(201).json({ message: "Reserva creada", reserva: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const listar = async (req, res) => {
  try {
    const { data, error } =
      req.usuario.rol === "admin"
        ? await obtenerReservas()
        : await obtenerReservasPorUsuario(req.usuario.id);

    if (error) return res.status(500).json({ error: error.message });
    return res.status(200).json({ reservas: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const obtener = async (req, res) => {
  try {
    const { data, error } = await obtenerReservaPorId(req.params.id);
    if (error || !data)
      return res.status(404).json({ error: "Reserva no encontrada" });

    if (
      req.usuario.rol !== "admin" &&
      String(data.usuario_id) !== String(req.usuario.id)
    ) {
      return res.status(403).json({ error: "No tienes permiso" });
    }

    const { data: seguimiento } = await obtenerSeguimientoPorReserva(data.id);

    return res
      .status(200)
      .json({ reserva: data, seguimiento: seguimiento || [] });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const actualizar = async (req, res) => {
  try {
    const { data: existente } = await obtenerReservaPorId(req.params.id);
    if (!existing)
      return res.status(404).json({ error: "Reserva no encontrada" });

    const esAdmin = req.usuario.rol === "admin";
    if (!esAdmin && String(existente.usuario_id) !== String(req.usuario.id)) {
      return res.status(403).json({ error: "No tienes permiso" });
    }

    let campos;
    if (esAdmin) {
      campos = { ...req.body };
    } else {
      campos = {};
      if (req.body.notas !== undefined) campos.notas = req.body.notas;
      if (req.body.estado !== undefined) {
        if (req.body.estado !== "cancelada") {
          return res.status(403).json({ error: "Solo puedes cancelar tu reserva" });
        }
        if (existente.estado !== "pendiente") {
          return res
            .status(409)
            .json({ error: "Solo puedes cancelar reservas pendientes" });
        }
        campos.estado = "cancelada";
      }
    }

    if (Object.keys(campos).length === 0) {
      return res.status(400).json({ error: "No hay nada que actualizar" });
    }

    const { data, error } = await actualizarReserva(req.params.id, campos);
    if (error) return res.status(500).json({ error: error.message });

    return res
      .status(200)
      .json({ message: "Reserva actualizada", reserva: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const eliminar = async (req, res) => {
  try {
    const { data, error } = await eliminarReserva(req.params.id);
    if (error) return res.status(500).json({ error: error.message });
    return res
      .status(200)
      .json({ message: "Reserva eliminada", reserva: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

// Configuración de Cloudinary (Usa las variables de entorno de tu .env)
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
});

// 🔄 Reemplaza la función 'subirComprobante' al final de tu archivo reservaController.js
export const subirComprobante = async (req, res) => {
  console.log("=== INICIO DE RECEPCIÓN DE COMPROBANTE ===");
  try {
    const { id } = req.params; 
    const { monto, ref_nequi } = req.body;
    const archivo = req.file;

    // Validación de entrada de datos
    if (!archivo) {
      console.log("Error: No se recibió ningún archivo en req.file");
      return res.status(400).json({ ok: false, error: "La foto del comprobante es requerida" });
    }
    if (!ref_nequi || !monto) {
      console.log("Error: Datos faltantes en req.body:", { monto, ref_nequi });
      return res.status(400).json({ ok: false, error: "La referencia de Nequi y el monto son requeridos" });
    }

    console.log("Procesando subida a Cloudinary... Reserva ID:", id);

    // 1. Promesa para subir el buffer de Multer directamente a Cloudinary
    const subirACloudinary = () => {
      return new Promise((resolve, reject) => {
        const uploadStream = cloudinary.uploader.upload_stream(
          {
            folder: "comprobantes_alcris",
            resource_type: "image",
          },
          (error, result) => {
            if (error) return reject(error);
            resolve(result);
          }
        );
        uploadStream.end(archivo.buffer);
      });
    };

    // Ejecutamos la subida a Cloudinary
    const resultadoCloudinary = await subirACloudinary();
    const comprobanteUrl = resultadoCloudinary.secure_url;
    console.log("URL de Cloudinary generada con éxito:", comprobanteUrl);

    // 2. Insertar fila en la tabla 'pagos' de Supabase con los nombres exactos de tus columnas
    const { data: pagoInsertado, error: errorInsert } = await supabase
      .from("pagos")
      .insert([
        {
          reserva_id: isNaN(id) ? id : Number(id),
          monto: Number(monto),
          ref_nequi: ref_nequi,                // ✅ Nombre exacto de tu columna en Postgres
          comprobante_path: comprobanteUrl,    // ✅ Vinculado correctamente con la URL de Cloudinary
          estado: "revision",                  // ✅ Forzamos el estado inicial requerido (is_nullable = NO)
        }
      ])
      .select("id, estado")
      .single();

    // Si Supabase falla al guardar, borramos la foto de Cloudinary para no dejar basura
    if (errorInsert || !pagoInsertado) {
      console.error("Error en Supabase INSERT:", errorInsert?.message);
      await cloudinary.uploader.destroy(resultadoCloudinary.public_id).catch(() => {});
      return res.status(500).json({ 
        ok: false, 
        error: errorInsert?.message || "No se pudo registrar el pago en la base de datos." 
      });
    }

    console.log("✅ Pago registrado con éxito en la BD. Pago ID:", pagoInsertado.id);

    // 3. Respuesta exitosa estructurada para Flutter
    return res.status(201).json({ 
      ok: true, 
      message: "Comprobante procesado y guardado con éxito.",
      pagoId: pagoInsertado.id 
    });

  } catch (error) {
    console.error("❌ Error crítico en subirComprobante:", error.message);
    return res.status(500).json({ ok: false, error: error.message });
  }
};