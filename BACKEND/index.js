import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import './models/usuario.js';

//configuracion de variables de entorno
dotenv.config();

const app = express();
//Middlewares globales
app.use(cors());
app.use(express.json());

// ruta inicial
app.use('/', (req, res) => {
    res.json({
        Mensaje: 'bienvenido al backend de AlCRIS latoneria y pontura',
        estado: 'en linea',
        version: '1.0.0',
    });
});
//rutas de auntenticacion

//configuracion puerto
const PORT = process.env.PORT || 3000;
//poner a escuchar el servidor
app.listen(PORT, () => {
    console.log(`Servidor corriendo en el puerto ${PORT}`);
    console.log(`http://localhost:${PORT}`);
}); 