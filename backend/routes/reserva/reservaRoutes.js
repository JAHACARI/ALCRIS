import { Router } from "express";
import multer from "multer";
import * as reserva from "../../controllers/reserva/reservaController.js";
import * as seguimiento from "../../controllers/reserva/seguimientoController.js";
import { verificarToken, soloAdmin } from "../../middleware/authMiddleware.js";

const router = Router();

// Imágenes en memoria, máximo 5 MB, con error claro si algo falla
const upload = multer({ storage: multer.memoryStorage(), limits: { fileSize: 5 * 1024 * 1024 } });
const subirComprobante = (req, res, next) =>
  upload.single("comprobante")(req, res, (err) =>
    err
      ? res.status(400).json({
          ok: false,
          error: err.code === "LIMIT_FILE_SIZE" ? "La imagen supera 5 MB" : "Archivo inválido",
        })
      : next()
  );

router.use(verificarToken);

router.get("/etapas", seguimiento.listarEtapas);
router.get("/disponibilidad", reserva.disponibilidad);
router.post("/", reserva.crear);
router.get("/", reserva.listar);
router.post("/:id/comprobante", subirComprobante, reserva.subirComprobante);
router.get("/:id", reserva.obtener);
router.put("/:id", reserva.actualizar);
router.delete("/:id", soloAdmin, reserva.eliminar);

// Seguimiento
router.put("/seguimiento/:id", soloAdmin, seguimiento.actualizarEstado);
router.get("/:reserva_id/seguimiento", seguimiento.listarPorReserva);

export default router;