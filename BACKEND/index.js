import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import './models/usuario.js';
import { conectaDB,supabase} from './config/supabase.js';
//cargar variables de entorno
conectaDB();

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

//configuracion puerto
const PORT = process.env.PORT || 3000;
//poner a escuchar el servidor
app.listen(PORT, () => {
    console.log(`Servidor corriendo en el puerto ${PORT}`);
    console.log(`http://localhost:${PORT}`);
}); 