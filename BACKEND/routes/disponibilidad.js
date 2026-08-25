import express from 'express';
import {
    getDisponibilidad,
    getDisponibilidadPorTecnico,
    getSlots,
    getDisponibilidadPorId,
    postDisponibilidad,
    putDisponibilidad,
    deleteDisponibilidad
} from '../controllers/disponibilidad.js';

const router = express.Router();

router.get('/obtener', getDisponibilidad);
router.get('/tecnico/:tecnico_id', getDisponibilidadPorTecnico);
router.get('/slots', getSlots);
router.get('/obtener/:id', getDisponibilidadPorId);
router.post('/crear', postDisponibilidad);
router.put('/actualizar/:id', putDisponibilidad);
router.delete('/eliminar/:id', deleteDisponibilidad);

export default router;