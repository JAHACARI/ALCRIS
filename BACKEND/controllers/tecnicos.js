import {
    obtenerTecnicos,
    obtenerTecnicoPorId,
    crearTecnico,
    actualizarTecnico,
    eliminarTecnico
} from '../models/tecnicos.js';

export const getTecnicos = async (req, res) => {
    try {
        const { data, error } = await obtenerTecnicos();
        if (error) return res.status(500).json({ error: error.message });
        return res.status(200).json({ tecnicos: data });
    } catch (error) {
        console.error('Error al obtener técnicos:', error);
        return res.status(500).json({ error: error.message });
    }
};

export const getTecnicoPorId = async (req, res) => {
    try {
        const { id } = req.params;
        const { data, error } = await obtenerTecnicoPorId(id);
        if (error || !data) return res.status(404).json({ error: 'Técnico no encontrado' });
        return res.status(200).json({ tecnico: data });
    } catch (error) {
        console.error('Error al obtener técnico:', error);
        return res.status(500).json({ error: error.message });
    }
};

export const postTecnico = async (req, res) => {
    try {
        const { nombre, telefono, especialidad, activo } = req.body;
        if (!nombre) {
            return res.status(400).json({ error: 'El nombre es requerido' });
        }

        const { data, error } = await crearTecnico(nombre, telefono, especialidad, activo);
        if (error) return res.status(500).json({ error: error.message });
        return res.status(201).json({ tecnico: data });
    } catch (error) {
        console.error('Error al crear técnico:', error);
        return res.status(500).json({ error: error.message });
    }
};

export const putTecnico = async (req, res) => {
    try {
        const { id } = req.params;
        const campos = req.body;

        const { data, error } = await actualizarTecnico(id, campos);
        if (error) return res.status(500).json({ error: error.message });
        return res.status(200).json({ tecnico: data });
    } catch (error) {
        console.error('Error al actualizar técnico:', error);
        return res.status(500).json({ error: error.message });
    }
};

export const deleteTecnico = async (req, res) => {
    try {
        const { id } = req.params;
        const { data, error } = await eliminarTecnico(id);
        if (error) return res.status(500).json({ error: error.message });
        return res.status(200).json({ tecnico: data });
    } catch (error) {
        console.error('Error al eliminar técnico:', error);
        return res.status(500).json({ error: error.message });
    }
};