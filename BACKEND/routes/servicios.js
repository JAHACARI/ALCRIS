import express from 'express';
import {
    getServicios,
    getServicioPorId,
    getServiciosPorCategoria,
    getServiciosPorEstado,
    postServicio,
    updateServicio,
    deleteServicio,
} from '../controllers/servicio.js';
 
const router = express.Router();
 
router.get('/obtener',                      getServicios);
router.get('/obtener/:id',                  getServicioPorId);
router.get('/categoria/:categoria_id',      getServiciosPorCategoria);
router.get('/estado/:estado',               getServiciosPorEstado);
router.post('/crear',                       postServicio);
router.put('/actualizar/:id',               updateServicio);
router.delete('/eliminar/:id',              deleteServicio);
 
export default router;
 