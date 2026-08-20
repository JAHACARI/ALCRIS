//VARIABLES DE ENTORNO
import "dotenv/config";
import { createClient } from "@supabase/supabase-js";


//creacion de la conexion a supabase
const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_KEY;

//variables de conexion
if (!supabaseUrl || !supabaseKey) {
  console.error(
    "❌ Error: las variables de entorno SUPABASE_KEY y SUPABASE_URL son requeridas.",
  );
  process.exit(1);
}

//variables a supabase
export const supabase = createClient(supabaseUrl, supabaseKey);

export const conectaDB = () => {
  console.log("...//_________________________________________//...");
  console.log("✅ Conexión a Supabase establecida correctamente");
};