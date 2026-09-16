import "dotenv/config";
import { createClient } from "@supabase/supabase-js";

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_KEY;

if (!supabaseUrl || !supabaseKey) {
  console.error("❌ Faltan SUPABASE_URL o SUPABASE_KEY en el archivo .env");
  process.exit(1);
}

export const supabase = createClient(supabaseUrl, supabaseKey);

export const conectarDB = () => {
  console.log("✅ Conexión a Supabase lista");
};
