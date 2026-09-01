//----------------------------------------------------------//
// Rutas de Etapas de Proceso

import express from "express";
import {
  createEtapa,
  getEtapas,
  getEtapaPorId,
  updateEtapa,
  deleteEtapa,
} from "../controllers/etapaController.js";
import { verificarToken, soloAdmin } from "../middleware/authMinddleware.js";

const router = express.Router();

//----------------------------------------------------------//
// Obtener todas las etapas
router.get("/obtener", verificarToken, getEtapas);

//----------------------------------------------------------//
// Obtener una etapa por ID
router.get("/obtener/:id", verificarToken, getEtapaPorId);

//----------------------------------------------------------//
// Crear etapa (solo admin)
router.post("/crear", verificarToken, soloAdmin, createEtapa);

//----------------------------------------------------------//
// Actualizar etapa (solo admin)
router.put("/actualizar/:id", verificarToken, soloAdmin, updateEtapa);

//----------------------------------------------------------//
// Eliminar etapa (solo admin)
router.delete("/eliminar/:id", verificarToken, soloAdmin, deleteEtapa);

export default router;