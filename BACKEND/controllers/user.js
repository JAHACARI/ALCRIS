import {obtenerusuarios, obtenerUsuarioPorId, actualizarUsuario, eliminarUsuario} from '../models/usuario.js'

// obtener todos los usuarios

export const getUsuarios=async(req, res)=> {
    try {
        const {data, error} = await obtenerusuarios();
        if (error){   
        return res.status(500).json({error: error.message});
    }
    return res.status(200).json({
        usuario: data
    });
    } catch (error) {
        console.error('Error al obtener usuarios:', error);
        return res.status(500).json({ error: error.message });
    }
};

// obtener usuario por id
export const getUsuarioPorId = async (req, res) => {
    try {
        const { id } = req.params;
        const { data, error } = await obtenerUsuarioPorId(id);
        if (error || !data) {
            return res.status(404).json({ error: error.message });
        }
        return res.status(200).json({
            usuarios: data
        });
    } catch (error) {
        console.error('Error al obtener usuario:', error);
        return res.status(500).json({ error: error.message });
    }
};
export const updateUsuario = async (req, res)=> {
    //implementar la logica para actualizar el usuario y que encripte la contraseña
    try { const { id } = req.paramas;
        const campos = req.body
        if (campos.contrasena) {
            //encriptar la contraseña
            const bcrypt = await import('bcrypt');
            campos.contrasena = await bcrypt.hash(campos.contrasena, 10);
        } 
            const { data, error } = await actualizarUsuario(id, campos);
        if (error) {
            return res.status(500).json({ error: error.message});
         }
           return res.status(200).json({
            usuarios: data 
        });
    
}catch (error) {
        console.error('Error al actualizar usuario:', error);
        return res.status(500).json({ error: error.message });
}
};
//eliminar usuario
export const deleteUsuario = async (req, res) => {
    try {
        const { id } = req.params;
        const { data, error } = await eliminarUsuario(id);
        if (error) {
            return res.status(500).json({ error: error.message });
        }
        return res.status(200).json({
            usuarios: data
        });
    } catch (error) {
        console.error('Error al eliminar usuario:', error);
        return res.status(500).json({ error: error.message });
    }
};