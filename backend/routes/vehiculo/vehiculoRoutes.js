import { Router } from "express";
import {
  crear,
  listarMisVehiculos,
  obtener,
  actualizar,
  eliminar,
} from "../../controllers/vehiculo/vehiculoController.js";
import { verificarToken } from "../../middleware/authMiddleware.js";

const router = Router();

router.use(verificarToken);

router.post("/", crear);
router.get("/", listarMisVehiculos);
router.get("/:id", obtener);
router.put("/:id", actualizar);
router.delete("/:id", eliminar);

export default router;
