import {
  actualizarSeguimiento,
  obtenerSeguimientoPorReserva,
  obtenerReservasPorRango, // 👈 Importación corregida
} from "../../models/reserva/seguimientoModel.js";
import { obtenerEtapas } from "../../models/catalogo/etapaModel.js";

export const actualizarEstado = async (req, res) => {
  try {
    const { id } = req.params;
    const { estado, notas } = req.body;

    if (!estado || !["pendiente", "en_curso", "completado"].includes(estado)) {
      return res.status(400).json({
        error: "Estado inválido. Usa: pendiente, en_curso, completado",
      });
    }

    const { data, error } = await actualizarSeguimiento(id, { estado, notas });
    if (error) return res.status(500).json({ error: error.message });

    return res
      .status(200)
      .json({ message: "Seguimiento actualizado", seguimiento: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const listarPorReserva = async (req, res) => {
  try {
    const { reserva_id } = req.params;
    const { data, error } = await obtenerSeguimientoPorReserva(reserva_id);
    if (error) return res.status(500).json({ error: error.message });
    return res.status(200).json({ seguimiento: data || [] });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const listarEtapas = async (req, res) => {
  try {
    const { data, error } = await obtenerEtapas();
    if (error) return res.status(500).json({ error: error.message });
    return res.status(200).json({ etapas: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

// 🛠️ ENDPOINT DE DISPONIBILIDAD TOTALMENTE OPERATIVO
export const obtenerDiasCopados = async (req, res) => {
  try {
    const { mes, anio } = req.query;

    if (!mes || !anio) {
      return res.status(400).json({ error: "Faltan los parámetros mes y anio" });
    }

    // Límite operativo de tu taller mecánico (5 reservas por día)
    const MAX_CITAS_POR_DIA = 5; 
    
    const mesFormateado = mes.toString().padStart(2, '0');
    const primerDia = `${anio}-${mesFormateado}-01`;
    const ultimoDia = `${anio}-${mesFormateado}-31`; 

    // Consulta real a Supabase a través del modelo
    const { data: reservas, error } = await obtenerReservasPorRango(primerDia, ultimoDia);

    if (error) return res.status(500).json({ error: error.message });

   
    const mapeoFechas = {};
    if (reservas) {
      reservas.forEach((reserva) => {
        if (reserva.fecha_cita) {
          mapeoFechas[reserva.fecha_cita] = (mapeoFechas[reserva.fecha_cita] || 0) + 1;
        }
      });
    }

    // Filtra las fechas del mapa que alcanzaron el tope establecido
    const diasOcupados = Object.keys(mapeoFechas).filter(
      (fecha) => mapeoFechas[fecha] >= MAX_CITAS_POR_DIA
    );

    // Horarios estándar que se pintarán dinámicamente en Flutter
    const horariosTaller = ["8:00 AM", "9:00 AM", "2:00 PM", "7:20 AM"];

    return res.status(200).json({
      dias_ocupados: diasOcupados,
      horas_disponibles: horariosTaller 
    });

  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};