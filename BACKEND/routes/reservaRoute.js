//----------------------------------------------------------//
// Rutas de Reservas

import express from "express";
import {
  createReserva,
  getReservas,
  getMisReservas,
  getReservaPorId,
  getReservaPorCodigo,
  updateReserva,
  deleteReserva,
} from "../controllers/reservaController.js";
import { verificarToken, soloAdmin } from "../middleware/authMinddleware.js";

const router = express.Router();

//----------------------------------------------------------//
// Crear reserva (usuario autenticado)

router.post("/crear", verificarToken, createReserva);

//----------------------------------------------------------//
// Obtener mis reservas (usuario autenticado)

router.get("/mis-reservas", verificarToken, getMisReservas);

//----------------------------------------------------------//
// Obtener todas las reservas (solo admin)

router.get("/obtener", verificarToken, soloAdmin, getReservas);

//----------------------------------------------------------//
// Obtener una reserva por ID

router.get("/obtener/:id", verificarToken, getReservaPorId);

//----------------------------------------------------------//
// Obtener reserva por código

router.get("/codigo/:codigo", verificarToken, getReservaPorCodigo);

//----------------------------------------------------------//
// Actualizar reserva

router.put("/actualizar/:id", verificarToken, updateReserva);

//----------------------------------------------------------//
// Eliminar reserva (solo admin)

router.delete("/eliminar/:id", verificarToken, soloAdmin, deleteReserva);

export default router;