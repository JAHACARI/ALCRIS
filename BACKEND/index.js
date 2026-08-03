import 'dotenv/config';
import express from 'express';

connectaDB();

const app = express();

app.use(express.json());

// ruta inicial
app.use('/', (req, res) => {
    res.json({
        Mensaje: 'bienvenido al backend de AlCRIS latoneria y pontura',
        estado: 'en linea',
        version: '1.0.0',
    });
});

// mensage de error 404
app.use((req, res) => {
    res.status(404).json({
        error: 'Ruta no encontrada',
        mensaje: 'La ruta solicitada no existe en este servidor.',
    });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Servidor corriendo en el puerto http://localhost:${PORT}`);
}); 