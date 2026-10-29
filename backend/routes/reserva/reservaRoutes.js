import { Router } from "express";
import multer from "multer"; // 🆕 Importamos multer para manejar el archivo de la foto
import * as reserva from "../../controllers/reserva/reservaController.js";
import * as seguimiento from "../../controllers/reserva/seguimientoController.js";
import { verificarToken, soloAdmin } from "../../middleware/authMiddleware.js";

// Configuración básica de Multer en memoria
const upload = multer({ storage: multer.memoryStorage() });

const router = Router();

router.use(verificarToken);

router.get("/etapas", seguimiento.listarEtapas);
router.get("/disponibilidad", reserva.disponibilidad);
router.post("/", reserva.crear);
router.get("/", reserva.listar);
router.get("/:id", reserva.obtener);
router.put("/:id", reserva.actualizar);
router.delete("/:id", soloAdmin, reserva.eliminar);

// 🆕 Ruta para recibir el comprobante enviado desde Flutter ('comprobante' coincide con la app)
router.post("/:id/comprobante", upload.single("comprobante"), reserva.subirComprobante);

// Seguimiento
router.put("/seguimiento/:id", soloAdmin, seguimiento.actualizarEstado);
router.get("/:reserva_id/seguimiento", seguimiento.listarPorReserva);

export default router;