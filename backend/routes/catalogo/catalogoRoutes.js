import { Router } from "express";
import * as color from "../../controllers/catalogo/colorController.js";
import * as acabado from "../../controllers/catalogo/acabadoController.js";
import { verificarToken, soloAdmin } from "../../middleware/authMiddleware.js";

const router = Router();

// ---------- COLORES RAL ----------
router.get("/colores", color.listar);
router.get("/colores/:id", color.obtener);
router.post("/colores", verificarToken, soloAdmin, color.crear);
router.put("/colores/:id", verificarToken, soloAdmin, color.actualizar);
router.delete("/colores/:id", verificarToken, soloAdmin, color.eliminar);

// ---------- ACABADOS ----------
router.get("/acabados", acabado.listar);
router.get("/acabados/:id", acabado.obtener);
router.post("/acabados", verificarToken, soloAdmin, acabado.crear);
router.put("/acabados/:id", verificarToken, soloAdmin, acabado.actualizar);
router.delete("/acabados/:id", verificarToken, soloAdmin, acabado.eliminar);

export default router;
