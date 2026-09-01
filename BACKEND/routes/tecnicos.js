import express from 'express';
import {
    getTecnicos,
    getTecnicoPorId,
    postTecnico,
    putTecnico,
    deleteTecnico
} from '../controllers/tecnicos.js';

const router = express.Router();

router.get('/obtener', getTecnicos);
router.get('/obtener/:id', getTecnicoPorId);
router.post('/crear', postTecnico);
router.put('/actualizar/:id', putTecnico);
router.delete('/eliminar/:id', deleteTecnico);

export default router;