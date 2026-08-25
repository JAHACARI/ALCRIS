import express from 'express';
import {
    getUsuarios,
    getUsuarioPorId,
    updateUsuario,
    deleteUsuario
} from '../controllers/user.js';

const router = express.Router();

router.get('/obtener', getUsuarios);
router.get('/obtener/:id', getUsuarioPorId);
router.put('/actualizar/:id', updateUsuario);
router.delete('/eliminar/:id', deleteUsuario);

export default router;