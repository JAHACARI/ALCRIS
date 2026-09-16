import "dotenv/config";
import express from "express";
import cors from "cors";
import { conectarDB } from "./config/supabase.js";

import authRoutes from "./routes/auth/authRoutes.js";
import usuarioRoutes from "./routes/usuario/usuarioRoutes.js";
import vehiculoRoutes from "./routes/vehiculo/vehiculoRoutes.js";
import servicioRoutes from "./routes/servicio/servicioRoutes.js";
import tecnicoRoutes from "./routes/tecnico/tecnicoRoutes.js";
import reservaRoutes from "./routes/reserva/reservaRoutes.js";
import catalogoRoutes from "./routes/catalogo/catalogoRoutes.js";
import chatRoutes from "./routes/chat/chatRoutes.js";

const app = express();

// ---------- Middlewares ----------
app.use(cors());
app.use(express.json());

// ---------- DB ----------
conectarDB();

// ---------- Rutas ----------
app.use("/api/auth", authRoutes);
app.use("/api/usuarios", usuarioRoutes);
app.use("/api/vehiculos", vehiculoRoutes);
app.use("/api/servicios", servicioRoutes);
app.use("/api/tecnicos", tecnicoRoutes);
app.use("/api/reservas", reservaRoutes);
app.use("/api", catalogoRoutes); // /api/colores y /api/acabados
app.use("/api/chat", chatRoutes);

// ---------- Ruta de bienvenida ----------
app.get("/", (req, res) => {
  res.json({
    mensaje: "Bienvenido al backend de Alcris - Latonería y Pintura",
    version: "2.1.0",
    estado: "en línea",
  });
});

// ---------- 404 ----------
app.use((req, res) => {
  res.status(404).json({
    error: "Ruta no encontrada",
    mensaje: `La ruta ${req.method} ${req.path} no existe`,
  });
});

// ---------- Iniciar servidor ----------
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`🚀 Servidor Alcris corriendo en http://localhost:${PORT}`);
});
