import { Router } from "express";
import * as reserva from "../../controllers/reserva/reservaController.js";
import * as seguimiento from "../../controllers/reserva/seguimientoController.js";
import { verificarToken, soloAdmin } from "../../middleware/authMiddleware.js";

const router = Router();

router.use(verificarToken);

router.get("/etapas", seguimiento.listarEtapas);
router.post("/", reserva.crear);
router.get("/", reserva.listar);
router.get("/:id", reserva.obtener);
router.put("/:id", reserva.actualizar);
router.delete("/:id", soloAdmin, reserva.eliminar);

// Seguimiento
router.put("/seguimiento/:id", soloAdmin, seguimiento.actualizarEstado);
router.get("/:reserva_id/seguimiento", seguimiento.listarPorReserva);

export default router;
