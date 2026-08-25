//----------------------------------------------------------//
// Rutas de Seguimiento de Reserva
//----------------------------------------------------------//
import express from "express";
import {
  createSeguimiento,
  getSeguimientosPorReserva,
  getSeguimientoPorId,
  updateSeguimiento,
  deleteSeguimiento,
} from "../controllers/seguimientoController.js";
import { verificarToken, soloAdmin } from "../middleware/authMinddleware.js";

const router = express.Router();

//----------------------------------------------------------//
// Crear seguimiento
//----------------------------------------------------------//
router.post("/crear", verificarToken, createSeguimiento);

//----------------------------------------------------------//
// Obtener seguimientos de una reserva
//----------------------------------------------------------//
router.get("/reserva/:reservaId", verificarToken, getSeguimientosPorReserva);

//----------------------------------------------------------//
// Obtener un seguimiento por ID
//----------------------------------------------------------//
router.get("/obtener/:id", verificarToken, getSeguimientoPorId);

//----------------------------------------------------------//
// Actualizar estado de un seguimiento (solo admin)
//----------------------------------------------------------//
router.put("/actualizar/:id", verificarToken, soloAdmin, updateSeguimiento);

//----------------------------------------------------------//
// Eliminar seguimiento (solo admin)
//----------------------------------------------------------//
router.delete("/eliminar/:id", verificarToken, soloAdmin, deleteSeguimiento);

export default router;