import { Router } from "express";
import {
  crearCategoria,
  obtenerCategorias,
  obtenerCategoriaPorId,
  actualizarCategoria,
  eliminarCategoria,
} from "../controllers/cateservicios.js";

const router = Router();

// Nota: como en index.js se monta en /categorias-servicio,
// aquí las rutas quedan relativas a ese prefijo.
router.post("/", crearCategoria);
router.get("/", obtenerCategorias);
router.get("/:id", obtenerCategoriaPorId);
router.put("/:id", actualizarCategoria);
router.delete("/:id", eliminarCategoria);

export default router;
