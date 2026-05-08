# Aura Diet

Aura Diet is a premium, minimal diet tracking product scaffold built for Flutter, Supabase, and a Next.js admin panel.

It includes:

- Flutter mobile app with Riverpod, GoRouter, Supabase, charts, offline-ready Hive storage, camera/barcode hooks, biometric login, RevenueCat hooks, and notification packages.
- Supabase PostgreSQL schema with profiles, foods, meals, meal items, water, weight, notifications, subscriptions, achievements, exports, AI analyses, storage buckets, indexes, and RLS.
- Supabase Edge Functions for AI food analysis, nutrition coaching, and daily summaries.
- Next.js admin dashboard for users, food database, subscriptions, notifications, reports, and AI moderation.

## Structure

```text
app/        Flutter mobile app
admin/      Next.js admin dashboard
supabase/   SQL migrations and Edge Functions
docs/       Production notes and implementation roadmap
```

## Mobile Setup

Install Flutter stable, then run:

```bash
cd app
flutter pub get
flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
```

Configure native platform settings for:

- Google and Apple sign-in redirect URLs in Supabase Auth.
- `local_auth` Face ID and fingerprint permissions.
- Camera and photo permissions for AI food scanning.
- FCM/APNs for push notifications.
- RevenueCat entitlement named `premium`.
- Google Fit and Apple Health permissions.

## Supabase Setup

Create a Supabase project, then apply migrations:

```bash
supabase db push
supabase functions deploy ai-food-analysis
supabase functions deploy nutrition-coach
supabase functions deploy daily-summary
```

Set secrets:

```bash
supabase secrets set SERVICE_ROLE_KEY=...
supabase secrets set GEMINI_API_KEY=...
```

The schema uses RLS so users can only access their own logs. The `foods` table is globally readable for search.

## Admin Setup

```bash
cd admin
npm install
npm run dev
```

Create `admin/.env.local`:

```env
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

Deploy the admin dashboard to Vercel, Netlify, or a private internal host. Keep the service role key server-side only.

## AI Food Detection Flow

1. User captures or uploads a food image.
2. App uploads it to the private `food-photos/{userId}/...` bucket path.
3. App invokes `ai-food-analysis`.
4. Edge Function calls OpenAI Vision and returns editable food items.
5. User adjusts portions/macros.
6. Confirmed items are inserted into `meals` and `meal_items`.
7. Corrections are stored in `ai_food_analyses.corrections` so future personalization can be trained or retrieved.

## Production Checklist

- Replace demo providers with Supabase queries and optimistic offline queue processing.
- Add complete auth guards in `GoRouter` after Supabase session restoration.
- Add native HealthKit, Google Fit, and widget targets.
- Add crash reporting, analytics, and rate limiting on Edge Functions.
- Add pagination and full-text ranking to food search UI.
- Add RevenueCat webhook ingestion for subscription status.
- Add App Store and Play Store privacy manifests.
- Add CI for Flutter analyze/test, Supabase migration checks, and Next.js lint/build.
