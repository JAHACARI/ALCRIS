//----------------------------------------------------------//
// Servidor Principal - AlCRIS
//----------------------------------------------------------//
import "dotenv/config";
import express from "express";
import cors from "cors";
import routerAuth from "./routes/authRoute.js";
import routerUser from "./routes/userRoute.js";
import routerReserva from "./routes/reservaRoute.js";
import routerSeguimiento from "./routes/seguimientoRoute.js";
import routerdisponibilidad from "./routes/disponibilidad.js"
import routertecnicos from "./routes/tecnicos.js";
import routerServicios from "./routes/servicios.js"
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
app.use("/seguimiento", routerSeguimiento);
app.use("/disponibilidad",routerdisponibilidad);
app.use("/tecnicos",routertecnicos);
app.use("/servicios",routerServicios);

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
});import cors from "cors";
import express from "express";
