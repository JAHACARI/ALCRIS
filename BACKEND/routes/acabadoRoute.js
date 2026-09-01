//----------------------------------------------------------//
// Rutas de Acabados de Pintura

import express from "express";
import {
  createAcabado,
  getAcabados,
  getAcabadoPorId,
  updateAcabado,
  deleteAcabado,
} from "../controllers/acabadoController.js";
import { verificarToken, soloAdmin } from "../middleware/authMinddleware.js";

const router = express.Router();

//----------------------------------------------------------//
// Obtener todos los acabados (cualquier usuario autenticado)
router.get("/obtener", verificarToken, getAcabados);

//----------------------------------------------------------//
// Obtener un acabado por ID
router.get("/obtener/:id", verificarToken, getAcabadoPorId);

//----------------------------------------------------------//
// Crear acabado (solo admin)
router.post("/crear", verificarToken, soloAdmin, createAcabado);

//----------------------------------------------------------//
// Actualizar acabado (solo admin)
router.put("/actualizar/:id", verificarToken, soloAdmin, updateAcabado);

//----------------------------------------------------------//
// Eliminar acabado (solo admin)
router.delete("/eliminar/:id", verificarToken, soloAdmin, deleteAcabado);

export default router;