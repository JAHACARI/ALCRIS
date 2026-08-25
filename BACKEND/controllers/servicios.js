import {
    obtenerServicios,
    obtenerServicioPorId,
    crearServicio,
    actualizarServicio,
    eliminarServicio
} from '../models/servicios.js';

export const getServicios = async (req, res) => {
    try {
        const { data, error } = await obtenerServicios();
        if (error) return res.status(500).json({ error: error.message });
        return res.status(200).json({ servicios: data });
    } catch (error) {
        console.error('Error al obtener servicios:', error);
        return res.status(500).json({ error: error.message });
    }
};

export const getServicioPorId = async (req, res) => {
    try {
        const { id } = req.params;
        const { data, error } = await obtenerServicioPorId(id);
        if (error || !data) return res.status(404).json({ error: 'Servicio no encontrado' });
        return res.status(200).json({ servicio: data });
    } catch (error) {
        console.error('Error al obtener servicio:', error);
        return res.status(500).json({ error: error.message });
    }
};

export const postServicio = async (req, res) => {
    try {
        const { nombre, descripcion, precio, duracion_minutos } = req.body;
        if (!nombre) {
            return res.status(400).json({ error: 'El nombre es requerido' });
        }

        const { data, error } = await crearServicio(nombre, descripcion, precio, duracion_minutos);
        if (error) return res.status(500).json({ error: error.message });
        return res.status(201).json({ servicio: data });
    } catch (error) {
        console.error('Error al crear servicio:', error);
        return res.status(500).json({ error: error.message });
    }
};

export const putServicio = async (req, res) => {
    try {
        const { id } = req.params;
        const campos = req.body;

        const { data, error } = await actualizarServicio(id, campos);
        if (error) return res.status(500).json({ error: error.message });
        return res.status(200).json({ servicio: data });
    } catch (error) {
        console.error('Error al actualizar servicio:', error);
        return res.status(500).json({ error: error.message });
    }
};

export const deleteServicio = async (req, res) => {
    try {
        const { id } = req.params;
        const { data, error } = await eliminarServicio(id);
        if (error) return res.status(500).json({ error: error.message });
        return res.status(200).json({ servicio: data });
    } catch (error) {
        console.error('Error al eliminar servicio:', error);
        return res.status(500).json({ error: error.message });
    }
};