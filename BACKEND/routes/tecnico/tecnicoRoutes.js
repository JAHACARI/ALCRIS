import { Router } from "express";
import * as tecnico from "../../controllers/tecnico/tecnicoController.js";
import * as horario from "../../controllers/tecnico/horarioController.js";
import { verificarToken, soloAdmin } from "../../middleware/authMiddleware.js";

const router = Router();

// ---------- TÉCNICOS ----------
router.get("/", tecnico.listar);
router.get("/:id", tecnico.obtener);
router.post("/", verificarToken, soloAdmin, tecnico.crear);
router.put("/:id", verificarToken, soloAdmin, tecnico.actualizar);
router.delete("/:id", verificarToken, soloAdmin, tecnico.eliminar);

// ---------- HORARIOS ----------
router.get("/:tecnico_id/horarios", horario.listar);
router.post("/horarios", verificarToken, soloAdmin, horario.crear);
router.put("/horarios/:id", verificarToken, soloAdmin, horario.actualizar);
router.delete("/horarios/:id", verificarToken, soloAdmin, horario.eliminar);

export default router;
