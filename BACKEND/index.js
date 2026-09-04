//----------------------------------------------------------//
// Servidor Principal - AlCRIS
<<<<<<< HEAD
//----------------------------------------------------------//
import "dotenv/config";
import express from "express";
import cors from "cors";
import routerusers from "./routes/user.js"
import routerdisponibilidad from "./routes/disponibilidad.js"
import routertecnicos from "./routes/tecnicos.js";
import routerServicios from "./routes/servicios.js"
import routerPaqueteservicios from "./routes/paqueteservicios.js"
import routercateServicios from "./routes/cateservicios.js"
import routerVehiculos from "./routes/vehiculos.js"
import routercoloresral from "./routes/coloresral.js"
=======

import "dotenv/config";
import express from "express";
import cors from "cors";

// Rutas de autenticación y usuarios
import routerAuth from "./routes/authRoute.js";
import routerUser from "./routes/userRoute.js";
import routerRecuperacion from "./routes/recuperacionRoute.js";

// Rutas de negocio principal
import routerReserva from "./routes/reservaRoute.js";
import routerSeguimiento from "./routes/seguimientoRoute.js";
import routerAcabado from "./routes/acabadoRoute.js";
import routerEtapa from "./routes/etapaRoute.js";

// Rutas de catálogos y soporte
import routerCategorias from "./routes/cateservicios.js";
import routerColores from "./routes/coloresral.js";
import routerDisponibilidad from "./routes/disponibilidad.js";
import routerPaquetes from "./routes/paqueteservicios.js";
import routerServicios from "./routes/servicios.js";
import routerTecnicos from "./routes/tecnicos.js";
import routerVehiculos from "./routes/vehiculos.js";

>>>>>>> main
import { conectaDB } from "./config/supabase.js";

const app = express();

//----------------------------------------------------------//
// Middlewares globales
<<<<<<< HEAD
//----------------------------------------------------------//
=======

>>>>>>> main
app.use(cors());
app.use(express.json());

//----------------------------------------------------------//
// Conexión a la base de datos
<<<<<<< HEAD
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
=======

conectaDB();

//----------------------------------------------------------//
// Rutas


// Autenticación y usuarios
app.use("/auth", routerAuth);
app.use("/usuarios", routerUser);
app.use("/recuperacion", routerRecuperacion);

// Reservas y seguimiento
app.use("/reservas", routerReserva);
app.use("/seguimiento", routerSeguimiento);

// Catálogos de pintura / proceso
app.use("/acabados", routerAcabado);
app.use("/etapas", routerEtapa);
app.use("/colores-ral", routerColores);

// Servicios y paquetes
app.use("/servicios", routerServicios);
app.use("/categorias-servicio", routerCategorias);
app.use("/paquetes-servicio", routerPaquetes);

// Técnicos, disponibilidad y vehículos
app.use("/tecnicos", routerTecnicos);
app.use("/disponibilidad", routerDisponibilidad);
app.use("/vehiculos", routerVehiculos);

//----------------------------------------------------------//
// Ruta inicial

app.get("/", (req, res) => {
  res.json({
    mensaje: "Bienvenido al backend de AlCRIS latonería y pintura",
    estado: "en línea",
    version: "1.1.0",
    endpoints: {
      auth: "/auth",
      usuarios: "/usuarios",
      recuperacion: "/recuperacion",
      reservas: "/reservas",
      seguimiento: "/seguimiento",
      acabados: "/acabados",
      etapas: "/etapas",
      "colores-ral": "/colores-ral",
      servicios: "/servicios",
      "categorias-servicio": "/categorias-servicio",
      "paquetes-servicio": "/paquetes-servicio",
      tecnicos: "/tecnicos",
      disponibilidad: "/disponibilidad",
      vehiculos: "/vehiculos",
    },
  });
});

//----------------------------------------------------------//
// Manejo de rutas no encontradas

app.use((req, res) => {
  res.status(404).json({
    error: "Ruta no encontrada",
    mensaje: "La ruta solicitada no existe en este servidor.",
  });
});

//----------------------------------------------------------//
// Configuración del puerto e inicio del servidor

>>>>>>> main
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Servidor corriendo en el puerto ${PORT}`);
  console.log(`http://localhost:${PORT}`);
<<<<<<< HEAD
});
=======
});
>>>>>>> main
