import { Router } from "express";
import multer from "multer"; // Importamos multer para manejar el archivo de la foto
import * as reserva from "../../controllers/reserva/reservaController.js";
import * as seguimiento from "../../controllers/reserva/seguimientoController.js";
import { verificarToken, soloAdmin } from "../../middleware/authMiddleware.js";

// Configuración básica de Multer en memoria
const upload = multer({ storage: multer.memoryStorage() });

const router = Router();

router.use(verificarToken);

// 1️⃣ RUTAS ESTÁTICAS Y ESPECÍFICAS (Siempre van arriba)
router.get("/etapas", seguimiento.listarEtapas);
router.get("/disponibilidad", reserva.disponibilidad);
router.get("/", reserva.listar);

// 2️⃣ RUTAS CON COMPLEMENTOS DESPUÉS DEL ID (Van en el medio)
// ✅ Colocada aquí arriba evita que Express confunda la palabra 'comprobante' con un ID de reserva
router.post("/:id/comprobante", upload.single("comprobante"), reserva.subirComprobante);
router.get("/:reserva_id/seguimiento", seguimiento.listarPorReserva);
router.put("/seguimiento/:id", soloAdmin, seguimiento.actualizarEstado);

// 3️⃣ RUTAS CON PARÁMETROS GENÉRICOS /:id (Siempre van al final de todo)
router.post("/", reserva.crear);
router.get("/:id", reserva.obtener);
router.put("/:id", reserva.actualizar);
router.delete("/:id", soloAdmin, reserva.eliminar);

export default router;