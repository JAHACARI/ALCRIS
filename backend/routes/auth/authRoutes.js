import { Router } from "express";
import {
  registro,
  verificarCuenta,
  reenviarCodigo,
  login,
  googleAuth,
  solicitarRecuperacion,
  restablecerPassword,
} from "../../controllers/auth/authController.js";

const router = Router();

router.post("/registro", registro);
router.post("/verificar", verificarCuenta);
router.post("/reenviar-codigo", reenviarCodigo);
router.post("/login", login);
router.post("/google", googleAuth);
router.post("/recuperar", solicitarRecuperacion);
router.post("/restablecer", restablecerPassword);

export default router;
