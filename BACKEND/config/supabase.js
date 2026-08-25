// VARIABLES DE ENTORNO
import 'dotenv/config';
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_KEY;

if (!supabaseUrl || !supabaseKey) {
    console.error('❌ Error: las variables de entorno SUPABASE_KEY y SUPABASE_URL son requeridas.');
    process.exit(1);
}

export const supabase = createClient(supabaseUrl, supabaseKey);

export const conectaDB = () => {
    console.log('🖇️ Conexión a Supabase establecida correctamente');
};