import { Router } from "express";
import { chatear, obtenerHistorial } from "../../controllers/chat/chatController.js";

const router = Router();

// Público: el chat puede usarse sin login (visitantes)
router.post("/", chatear);
router.get("/historial/:sesionId", obtenerHistorial);

export default router;