
import "dotenv/config";
import express from "express";
import cors from "cors";
import routerusers from "./routes/user.js"
import routerAuth from "./routes/auth1Route.js"
import routerdisponibilidad from "./routes/disponibilidad.js"
import routertecnicos from "./routes/tecnicos.js";
import routerServicios from "./routes/servicios.js"
import routerPaqueteservicios from "./routes/paqueteservicios.js"
import routercateServicios from "./routes/cateservicios.js"
import routerVehiculos from "./routes/vehiculos.js"
import routercoloresral from "./routes/coloresral.js"
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
app.use("/disponibilidad", routerdisponibilidad);
app.use("/tecnicos", routertecnicos);
app.use("/servicios", routerServicios);
app.use("/user", routerusers);
app.use("/paquete",routerPaqueteservicios);
app.use("/cateservi", routercateServicios);
app.use("/vehiculos", routerVehiculos);
app.use("/coloresral", routercoloresral);
app.use("/auth", routerAuth);

app.post("/test-register", (req, res) => {
  res.json({ mensaje: "¡La ruta directa sí funciona!", recibido: req.body });
});

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
