# Architecture

## Mobile App

The Flutter app follows a feature-first structure:

- `core`: app configuration, theme, routing, services.
- `features`: auth, onboarding, home, food logging, AI scanner, analytics, progress, profile.
- `shared`: reusable models, providers, and UI widgets.

Riverpod owns app state. Supabase is the source of truth. Hive stores an offline queue for meal, water, and weight logs, then flushes when connectivity returns.

## Backend

Supabase provides:

- Auth with email, Google, Apple, OTP, and secure JWT sessions.
- PostgreSQL tables with RLS.
- Realtime log subscriptions.
- Storage for avatars, food photos, and exports.
- Edge Functions for AI, summaries, reports, and notifications.

## AI

AI features are isolated behind Supabase Edge Functions so provider keys never ship to devices. The current scaffold uses OpenAI Vision. Gemini Vision can be added as a fallback provider by extending `ai-food-analysis`.

## Admin

The Next.js admin panel uses the service role key server-side only. It is intended for private deployment and should be protected by SSO or a reverse-proxy access policy before production.

## Offline Sync

Recommended queue shape:

```json
{
  "id": "client-generated-uuid",
  "type": "meal.create",
  "payload": {},
  "createdAt": "2026-05-08T00:00:00.000Z",
  "attempts": 0
}
```

Conflict policy:

- Daily logs merge by timestamp.
- Meal edits use latest client edit unless a server delete happened.
- Weight logs preserve all entries and dedupe same-day exact values.
