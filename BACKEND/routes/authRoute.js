//----------------------------------------------------------//
// Rutas de Autenticación
//----------------------------------------------------------//
import express from "express";
import { registro, login } from "../controllers/authController.js";

const router = express.Router();

//----------------------------------------------------------//
// Registro de usuario
//----------------------------------------------------------//
router.post("/registro", registro);

//----------------------------------------------------------//
// Login de usuario
//----------------------------------------------------------//
router.post("/login", login);

export default router;