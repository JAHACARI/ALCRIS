import express from 'express';
import {
    getServicios,
    getServicioPorId,
    getServiciosPorCategoria, // <-- Ya existe
    getServiciosPorEstado,    // <-- Ya existe
    postServicio,
    putServicio,
    deleteServicio,
} from '../controllers/servicios.js';
 
const router = express.Router();
 
router.get('/obtener',                      getServicios);
router.get('/obtener/:id',                  getServicioPorId);
router.get('/categoria/:categoria_id',      getServiciosPorCategoria); // <-- Ruta activa
router.get('/estado/:estado',               getServiciosPorEstado);    // <-- Ruta activa
router.post('/crear',                       postServicio);
router.put('/actualizar/:id',               putServicio);
router.delete('/eliminar/:id',              deleteServicio);
 
export default router;