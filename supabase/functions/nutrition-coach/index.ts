import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

serve(async (req) => {
  const { profile, day, question } = await req.json();
  const geminiKey = Deno.env.get("GEMINI_API_KEY");
  const model = Deno.env.get("GEMINI_MODEL") ?? "gemini-1.5-flash";
  if (!geminiKey) {
    return Response.json({ error: "GEMINI_API_KEY is not configured" }, { status: 500 });
  }

  const prompt =
    `You are a concise nutrition coach for a premium diet app.\n` +
    `User profile: ${JSON.stringify(profile)}\n` +
    `Today: ${JSON.stringify(day)}\n` +
    `Question: ${question}\n` +
    `Give practical meal suggestions (Indian-friendly), protein guidance, and healthier alternatives. Keep it short and actionable.`;

  const response = await fetch(
    `https://generativelanguage.googleapis.com/v1beta/models/${encodeURIComponent(model)}:generateContent?key=${encodeURIComponent(geminiKey)}`,
    {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        contents: [{ role: "user", parts: [{ text: prompt }] }],
        generationConfig: { temperature: 0.5 },
      }),
    },
  );

  const data = await response.json();
  if (!response.ok) {
    return Response.json({ error: "Gemini request failed", details: data }, { status: 502 });
  }

  const message =
    data?.candidates?.[0]?.content?.parts?.map((p: any) => p?.text ?? "").join("") ??
    "I could not generate advice right now.";
  return Response.json({ message });
});
