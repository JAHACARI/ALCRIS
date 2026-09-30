// api.js - Colócalo en la carpeta de servicios o utilidades de tu frontend
const BASE_URL = "http://localhost:3000/api";

// Función genérica para obtener datos (GET)
export const apiFetch = async (endpoint) => {
  try {
    const respuesta = await fetch(`${BASE_URL}${endpoint}`);
    if (!respuesta.ok) throw new Error(`Error en la petición: ${respuesta.status}`);
    return await respuesta.json();
  } catch (error) {
    console.error(`Error consultando ${endpoint}:`, error);
    throw error;
  }
};

// Función genérica para enviar datos (POST) como crear reservas o registrar usuarios
export const apiPost = async (endpoint, datos) => {
  try {
    const respuesta = await fetch(`${BASE_URL}${endpoint}`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(datos),
    });
    if (!respuesta.ok) throw new Error(`Error en la petición: ${respuesta.status}`);
    return await respuesta.json();
  } catch (error) {
    console.error(`Error enviando a ${endpoint}:`, error);
    throw error;
  }
};