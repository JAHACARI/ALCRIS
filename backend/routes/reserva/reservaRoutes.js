import { Router } from "express";
import multer from "multer"; // Importamos multer para manejar el archivo de la foto
import * as reserva from "../../controllers/reserva/reservaController.js";
import * as seguimiento from "../../controllers/reserva/seguimientoController.js";
import { calcularDisponibilidad } from "../../controllers/disponibilidad.js"; // ✅ NUEVA IMPORTACIÓN
import { verificarToken, soloAdmin } from "../../middleware/authMiddleware.js";

// Configuración básica de Multer en memoria
const upload = multer({ storage: multer.memoryStorage() });

const router = Router();

router.use(verificarToken);

// 1️⃣ RUTAS ESTÁTICAS Y ESPECÍFICAS (Siempre van arriba)
router.get("/etapas", seguimiento.listarEtapas);

// ✅ CORREGIDO: Ahora llamamos a la función importada directamente desde disponibilidad.js
router.get("/disponibilidad", async (req, res) => {
  try {
    const { mes, anio, fecha } = req.query;
    if (!mes || !anio) {
      return res.status(400).json({ error: "mes y anio son requeridos" });
    }
    const resultado = await calcularDisponibilidad(Number(mes), Number(anio), fecha);
    return res.status(200).json(resultado);
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
});

router.get("/", reserva.listar);

// 2️⃣ RUTAS CON COMPLEMENTOS DESPUÉS DEL ID (Van en el medio)
router.post("/:id/comprobante", upload.single("comprobante"), reserva.subirComprobante);
router.get("/:reserva_id/seguimiento", seguimiento.listarPorReserva);
router.put("/seguimiento/:id", soloAdmin, seguimiento.actualizarEstado);

// 3️⃣ RUTAS CON PARÁMETROS GENÉRICOS /:id (Siempre van al final de todo)
router.post("/", reserva.crear);
router.get("/:id", reserva.obtener);        
router.put("/:id", reserva.actualizar);    
router.delete("/:id", soloAdmin, reserva.eliminar); 

export default router;
