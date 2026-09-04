//----------------------------------------------------------//
// Rutas de Usuarios

import express from "express";
import {
  getUsuarios,
  getUsuarioPorId,
  updateUsuario,
  deleteUsuario,
} from "../controllers/userController.js";
import { verificarToken, soloAdmin } from "../middleware/authMinddleware.js";

const router = express.Router();

//----------------------------------------------------------//
// Obtener todos los usuarios (solo admin)

router.get("/obtener", verificarToken, soloAdmin, getUsuarios);

//----------------------------------------------------------//
// Obtener un usuario por ID

router.get("/obtener/:id", verificarToken, getUsuarioPorId);

//----------------------------------------------------------//
// Actualizar un usuario

router.put("/actualizar/:id", verificarToken, updateUsuario);

//----------------------------------------------------------//
// Eliminar un usuario (solo admin)

router.delete("/eliminar/:id", verificarToken, soloAdmin, deleteUsuario);

export default router;
