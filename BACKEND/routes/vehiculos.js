import { Router } from 'express';
import {
  crearVehiculo,
  obtenerVehiculos,
  obtenerVehiculoPorId,
  actualizarVehiculo,
  eliminarVehiculo
} from '../controllers/vehiculos.js';
 
const router = Router();
 
router.post('/vehiculos', crearVehiculo);
router.get('/vehiculos', obtenerVehiculos);
router.get('/vehiculos/:id', obtenerVehiculoPorId);
router.put('/vehiculos/:id', actualizarVehiculo);
router.delete('/vehiculos/:id', eliminarVehiculo);
 
export default router;