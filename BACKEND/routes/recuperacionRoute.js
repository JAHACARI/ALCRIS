//----------------------------------------------------------//
// Rutas de Recuperación de Contraseña
import express from "express";
import {
  solicitarCodigo,
  resetearContrasena,
} from "../controllers/recuperacionController.js";

const router = express.Router();

router.post("/solicitar", solicitarCodigo);
router.post("/resetear", resetearContrasena);

export default router;