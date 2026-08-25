//----------------------------------------------------------//
// Servidor Principal - AlCRIS
//----------------------------------------------------------//
import "dotenv/config";
import express from "express";
import cors from "cors";
import routerAuth from "./routes/authRoute.js";
import routerUser from "./routes/userRoute.js";
import routerReserva from "./routes/reservaRoute.js";
import { conectaDB } from "./config/supabase.js";

const app = express();

//----------------------------------------------------------//
// Middlewares globales
//----------------------------------------------------------//
app.use(cors());
app.use(express.json());

//----------------------------------------------------------//
// Conexión a la base de datos
//----------------------------------------------------------//
conectaDB();

//----------------------------------------------------------//
// Rutas
//----------------------------------------------------------//
app.use("/auth", routerAuth);
app.use("/usuarios", routerUser);
app.use("/reservas", routerReserva);

//----------------------------------------------------------//
// Ruta inicial
//----------------------------------------------------------//
app.get("/", (req, res) => {
  res.json({
    mensaje: "Bienvenido al backend de AlCRIS latonería y pintura",
    estado: "en línea",
    version: "1.0.0",
  });
});

//----------------------------------------------------------//
// Manejo de rutas no encontradas
//----------------------------------------------------------//
app.use((req, res) => {
  res.status(404).json({
    error: "Ruta no encontrada",
    mensaje: "La ruta solicitada no existe en este servidor.",
  });
});

//----------------------------------------------------------//
// Configuración del puerto e inicio del servidor
//----------------------------------------------------------//
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Servidor corriendo en el puerto ${PORT}`);
  console.log(`http://localhost:${PORT}`);
});