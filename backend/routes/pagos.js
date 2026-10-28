import { Router } from "express";
import multer from "multer";
import { v2 as cloudinary } from "cloudinary";
import { supabase } from "../config/supabase.js";

cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
});

const router = Router();

// Deben coincidir con tus enums (estado_reserva y forma_pago)
const ESTADO_PENDIENTE = "pendiente";
const FORMA_TRANSFERENCIA = "transferencia";
const EXTENSIONES = ["jpg", "jpeg", "png", "webp"];

const upload = multer({ storage: multer.memoryStorage(), limits: { fileSize: 5 * 1024 * 1024 } });
const subir = (req, res, next) =>
  upload.single("comprobante")(req, res, (err) =>
    err
      ? res.status(400).json({ error: err.code === "LIMIT_FILE_SIZE" ? "La imagen supera 5 MB" : "Archivo inválido" })
      : next()
  );

const fail = (res, e, code = 500) => res.status(code).json({ error: e.message || e });

const subirACloudinary = (buffer) =>
  new Promise((resolve, reject) => {
    cloudinary.uploader
      .upload_stream(
        { folder: "comprobantes_nequi", resource_type: "image", allowed_formats: EXTENSIONES },
        (error, resultado) => (error ? reject(error) : resolve(resultado))
      )
      .end(buffer);
  });

// Reservas del cliente pagadas por transferencia que aún se pueden pagar
router.get("/mis-reservas", async (req, res) => {
  const { data: rs, error } = await supabase
    .from("reservas")
    .select("id, codigo_reserva, fecha_cita, hora_cita, total, estado, servicios(nombre)")
    .eq("usuario_id", req.usuario.id)
    .eq("estado", ESTADO_PENDIENTE)
    .eq("forma_pago", FORMA_TRANSFERENCIA)
    .order("fecha_cita");
  if (error) return fail(res, error);

  let pagos = [];
  if (rs.length) {
    const { data } = await supabase.from("pagos").select("reserva_id, estado").in("reserva_id", rs.map((r) => r.id));
    pagos = data ?? [];
  }
  res.json(
    rs.map((r) => ({
      id: r.id,
      codigo: r.codigo_reserva,
      servicio: r.servicios?.nombre ?? "",
      fecha: r.fecha_cita,
      hora: String(r.hora_cita ?? ""),
      total: Math.round(Number(r.total)),
      enRevision: pagos.some((p) => p.reserva_id === r.id && p.estado === "revision"),
    }))
  );
});

// Subir comprobante de una reserva (el cliente solo puede pagar SUS reservas)
router.post("/:reservaId", subir, async (req, res) => {
  const file = req.file;
  const ref = String(req.body.ref_nequi ?? "").trim();
  const monto = Math.round(Number(req.body.monto));

  if (!file) return res.status(400).json({ error: "Falta la foto del comprobante" });
  if (!ref) return res.status(400).json({ error: "La referencia de Nequi es obligatoria" });
  if (!(monto > 0)) return res.status(400).json({ error: "Monto inválido" });

  const ext = (file.originalname.split(".").pop() || "").toLowerCase();
  if (!EXTENSIONES.includes(ext)) return res.status(400).json({ error: "Solo se aceptan imágenes JPG, PNG o WEBP" });

  const { data: reserva } = await supabase
    .from("reservas")
    .select("id, usuario_id, estado, forma_pago")
    .eq("id", req.params.reservaId)
    .single();
  if (!reserva || String(reserva.usuario_id) !== String(req.usuario.id))
    return res.status(404).json({ error: "Reserva no encontrada" });
  if (reserva.forma_pago !== FORMA_TRANSFERENCIA)
    return res.status(409).json({ error: "Esta reserva se paga en efectivo" });
  if (reserva.estado !== ESTADO_PENDIENTE)
    return res.status(409).json({ error: "Esta reserva ya no admite pagos" });

  const { data: previos } = await supabase
    .from("pagos")
    .select("id")
    .eq("reserva_id", reserva.id)
    .in("estado", ["revision", "aprobado"]);
  if (previos?.length) return res.status(409).json({ error: "Esta reserva ya tiene un comprobante en revisión" });

  let subida;
  try {
    subida = await subirACloudinary(file.buffer);
  } catch (e) {
    return fail(res, "No se pudo subir la imagen. Intenta de nuevo.");
  }

  // comprobante_path guarda la URL de Cloudinary
  const { error: eIns } = await supabase
    .from("pagos")
    .insert({ reserva_id: reserva.id, monto, ref_nequi: ref, comprobante_path: subida.secure_url });
  if (eIns) {
    await cloudinary.uploader.destroy(subida.public_id).catch(() => {}); // no dejar imágenes huérfanas
    return fail(res, eIns);
  }
  res.status(201).json({ ok: true });
});

export default router;