import { Router } from 'express';
import {
  crearColor,
  obtenerColores,
  obtenerColorPorId,
  actualizarColor,
  eliminarColor
} from '../controllers/coloresral.js';
 
const router = Router();
 
router.post('/colores-ral', crearColor);
router.get('/colores-ral', obtenerColores);
router.get('/colores-ral/:id', obtenerColorPorId);
router.put('/colores-ral/:id', actualizarColor);
router.delete('/colores-ral/:id', eliminarColor);
 
export default router;