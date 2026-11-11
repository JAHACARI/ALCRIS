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
import { notificarReservaAceptada } from "../../services/notificaciones.js";

// Configuración de Cloudinary (variables de entorno del .env / Render)
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
});

const FORMAS_PAGO = ["efectivo", "transferencia"];
const EXTENSIONES_IMG = ["jpg", "jpeg", "png", "webp"];

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

    // Horario de atención y cupo
    const v = await validarHorario(fecha_cita, String(hora_cita).slice(0, 5));
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

    const { data: paquetesActivos } = await supabase
      .from("paquetes_servicio")
      .select("id, precio")
      .eq("servicio_id", servicio_id)
      .eq("activo", true);

    let subtotal;
    if (paquetesActivos && paquetesActivos.length > 0) {
      // El servicio tiene paquetes: hay que elegir uno y se cobra SU precio
      if (!paquete_id) {
        return res.status(400).json({ error: "Elige un paquete para continuar" });
      }
      const paq = paquetesActivos.find((p) => String(p.id) === String(paquete_id));
      if (!paq) {
        return res
          .status(404)
          .json({ error: "El paquete no existe o ya no está disponible" });
      }
      subtotal = Math.round(Number(paq.precio));
    } else {
      // Servicio antiguo sin paquetes
      subtotal = Math.round(Number(servicio.precio_base));
    }
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
    if (!existente)
      return res.status(404).json({ error: "Reserva no encontrada" });

    const esAdmin = req.usuario.rol === "admin";
    if (!esAdmin && String(existente.usuario_id) !== String(req.usuario.id)) {
      return res.status(403).json({ error: "No tienes permiso" });
    }

    let campos;
    if (esAdmin) {
      campos = { ...req.body };
    } else {
      // El cliente solo puede editar notas o cancelar una reserva pendiente
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

    // ── Notificar al cliente cuando el admin acepta la reserva ──
    if (
      esAdmin &&
      campos.estado === "aceptada" &&
      existente.estado !== "aceptada"
    ) {
      notificarReservaAceptada({ ...existente, ...data }).catch((err) =>
        console.error("Error enviando notificación:", err.message)
      );
    }

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

// GET /api/reservas/disponibilidad?mes=11&anio=2026&fecha=2026-11-20
export const disponibilidad = async (req, res) => {
  try {
    const mes = Number(req.query.mes);
    const anio = Number(req.query.anio);
    if (!(mes >= 1 && mes <= 12) || !(anio >= 2000)) {
      return res.status(400).json({ error: "mes y anio inválidos" });
    }
    const fecha = /^\d{4}-\d{2}-\d{2}$/.test(req.query.fecha ?? "") ? req.query.fecha : null;
    return res.status(200).json(await calcularDisponibilidad(mes, anio, fecha));
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

// POST /api/reservas/:id/comprobante  (multipart: comprobante, monto, ref_nequi)
export const subirComprobante = async (req, res) => {
  console.log("=== INICIO DE RECEPCIÓN DE COMPROBANTE ===");
  try {
    const { id } = req.params;
    const { monto, ref_nequi } = req.body;
    const archivo = req.file;

    // Validación de entrada de datos
    if (!archivo) {
      return res.status(400).json({ ok: false, error: "La foto del comprobante es requerida" });
    }
    const ref = String(ref_nequi ?? "").trim();
    const montoNum = Math.round(Number(monto));
    if (!ref || !(montoNum > 0)) {
      return res.status(400).json({ ok: false, error: "La referencia de Nequi y el monto son requeridos" });
    }
    const ext = (archivo.originalname.split(".").pop() || "").toLowerCase();
    if (!EXTENSIONES_IMG.includes(ext)) {
      return res.status(400).json({ ok: false, error: "Solo se aceptan imágenes JPG, PNG o WEBP" });
    }

    // La reserva debe ser del usuario que sube, pagarse por transferencia y seguir pendiente
    const { data: reserva } = await supabase
      .from("reservas")
      .select("id, usuario_id, estado, forma_pago")
      .eq("id", id)
      .single();
    if (!reserva || String(reserva.usuario_id) !== String(req.usuario.id)) {
      return res.status(404).json({ ok: false, error: "Reserva no encontrada" });
    }
    if (reserva.forma_pago !== "transferencia") {
      return res.status(409).json({ ok: false, error: "Esta reserva se paga en efectivo" });
    }
    if (reserva.estado !== "pendiente") {
      return res.status(409).json({ ok: false, error: "Esta reserva ya no admite pagos" });
    }

    // Evita comprobantes duplicados
    const { data: previos } = await supabase
      .from("pagos")
      .select("id")
      .eq("reserva_id", reserva.id)
      .in("estado", ["revision", "aprobado"]);
    if (previos?.length) {
      return res.status(409).json({ ok: false, error: "Esta reserva ya tiene un comprobante en revisión" });
    }

    console.log("Procesando subida a Cloudinary... Reserva ID:", id);

    // 1. Subir el buffer de Multer directamente a Cloudinary
    const subirACloudinary = () =>
      new Promise((resolve, reject) => {
        const uploadStream = cloudinary.uploader.upload_stream(
          { folder: "comprobantes_alcris", resource_type: "image" },
          (error, result) => (error ? reject(error) : resolve(result))
        );
        uploadStream.end(archivo.buffer);
      });

    const resultadoCloudinary = await subirACloudinary();
    const comprobanteUrl = resultadoCloudinary.secure_url;
    console.log("URL de Cloudinary generada con éxito:", comprobanteUrl);

    // 2. Insertar fila en la tabla 'pagos'
    const { data: pagoInsertado, error: errorInsert } = await supabase
      .from("pagos")
      .insert([
        {
          reserva_id: reserva.id,
          monto: montoNum,
          ref_nequi: ref,
          comprobante_path: comprobanteUrl,
          estado: "revision",
        },
      ])
      .select("id, estado")
      .single();

    // Si Supabase falla, borramos la foto de Cloudinary para no dejar basura
    if (errorInsert || !pagoInsertado) {
      console.error("Error en Supabase INSERT:", errorInsert?.message);
      await cloudinary.uploader.destroy(resultadoCloudinary.public_id).catch(() => {});
      return res.status(500).json({
        ok: false,
        error: errorInsert?.message || "No se pudo registrar el pago en la base de datos.",
      });
    }

    console.log("✅ Pago registrado. Pago ID:", pagoInsertado.id);

    return res.status(201).json({
      ok: true,
      message: "Comprobante procesado y guardado con éxito.",
      pagoId: pagoInsertado.id,
    });
  } catch (error) {
    console.error("❌ Error crítico en subirComprobante:", error.message);
    return res.status(500).json({ ok: false, error: error.message });
  }
};