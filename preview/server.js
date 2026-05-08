const http = require("http");
const fs = require("fs");
const path = require("path");

const port = Number(process.env.PORT || 4173);
const host = process.env.HOST || "0.0.0.0";
const root = __dirname;
const geminiModel = process.env.GEMINI_MODEL || "gemini-1.5-flash";
const geminiFallbackModels = [geminiModel, "gemini-1.5-flash", "gemini-1.5-flash-8b"].filter(
  (modelName, index, all) => modelName && all.indexOf(modelName) === index,
);

function sendJson(res, statusCode, payload) {
  res.writeHead(statusCode, { "Content-Type": "application/json; charset=utf-8" });
  res.end(JSON.stringify(payload));
}

function readJsonBody(req) {
  return new Promise((resolve, reject) => {
    let body = "";
    req.on("data", (chunk) => {
      body += chunk;
      if (body.length > 15 * 1024 * 1024) {
        reject(new Error("Request body too large"));
      }
    });
    req.on("end", () => {
      try {
        resolve(body ? JSON.parse(body) : {});
      } catch (error) {
        reject(error);
      }
    });
    req.on("error", reject);
  });
}

async function analyzeWithGemini({ imageBase64, imageMimeType, cuisineHints }) {
  const geminiApiKey = process.env.GEMINI_API_KEY;
  if (!geminiApiKey) {
    throw new Error("Missing GEMINI_API_KEY on Railway");
  }

  const prompt =
    `Analyze the food photo for a diet tracking app.\n` +
    `Return strict JSON only with:\n` +
    `{ "detectedItems": [ { "foodName": string, "portion": string, "calories": number, "protein": number, "carbs": number, "fat": number, "fiber": number, "confidence": number } ] }\n` +
    `Prioritize Indian and Gujarati foods, thali, homemade meals, street food, gym meals, and restaurant dishes.\n` +
    `Hints: ${cuisineHints.join(", ")}.`;

  let lastFailure = null;
  for (const modelName of geminiFallbackModels) {
    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/${encodeURIComponent(modelName)}:generateContent?key=${encodeURIComponent(geminiApiKey)}`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          contents: [{
            role: "user",
            parts: [
              { text: prompt },
              { inlineData: { mimeType: imageMimeType, data: imageBase64 } },
            ],
          }],
          generationConfig: {
            temperature: 0.2,
            responseMimeType: "application/json",
          },
        }),
      },
    );

    const payload = await response.json();
    if (!response.ok) {
      lastFailure = { model: modelName, payload };
      continue;
    }

    const text = payload?.candidates?.[0]?.content?.parts?.map((part) => part?.text || "").join("") || "{}";
    const parsed = JSON.parse(text || "{}");
    return { ok: true, status: 200, payload: parsed };
  }
  return { ok: false, status: 502, payload: { error: "Gemini request failed", details: lastFailure } };
}

async function proxyToSupabaseScan(body) {
  const supabaseUrl = process.env.SUPABASE_URL;
  const supabaseAnonKey = process.env.SUPABASE_ANON_KEY;
  if (!supabaseUrl || !supabaseAnonKey) {
    throw new Error("Missing SUPABASE_URL or SUPABASE_ANON_KEY on Railway");
  }

  const response = await fetch(`${supabaseUrl}/functions/v1/ai-food-analysis`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "apikey": supabaseAnonKey,
      "Authorization": `Bearer ${supabaseAnonKey}`,
    },
    body: JSON.stringify(body),
  });

  const text = await response.text();
  let payload;
  try {
    payload = text ? JSON.parse(text) : {};
  } catch (_) {
    payload = { raw: text };
  }

  return { ok: response.ok, status: response.status, payload };
}

const server = http.createServer((req, res) => {
  const urlPath = req.url === "/" ? "/index.html" : req.url;
  if (urlPath === "/healthz") {
    res.writeHead(200, { "Content-Type": "text/plain; charset=utf-8" });
    res.end("ok");
    return;
  }
  if (urlPath === "/config") {
    const supabaseUrl = process.env.SUPABASE_URL || "";
    const supabaseAnonKey = process.env.SUPABASE_ANON_KEY || "";
    res.writeHead(200, { "Content-Type": "application/json; charset=utf-8" });
    res.end(JSON.stringify({ supabaseUrl, supabaseAnonKey }));
    return;
  }
  if (urlPath === "/api/scan" && req.method === "POST") {
    readJsonBody(req)
      .then(async (body) => {
        if (!body.imageBase64) {
          sendJson(res, 400, { error: "Missing imageBase64" });
          return;
        }

        const cuisineHints = Array.isArray(body.cuisineHints) && body.cuisineHints.length
          ? body.cuisineHints
          : ["Gujarati", "Indian", "homemade", "street food", "thali"];

        const result = process.env.GEMINI_API_KEY
          ? await analyzeWithGemini({
              imageBase64: body.imageBase64,
              imageMimeType: body.imageMimeType || "image/jpeg",
              cuisineHints,
            })
          : await proxyToSupabaseScan({
              imageBase64: body.imageBase64,
              imageMimeType: body.imageMimeType || "image/jpeg",
              cuisineHints,
            });

        sendJson(res, result.status, result.payload);
      })
      .catch((error) => {
        sendJson(res, 500, { error: error.message || "Scan proxy failed" });
      });
    return;
  }
  const filePath = path.join(root, path.normalize(urlPath).replace(/^(\.\.[/\\])+/, ""));

  fs.readFile(filePath, (error, data) => {
    if (error) {
      res.writeHead(404);
      res.end("Not found");
      return;
    }

    res.writeHead(200, {
      "Content-Type": filePath.endsWith(".html") ? "text/html; charset=utf-8" : "text/plain; charset=utf-8",
    });
    res.end(data);
  });
});

server.listen(port, host, () => {
  console.log(`Aura Diet preview running at http://${host}:${port}`);
});
