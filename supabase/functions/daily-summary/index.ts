import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.0";

serve(async (req) => {
  const { userId } = await req.json();
  const supabase = createClient(Deno.env.get("https://tfbltraojcszrlobeurd.supabase.co")!, Deno.env.get("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRmYmx0cmFvamNzenJsb2JldXJkIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3ODIxNzA1NiwiZXhwIjoyMDkzNzkzMDU2fQ.WzKOsWoHtbZwFnRdL_jBiVrNsUqVcxeMxMGbUuFW-xc")!);
  const from = new Date();
  from.setHours(0, 0, 0, 0);

  const { data: meals } = await supabase
    .from("meals")
    .select("total_calories,total_protein,total_carbs,total_fat")
    .eq("user_id", userId)
    .gte("logged_at", from.toISOString());

  const totals = (meals ?? []).reduce((sum, meal) => ({
    calories: sum.calories + Number(meal.total_calories ?? 0),
    protein: sum.protein + Number(meal.total_protein ?? 0),
    carbs: sum.carbs + Number(meal.total_carbs ?? 0),
    fat: sum.fat + Number(meal.total_fat ?? 0),
  }), { calories: 0, protein: 0, carbs: 0, fat: 0 });

  return Response.json({ totals });
});
