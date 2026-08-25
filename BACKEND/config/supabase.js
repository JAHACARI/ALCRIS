//----------------------------------------------------------//
// Configuración de Supabase
//----------------------------------------------------------//
import "dotenv/config";
import { createClient } from "@supabase/supabase-js";

//----------------------------------------------------------//
// Variables de entorno
//----------------------------------------------------------//
const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_KEY;

//----------------------------------------------------------//
// Validación de variables de entorno
//----------------------------------------------------------//
if (!supabaseUrl || !supabaseKey) {
  console.error(
    "❌ Error: las variables de entorno SUPABASE_KEY y SUPABASE_URL son requeridas.",
  );
  process.exit(1);
}

//----------------------------------------------------------//
// Creación del cliente de Supabase
//----------------------------------------------------------//
export const supabase = createClient(supabaseUrl, supabaseKey);

//----------------------------------------------------------//
// Función para confirmar la conexión
//----------------------------------------------------------//
export const conectaDB = () => {
  console.log("...//_________________________________________//...");
  console.log("✅ Conexión a Supabase establecida correctamente");
};