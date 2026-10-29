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
  console.log("=== INICIO DE RECEPCIÓN DE COMPROBANTE (CLOUDINARY) ===");
  try {
    const { id } = req.params; 
    const { monto, ref_nequi } = req.body;
    const archivo = req.file;

    if (!archivo) {
      return res.status(400).json({ error: "La foto del comprobante es requerida" });
    }
    if (!ref_nequi || !monto) {
      return res.status(400).json({ error: "La referencia de Nequi y el monto son requeridos" });
    }

    // 1. Promesa para subir el buffer de Multer directamente a Cloudinary
    const subirACloudinary = () => {
      return new Promise((resolve, reject) => {
        const uploadStream = cloudinary.uploader.upload_stream(
          {
            folder: "comprobantes_alcris", // Carpeta organizada en tu Cloudinary
            resource_type: "image",
          },
          (error, result) => {
            if (error) return reject(error);
            resolve(result);
          }
        );
        // Escribe el buffer del archivo en el stream de Cloudinary
        uploadStream.end(archivo.buffer);
      });
    };

    // Executamos la subida
    const resultadoCloudinary = await subirACloudinary();
    
    // 2. Extraemos la URL segura optimizada por Cloudinary
    const comprobanteUrl = resultadoCloudinary.secure_url;
    console.log("URL de Cloudinary generada con éxito:", comprobanteUrl);

    // 3. Insertar fila en tu tabla 'pagos' con la nueva URL de Cloudinary
    const { data: pagoInsertado, error: errorInsert } = await supabase
      .from("pagos")
      .insert([
        {
          reserva_id: isNaN(id) ? id : Number(id),
          usuario_id: req.usuario?.id,             // Vincula el usuario logueado
          monto_nu: Number(monto),                 
          ref_nequi: ref_nequi,                    
          comprobante_path: comprobanteUrl,        // Se guarda la URL de Cloudinary
          estado: "revision",                      
        }
      ])
      .select()
      .single();

    if (errorInsert) {
      console.error("Error insertando en la tabla pagos:", errorInsert);
      throw errorInsert;
    }

    // 4. Sincronizar la tabla de reservas cambiando el estado padre a 'revision'
    await supabase
      .from("reservas")
      .update({ estado: "revision" })
      .eq("id", isNaN(id) ? id : Number(id));

    console.log("=== COMPROBANTE PROCESADO Y GUARDADO EN LA TABLA PAGOS ===");
    return res.status(200).json({ message: "Comprobante procesado con éxito", pago: pagoInsertado });

  } catch (error) {
    console.error("Error crítico en subirComprobante con Cloudinary:", error.message);
    return res.status(500).json({ error: `Error interno del servidor: ${error.message}` });
  }
};