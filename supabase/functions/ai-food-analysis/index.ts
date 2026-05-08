import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.0";

const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });

  const {
    imageUrl,
    imageBase64,
    imageMimeType = "image/jpeg",
    userId,
    cuisineHints = ["Gujarati", "Indian", "homemade"],
    model = Deno.env.get("GEMINI_MODEL") ?? "gemini-1.5-flash",
  } = await req.json();

  const geminiKey = Deno.env.get("AIzaSyAzHUik20E9ZpXB6g3Dfu8AN8HwW2kJWQU");
  if (!geminiKey) {
    return Response.json({ error: "GEMINI_API_KEY is not configured" }, { status: 500, headers: cors });
  }

  if (!imageUrl && !imageBase64) {
    return Response.json({ error: "Provide imageUrl or imageBase64" }, { status: 400, headers: cors });
  }

  const prompt =
    `Analyze the food photo for a diet tracking app.\n` +
    `Return strict JSON only with:\n` +
    `{ \"detectedItems\": [ { \"foodName\": string, \"portion\": string, \"calories\": number, \"protein\": number, \"carbs\": number, \"fat\": number, \"fiber\": number, \"confidence\": number } ] }\n` +
    `Prioritize Indian/Gujarati foods (thali, street food, restaurant, homemade, gym meals) and nutrition label scanning.\n` +
    `Hints: ${cuisineHints.join(", ")}.`;

  const parts: Array<Record<string, unknown>> = [{ text: prompt }];
  if (imageBase64) {
    parts.push({
      inlineData: {
        mimeType: imageMimeType,
        data: imageBase64,
      },
    });
  } else {
    // Note: Gemini supports file URI inputs when accessible. If your images are private, pass base64 instead.
    parts.push({
      fileData: {
        mimeType: imageMimeType,
        fileUri: imageUrl,
      },
    });
  }

  const geminiResp = await fetch(
    `https://generativelanguage.googleapis.com/v1beta/models/${encodeURIComponent(model)}:generateContent?key=${encodeURIComponent(geminiKey)}`,
    {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        contents: [{ role: "user", parts }],
        generationConfig: {
          temperature: 0.2,
          responseMimeType: "application/json",
        },
      }),
    },
  );

  const geminiPayload = await geminiResp.json();
  if (!geminiResp.ok) {
    return Response.json({ error: "Gemini request failed", details: geminiPayload }, { status: 502, headers: cors });
  }

  const text =
    geminiPayload?.candidates?.[0]?.content?.parts?.map((p: any) => p?.text ?? "").join("") ??
    "{}";

  const parsed = JSON.parse(text || "{}");

  const supabase = createClient(Deno.env.get("https://tfbltraojcszrlobeurd.supabase.co")!, Deno.env.get("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRmYmx0cmFvamNzenJsb2JldXJkIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3ODIxNzA1NiwiZXhwIjoyMDkzNzkzMDU2fQ.WzKOsWoHtbZwFnRdL_jBiVrNsUqVcxeMxMGbUuFW-xc")!);
  await supabase.from("ai_food_analyses").insert({
    user_id: userId,
    image_url: imageUrl,
    provider: "gemini",
    detected_items: parsed.detectedItems ?? [],
    confidence: parsed.confidence ?? null,
  });

  return Response.json(parsed, { headers: cors });
});
