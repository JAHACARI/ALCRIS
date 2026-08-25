import { Router } from 'express';
import {
  crearCategoria, obtenerCategorias, obtenerCategoriaPorId, actualizarCategoria, eliminarCategoria
} from '../controllers/cateservicios.js';
 
const router = Router();
 
router.post('/categorias-servicio', crearCategoria);
router.get('/categorias-servicio', obtenerCategorias);
router.get('/categorias-servicio/:id', obtenerCategoriaPorId);
router.put('/categorias-servicio/:id', actualizarCategoria);
router.delete('/categorias-servicio/:id', eliminarCategoria);
 
export default router;
 