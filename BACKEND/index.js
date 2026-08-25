import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import { conectaDB } from './config/supabase.js';

import userRoutes from './routes/user.js';
import disponibilidadRoutes from './routes/disponibilidad.js';
import tecnicosRoutes from './routes/tecnicos.js';
import serviciosRoutes from './routes/servicios.js';

conectaDB();

const app = express();

// Middlewares
app.use(cors());
app.use(express.json());

// Ruta de bienvenida
app.get('/', (req, res) => {
    res.json({
        mensaje: 'Bienvenido al backend de AlCRIS Latonería y Pintura',
        estado: 'en línea',
        version: '1.0.0'
    });
});

// Rutas
app.use('/user', userRoutes);
app.use('/disponibilidad', disponibilidadRoutes);
app.use('/tecnicos', tecnicosRoutes);
app.use('/servicios', serviciosRoutes);

// Puerto
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Servidor corriendo en el puerto ${PORT}`);
    console.log(`http://localhost:${PORT}`);
});