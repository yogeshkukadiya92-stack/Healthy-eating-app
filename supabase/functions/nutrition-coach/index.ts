import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

serve(async (req) => {
  const { profile, day, question } = await req.json();
  const apiKey = Deno.env.get("OPENAI_API_KEY");

  const response = await fetch("https://api.openai.com/v1/responses", {
    method: "POST",
    headers: { "Authorization": `Bearer ${apiKey}`, "Content-Type": "application/json" },
    body: JSON.stringify({
      model: "gpt-4.1-mini",
      input: `You are a concise nutrition coach for a premium diet app. User profile: ${JSON.stringify(profile)}. Today: ${JSON.stringify(day)}. Question: ${question}. Give practical meal suggestions, protein guidance, and healthier alternatives.`,
    }),
  });

  const data = await response.json();
  return Response.json({ message: data.output_text ?? "I could not generate advice right now." });
});
