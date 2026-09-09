import jwt from "jsonwebtoken";
import { OAuth2Client } from "google-auth-library";
import { obtenerPorEmail, actualizarUsuario, crearUsuarioGoogle } from "../models/usuario.js";

const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

export const googleAuthentication = async (req, res) => {
    try {
        const { idToken } = req.body;

        if (!idToken) {
            return res.status(400).json({
                error: "El idToken de Google es requerido"
            });
        }

        // 1. Validar el token con Google
        const ticket = await client.verifyIdToken({
            idToken,
            audience: process.env.GOOGLE_CLIENT_ID,
        });

       const payload = ticket.getPayload();
            // Eliminamos correo_verified y extraemos 'sub' como googleId
            const { sub: googleId, email, name: nombre, picture: avatar } = payload;

            // 2. Asegurar si ya existe el usuario
            const { data: usuarioExistente } = await obtenerPorEmail(email);

            let usuarioFinal = null;

            if (usuarioExistente) {
            // Actualizar si el usuario ya existe en el sistema vincular Google
            usuarioFinal = usuarioExistente;
    
                 const datosActualizados = {};
                if (!usuarioExistente.googleId) datosActualizados.googleId = googleId; // Ahora sí existe googleId
                if (!usuarioExistente.avatar && avatar) datosActualizados.avatar = avatar;
                if (!usuarioExistente.inversor) datosActualizados.inversor = "";
    
                    if (Object.keys(datosActualizados).length > 0) {
                     await actualizarUsuario(usuarioExistente.id, datosActualizados);
                  }


        } else {
            // Registrar usuario nuevo
            const { data: nuevoUsuario, error: errorCrear } = await crearUsuarioGoogle({
                nombre,
                email,
                googleId,
                role: "usuario"
            });

            if (errorCrear) {
                return res.status(500).json({
                    error: "Error al registrar el usuario en Supabase",
                    detalles: errorCrear.message
                });
            }

            usuarioFinal = Array.isArray(nuevoUsuario) ? nuevoUsuario[0] : nuevoUsuario;
        }

        // 3. Generar token de sesión JWT
        const token = jwt.sign(
            { id: usuarioFinal.id, rol: usuarioFinal.rol },
            process.env.JWT_SECRET,
            { expiresIn: '3d' }
        );

        return res.status(200).json({
            message: usuarioExistente ? "Inicio de sesión exitoso con Google" : "Registro exitoso con Google",
            token,
            usuario: {
                id: usuarioFinal.id,
                nombre: usuarioFinal.nombre,
                email: usuarioFinal.email,
                role: usuarioFinal.rol,
                avatar: usuarioFinal.avatar || avatar
            }
        });

    } catch (error) {
        console.error("Error en googleAuthentication:", error);
        return res.status(500).json({
            error: "Error en Google devuelto a Supabase"
        });
    }
};