import { Router } from "express";
import * as categoria from "../../controllers/servicio/categoriaController.js";
import * as servicio from "../../controllers/servicio/servicioController.js";
import * as paquete from "../../controllers/servicio/paqueteController.js";
import { verificarToken, soloAdmin } from "../../middleware/authMiddleware.js";

const router = Router();

// ---------- CATEGORÍAS ----------
router.get("/categorias", categoria.listar);
router.get("/categorias/:id", categoria.obtener);
router.post("/categorias", verificarToken, soloAdmin, categoria.crear);
router.put("/categorias/:id", verificarToken, soloAdmin, categoria.actualizar);
router.delete("/categorias/:id", verificarToken, soloAdmin, categoria.eliminar);

// ---------- PAQUETES (antes de /:id) ----------
router.get("/paquetes", paquete.listar);
router.get("/paquetes/:id", paquete.obtener);
router.post("/paquetes", verificarToken, soloAdmin, paquete.crear);
router.put("/paquetes/:id", verificarToken, soloAdmin, paquete.actualizar);
router.delete("/paquetes/:id", verificarToken, soloAdmin, paquete.eliminar);

// ---------- SERVICIOS ----------
router.get("/", servicio.listar);
router.get("/:id", servicio.obtener);
router.post("/", verificarToken, soloAdmin, servicio.crear);
router.put("/:id", verificarToken, soloAdmin, servicio.actualizar);
router.delete("/:id", verificarToken, soloAdmin, servicio.eliminar);

export default router;
