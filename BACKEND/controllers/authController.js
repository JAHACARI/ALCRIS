import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { supabase } from '../config/supabase.js';
import { crearUsuario, obtenerPorEmail } from '../models/usuario.js';
// CORRECCIÓN RELEGADA: Se cambia a enviarCodigoVerificacion (C y V mayúsculas)
import { enviarCodigoVerificacion } from '../services/emailservices.js';

// REGISTRO
//Aquí tienes el código completo y corregido de la función registro. Solo reemplaza toda la función por esta:
//JavaScrip// REGISTRO
export const registro = async (req, res) => {
    try {
        const { nombre, correo, contrasena, cedula, telefono, localidad } = req.body;

        // 1. Validar que lleguen todos los campos requeridos
        if (!nombre || !correo || !contrasena || !cedula || !telefono || !localidad) {
            return res.status(400).json({
                error: 'Todos los campos son requeridos: nombre, correo, contrasena, cedula, telefono y localidad'
            });
        }

        // 2. Verificar si el email ya está registrado
        const { data: usuarioExiste } = await obtenerPorEmail(correo);
        if (usuarioExiste) {
            return res.status(400).json({
                error: 'El email ya está registrado'
            });
        }

        // 3. Encriptar la contraseña
        const hashedcontrasena = await bcrypt.hash(contrasena, 10);

        // 4. Rol por defecto
        const rolPorDefecto = 'usuario';

        // 5. Generar código de 6 dígitos y fecha de expiración (15 minutos)
        const codigoverificacion = Math.floor(100000 + Math.random() * 900000).toString();
        const codigoverificacionexpiracion = new Date(Date.now() + 15 * 60 * 1000).toISOString();

        // 6. Guardar en Supabase
        const { data: nuevoUsuario, error: errorCreacion } = await crearUsuario(
            nombre,
            correo,
            hashedcontrasena,
            rolPorDefecto,
            cedula,
            telefono,
            localidad,
            codigoverificacion,
            codigoverificacionexpiracion
        );

   if (errorCreacion) {
    console.error('========== ERROR AL CREAR USUARIO ==========');
    console.error(errorCreacion);
    console.error('Mensaje:', errorCreacion.message);
    console.error('Detalles:', errorCreacion.details);
    console.error('Código:', errorCreacion.code);
    console.error('==========================================');
    
    return res.status(500).json({
        error: 'Error al crear el usuario en la base de datos',
        detalle: errorCreacion.message   // ← esto también lo verás en Postman
    });
}

        // 7. Enviar el correo con el código de 6 dígitos
        const resultadoEnvio = await enviarCodigoVerificacion(correo, nombre, codigoverificacion);

        // 8. Normalizar el objeto de usuario
        const usuarioCreado = Array.isArray(nuevoUsuario) ? nuevoUsuario[0] : nuevoUsuario;

        const usuarioRespuesta = {
            id: usuarioCreado.id,
            nombre: usuarioCreado.nombre,
            correo: usuarioCreado.correo,
            rol: usuarioCreado.rol
        };

        // 9. Si Brevo falló, el usuario ya quedó creado, pero avisamos
        if (!resultadoEnvio || !resultadoEnvio.exito) {
            return res.status(201).json({
                message: 'Tu cuenta fue creada, pero hubo un problema enviando el código de verificación a tu correo. Intenta registrarte de nuevo en unos minutos o contacta soporte.',
                correoEnviado: false,
                usuario: usuarioRespuesta
            });
        }

        return res.status(201).json({
            message: 'Usuario registrado con éxito. Hemos enviado un código de 6 dígitos a tu correo.',
            correoEnviado: true,
            usuario: usuarioRespuesta
        });

    } catch (error) {
        console.error('Error en registro:', error);
        return res.status(500).json({
            error: error.message
        });
    }
};

// LOGIN
export const login = async (req, res) => {
    try {
        const { correo, contrasena } = req.body;

        if (!correo || !contrasena) {
            return res.status(400).json({
                error: 'El correo y la contrasena son requeridos'
            });
        }

        const { data: usuario } = await obtenerPorEmail(correo);
        if (!usuario) {
            return res.status(401).json({
                error: 'Credenciales incorrectas'
            });
        }

        // CORRECCIÓN: Se cambió usuario.password por usuario.contrasena para coincidir con el modelo
        const contrasenaValida = await bcrypt.compare(contrasena, usuario.contrasena);
        if (!contrasenaValida) {
            return res.status(401).json({
                error: 'Credenciales incorrectas'
            });
        }

        // CORRECCIÓN: Se cambió usuario.isVerified por usuario.isverified (en minúsculas como en verificarCuenta)
        if (!usuario.isverified) {
            return res.status(403).json({
                error: 'Tu cuenta no ha sido verificada. Por favor ingresa el codigo enviado a tu correo antes de iniciar sesion.'
            });
        }

        const token = jwt.sign(
            { id: usuario.id, rol: usuario.rol },
            process.env.JWT_SECRET,
            { expiresIn: '1d' }
        );

        return res.status(200).json({
            message: 'Inicio de sesion exitoso',
            token,
            usuario: {
                id: usuario.id,
                nombre: usuario.nombre,
                correo: usuario.correo,
                rol: usuario.rol
            }
        });

    } catch (error) {
        console.error('Error en login:', error);
        return res.status(500).json({
            error: error.message
        });
    }
};

// VERIFICAR CUENTA CON CODIGO DE 6 DIGITOS
export const verificarCuenta = async (req, res) => {
    try {
        const { correo, codigo } = req.body;

        if (!correo || !codigo) {
            return res.status(400).json({
                error: 'El email y el codigo de verificacion son requeridos'
            });
        }

        // 1. Buscar al usuario en Supabase
        const { data: usuario, error: errorUsuario } = await supabase
            .from('usuario')
            .select('id, correo, isverified, codigoverificacion, codigoverificacionexpiracion')
            .eq('correo', correo)
            .single();

        if (errorUsuario || !usuario) {
            return res.status(404).json({
                error: 'Usuario no encontrado'
            });
        }

        // 2. Revisar si ya esta activo
        if (usuario.isverified) {
            return res.status(400).json({
                error: 'La cuenta ya se encuentra verificada'
            });
        }

        // 3. Comparar el codigo
        if (String(usuario.codigoverificacion).trim() !== String(codigo).trim()) {
            return res.status(400).json({
                error: 'El codigo de verificacion es incorrecto'
            });
        }

        // 4. Validar expiracion (15 minutos)
        const ahora = new Date();
        const expiracion = new Date(usuario.codigoverificacionexpiracion);

        if (ahora > expiracion) {
            return res.status(400).json({
                error: 'El codigo ha expirado. Por favor solicita uno nuevo'
            });
        }

        // 5. Activar la cuenta
        const { error: errorUpdate } = await supabase
            .from('usuario')
            .update({
                isverified: true,
                codigoverificacion: null,
                codigoverificacionexpiracion: null
            })
            .eq('id', usuario.id);

        if (errorUpdate) {
            return res.status(500).json({
                error: 'Error al actualizar el estado de verificacion'
            });
        }

        return res.status(200).json({
            message: 'Cuenta verificada exitosamente. Ya puedes iniciar sesion en Mimos.'
        });

    } catch (error) {
        console.error('Error en verificarCuenta:', error);
        return res.status(500).json({
            error: error.message
        });
    }
};