import {
    obtenerDisponibilidad,
    obtenerDisponibilidadPorTecnico,
    obtenerSlotsDisponibles,
    obtenerDisponibilidadPorId,
    crearDisponibilidad,
    actualizarDisponibilidad,
    eliminarDisponibilidad,
} from '../models/disponibilidad.js';
 
// GET /disponibilidad/obtener
export const getDisponibilidad = async (req, res) => {
    try {
        const { data, error } = await obtenerDisponibilidad();
        if (error) return res.status(500).json({ error: error.message });
        return res.status(200).json({ disponibilidad: data });
    } catch (error) {
        console.error('Error al obtener disponibilidad:', error);
        return res.status(500).json({ error: error.message });
    }
};
 
// GET /disponibilidad/tecnico/:tecnico_id
export const getDisponibilidadPorTecnico = async (req, res) => {
    try {
        const { tecnico_id } = req.params;
        const { data, error } = await obtenerDisponibilidadPorTecnico(tecnico_id);
        if (error) return res.status(500).json({ error: error.message });
        return res.status(200).json({ disponibilidad: data });
    } catch (error) {
        console.error('Error al obtener disponibilidad por tecnico:', error);
        return res.status(500).json({ error: error.message });
    }
};
 
// GET /disponibilidad/slots?fecha=2025-07-15
export const getSlots = async (req, res) => {
    try {
        const { fecha } = req.query;
        const { data, error } = await obtenerSlotsDisponibles(fecha || null);
        if (error) return res.status(500).json({ error: error.message });
        return res.status(200).json({ slots: data });
    } catch (error) {
        console.error('Error al obtener slots:', error);
        return res.status(500).json({ error: error.message });
    }
};
 
// GET /disponibilidad/obtener/:id
export const getDisponibilidadPorId = async (req, res) => {
    try {
        const { id } = req.params;
        const { data, error } = await obtenerDisponibilidadPorId(id);
        if (error || !data) return res.status(404).json({ error: 'Slot no encontrado' });
        return res.status(200).json({ disponibilidad: data });
    } catch (error) {
        console.error('Error al obtener slot:', error);
        return res.status(500).json({ error: error.message });
    }
};
 
// POST /disponibilidad/crear
export const postDisponibilidad = async (req, res) => {
    try {
        const { tecnico_id, fecha, hora, disponible } = req.body;
        if (!tecnico_id || !fecha || !hora)
            return res.status(400).json({ error: 'tecnico_id, fecha y hora son requeridos' });
 
        const { data, error } = await crearDisponibilidad(tecnico_id, fecha, hora, disponible);
        if (error) return res.status(500).json({ error: error.message });
        return res.status(201).json({ disponibilidad: data });
    } catch (error) {
        console.error('Error al crear disponibilidad:', error);
        return res.status(500).json({ error: error.message });
    }
};