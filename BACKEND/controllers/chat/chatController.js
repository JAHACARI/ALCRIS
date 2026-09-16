import Groq from "groq-sdk";
import {
  guardarMensajes,
  obtenerHistorialPorSesion,
  obtenerCatalogoParaChat,
} from "../../models/chat/chatModel.js";

const groq = new Groq({ apiKey: process.env.GROQ_API_KEY });

/**
 * Arma el texto de catálogo que se inyecta en el system prompt
 */
const armarCatalogoTexto = ({ servicios, paquetes, colores, acabados }) => {
  const lineas = [];

  if (servicios.length > 0) {
    lineas.push("SERVICIOS DISPONIBLES:");
    for (const s of servicios) {
      const cat = s.categorias_servicio?.nombre || "General";
      const precio =
        s.precio_base != null
          ? `$${Number(s.precio_base).toLocaleString("es-CO")} COP`
          : "Consultar";
      lineas.push(
        `- ${s.nombre} (${cat}): ${precio}${s.descripcion ? ` | ${s.descripcion}` : ""}`,
      );
    }
    lineas.push("");
  }

  if (paquetes.length > 0) {
    lineas.push("PAQUETES:");
    for (const p of paquetes) {
      const servicio = p.servicios?.nombre || "";
      const precio = `$${Number(p.precio).toLocaleString("es-CO")} COP`;
      const dias =
        p.duracion_dias_min || p.duracion_dias_max
          ? ` | Duración aprox: ${p.duracion_dias_min || "?"}–${p.duracion_dias_max || "?"} días`
          : "";
      const dest = p.destacado ? " [DESTACADO]" : "";
      lineas.push(
        `- ${p.nombre}${servicio ? ` (servicio: ${servicio})` : ""}: ${precio}${dias}${dest}${p.descripcion ? ` | ${p.descripcion}` : ""}`,
      );
    }
    lineas.push("");
  }

  if (colores.length > 0) {
    lineas.push("COLORES RAL (muestra):");
    for (const c of colores) {
      lineas.push(`- ${c.nombre_color} (${c.codigo_ral}) — ${c.codigo_hex}`);
    }
    lineas.push("");
  }

  if (acabados.length > 0) {
    lineas.push("ACABADOS DE PINTURA:");
    for (const a of acabados) {
      lineas.push(`- ${a.nombre}${a.descripcion ? `: ${a.descripcion}` : ""}`);
    }
  }

  if (lineas.length === 0) {
    return "Por el momento no hay servicios ni paquetes cargados en el sistema.";
  }

  return lineas.join("\n");
};

/**
 * POST /api/chat
 * Body: { mensaje, sesionId?, usuarioId? }
 */
export const chatear = async (req, res) => {
  try {
    if (!process.env.GROQ_API_KEY) {
      return res.status(500).json({
        error: "GROQ_API_KEY no está configurada en el archivo .env",
      });
    }

    const { mensaje, sesionId, usuarioId } = req.body;

    if (!mensaje || !String(mensaje).trim()) {
      return res.status(400).json({ error: "Debes enviar un mensaje." });
    }

    const idSesion =
      sesionId ||
      `alcris_${Date.now()}_${Math.random().toString(36).slice(2, 8)}`;
    const idUsuario = usuarioId || req.usuario?.id || null;

    // 1. Catálogo real desde Supabase
    const catalogo = await obtenerCatalogoParaChat();
    if (catalogo.error) {
      console.error("Error al consultar catálogo:", catalogo.error.message);
      return res.status(500).json({ error: "Error al consultar servicios." });
    }

    const catalogoTexto = armarCatalogoTexto(catalogo);

    // 2. System prompt adaptado a Alcris
    const systemPrompt = `
Eres el asesor virtual de "Alcris - Latonería y Pintura", un taller automotriz profesional en Colombia.
Tu nombre es "Alcris Bot". Eres amable, claro, profesional y cercano.

CATÁLOGO ACTUAL DEL TALLER:
${catalogoTexto}

REGLAS DE ATENCIÓN:
1. Si el cliente solo saluda (ej: "Hola", "Buenos días"), responde con cortesía sin listar precios ni el catálogo completo.
   Ejemplo: "¡Hola! Bienvenido a Alcris Latonería y Pintura. ¿En qué podemos ayudarte hoy? Podemos orientarte sobre servicios de latonería, pintura, paquetes, colores RAL y acabados."
2. Da precios, servicios, paquetes, colores o acabados SOLO cuando el cliente pregunte por ellos.
3. Los valores siempre en pesos colombianos ($ COP).
4. Si preguntan por tiempos, usa la duración de los paquetes cuando exista; si no, indica que depende del estado del vehículo y se confirma en diagnóstico.
5. No inventes servicios, precios ni colores que no estén en el catálogo. Si no sabes algo, dilo y sugiere contactar al taller.
6. Sé conciso (máximo 2-4 párrafos cortos) y completa tus oraciones.
7. Si el cliente quiere agendar, indícale que puede hacerlo desde la app o dejando sus datos para una reserva.
`.trim();

    // 3. Inferencia con Groq
    // Modelos recomendados:
    //   - llama-3.1-8b-instant     → free tier (rápido)
    //   - openai/gpt-oss-20b       → free tier (guía SENA)
    //   - llama-3.3-70b-versatile  → solo Enterprise (falla en free)
    const completion = await groq.chat.completions.create({
      model: "openai/gpt-oss-20b",
      messages: [
        { role: "system", content: systemPrompt },
        { role: "user", content: String(mensaje).trim() },
      ],
      temperature: 0.35,
      max_tokens: 600,
    });

    const respuestaTexto =
      completion.choices[0]?.message?.content ||
      "No pude generar una respuesta en este momento. Intenta de nuevo.";

    // 4. Guardar historial (no bloquea la respuesta si falla)
    const registros = [
      {
        sesion_id: idSesion,
        usuario_id: idUsuario,
        emisor: "user",
        mensaje: String(mensaje).trim(),
      },
      {
        sesion_id: idSesion,
        usuario_id: idUsuario,
        emisor: "bot",
        mensaje: respuestaTexto,
      },
    ];

    const { error: errorInsert } = await guardarMensajes(registros);
    if (errorInsert) {
      console.error("Error guardando historial de chat:", errorInsert.message);
    }

    return res.status(200).json({
      respuesta: respuestaTexto,
      sesionId: idSesion,
    });
  } catch (error) {
    console.error("Error en chatbot Alcris:", error);
    return res.status(500).json({
      error: "Error al procesar la respuesta del chatbot",
      detalle: error.message,
    });
  }
};

/**
 * GET /api/chat/historial/:sesionId
 */
export const obtenerHistorial = async (req, res) => {
  try {
    const { sesionId } = req.params;

    if (!sesionId) {
      return res.status(400).json({ error: "sesionId es requerido" });
    }

    const { data, error } = await obtenerHistorialPorSesion(sesionId);

    if (error) {
      return res
        .status(500)
        .json({
          error: "Error al consultar historial",
          detalle: error.message,
        });
    }

    return res.status(200).json({ historial: data || [] });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};
