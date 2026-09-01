import { Router } from 'express';
import {
  crearPaquete, 
  obtenerPaquetes, 
  obtenerPaquetePorId, 
  actualizarPaquete, 
  eliminarPaquete
} from '../controllers/paqueteservicios.js'; // Asegúrate de que el archivo físico se llame exactamente así
 
const router = Router();
 
router.post('/paquetes-servicio', crearPaquete);
router.get('/paquetes-servicio', obtenerPaquetes);
router.get('/paquetes-servicio/:id', obtenerPaquetePorId);
router.put('/paquetes-servicio/:id', actualizarPaquete);
router.delete('/paquetes-servicio/:id', eliminarPaquete);
 
export default router;