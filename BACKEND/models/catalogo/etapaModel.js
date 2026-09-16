import { supabase } from "../../config/supabase.js";

export const obtenerEtapas = async () => {
  const { data, error } = await supabase
    .from("etapas_proceso")
    .select("*")
    .order("orden");
  return { data, error };
};
