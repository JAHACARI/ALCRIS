import { Router } from "express";
import * as categoria from "../../controllers/servicio/categoriaController.js";
import * as servicio from "../../controllers/servicio/servicioController.js";
import * as paquete from "../../controllers/servicio/paqueteController.js";
import * as auth from "../../middleware/authMiddleware.js";

const router = Router();

// Inyección dinámica segura para los controladores
const ejecutar = (modulo, funcionNombre) => (req, res, next) => {
  if (!modulo || !modulo[funcionNombre]) {
    console.error(`❌ ERROR DE CARGA: No se encontró la función "${funcionNombre}" en el módulo.`);
    return res.status(500).json({ 
      error: `La función [${funcionNombre}] no está definida o el archivo no se cargó correctamente.` 
    });
  }
  return modulo[funcionNombre](req, res, next);
};

// Inyección dinámica segura para los middlewares
const verificarToken = (req, res, next) => auth.verificarToken ? auth.verificarToken(req, res, next) : next();
const soloAdmin = (req, res, next) => auth.soloAdmin ? auth.soloAdmin(req, res, next) : next();

// ---------- CATEGORÍAS ----------
router.get("/categorias", ejecutar(categoria, "listar"));
router.get("/categorias/:id", ejecutar(categoria, "obtener"));
router.post("/categorias", verificarToken, soloAdmin, ejecutar(categoria, "crear"));
router.put("/categorias/:id", verificarToken, soloAdmin, ejecutar(categoria, "actualizar"));
router.delete("/categorias/:id", verificarToken, soloAdmin, ejecutar(categoria, "eliminar"));

// ---------- PAQUETES ----------
router.get("/paquetes", ejecutar(paquete, "listar"));
router.get("/paquetes/:id", ejecutar(paquete, "obtener"));
router.post("/paquetes", verificarToken, soloAdmin, ejecutar(paquete, "crear"));
router.put("/paquetes/:id", verificarToken, soloAdmin, ejecutar(paquete, "actualizar"));
router.delete("/paquetes/:id", verificarToken, soloAdmin, ejecutar(paquete, "eliminar"));

// ---------- SERVICIOS ----------
router.get("/", ejecutar(servicio, "listar"));
router.get("/:id", ejecutar(servicio, "obtener"));
router.post("/", verificarToken, soloAdmin, ejecutar(servicio, "crear"));
router.put("/:id", verificarToken, soloAdmin, ejecutar(servicio, "actualizar"));
router.delete("/:id", verificarToken, soloAdmin, ejecutar(servicio, "eliminar"));

export default router;
