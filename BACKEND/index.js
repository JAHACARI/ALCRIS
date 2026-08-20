import "dotenv/config";
import express from "express";
import cors from "cors";
import routerAuth from "./routes/authRoute.js";
import { conectaDB } from "./config/supabase.js";

const app = express();
//Middlewares globales
app.use(cors());
app.use(express.json());

conectaDB();

// Rutas de autenticacion
app.use("/auth", routerAuth);

// ruta inicial
app.get("/", (req, res) => {
  res.json({
    Mensaje: "bienvenido al backend de AlCRIS latoneria y pontura",
    estado: "en linea",
    version: "1.0.0",
  });
});
// Manejo de rutas no encontradas
app.use((req, res) => {
  res.status(404).json({
    error: "Ruta no encontrada",
    mensaje: "La ruta solicitada no existe en este servidor.",
  });
});

//configuracion puerto
const PORT = process.env.PORT || 3000;
//poner a escuchar el servidor
app.listen(PORT, () => {
  console.log(`Servidor corriendo en el puerto ${PORT}`);
  console.log(`http://localhost:${PORT}`);
});
