import { Router } from "express";
import {
  getUsuarios,
  getUsuarioPorId,
  updateUsuario,
  deleteUsuario,
} from "../../controllers/usuario/usuarioController.js";
import { verificarToken, soloAdmin } from "../../middleware/authMiddleware.js";

const router = Router();

router.get("/", verificarToken, soloAdmin, getUsuarios);
router.get("/:id", verificarToken, getUsuarioPorId);
router.put("/:id", verificarToken, updateUsuario);
router.delete("/:id", verificarToken, soloAdmin, deleteUsuario);

export default router;
