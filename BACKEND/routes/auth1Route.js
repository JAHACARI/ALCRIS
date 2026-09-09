//----------------------------------------------------------//
// Rutas de Autenticación

import express from "express";
import { registro, login, verificarCuenta } from "../controllers/authController.js";


const router = express.Router();

//----------------------------------------------------------//
// Registro de usuario

router.post("/registro", registro);

// Endpoint: POST /api/auth/google
router.post("/verify-account", verificarCuenta)

//----------------------------------------------------------//
// Login de usuario

router.post("/login", login);

export default router;
