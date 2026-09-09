import { Router } from "express";
import { googleAuthentication } from "../controllers/googleauth.controller.js";

const router = Router();

// Endpoint: POST /api/auth/google
router.post("/google", googleAuthentication);

export default router;