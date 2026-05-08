import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.0";

const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });

  const { imageUrl, userId, cuisineHints = ["Gujarati", "Indian", "homemade"] } = await req.json();
  const openAiKey = Deno.env.get("OPENAI_API_KEY");
  if (!openAiKey) {
    return Response.json({ error: "OPENAI_API_KEY is not configured" }, { status: 500, headers: cors });
  }

  const prompt = `Analyze the food photo for a diet tracking app. Return strict JSON only with detectedItems array. Include foodName, portion, calories, protein, carbs, fat, fiber, confidence. Prioritize Indian, Gujarati, thali, street food, gym meal, restaurant, homemade, and nutrition label recognition. Hints: ${cuisineHints.join(", ")}.`;

  const vision = await fetch("https://api.openai.com/v1/responses", {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${openAiKey}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      model: "gpt-4.1-mini",
      input: [{
        role: "user",
        content: [
          { type: "input_text", text: prompt },
          { type: "input_image", image_url: imageUrl },
        ],
      }],
      text: { format: { type: "json_object" } },
    }),
  });

  const payload = await vision.json();
  const text = payload.output_text ?? "{}";
  const parsed = JSON.parse(text);

  const supabase = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
  await supabase.from("ai_food_analyses").insert({
    user_id: userId,
    image_url: imageUrl,
    provider: "openai",
    detected_items: parsed.detectedItems ?? [],
    confidence: parsed.confidence ?? null,
  });

  return Response.json(parsed, { headers: cors });
});
