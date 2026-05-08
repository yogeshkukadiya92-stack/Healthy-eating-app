# API Surface

## Supabase Tables

- `profiles`: user profile, goals, diet type, theme, activity.
- `foods`: searchable nutrition database.
- `meals`: per-user meal headers.
- `meal_items`: foods inside meals.
- `water_logs`: hydration logs.
- `weight_logs`: weight, body fat, and muscle mass.
- `notifications`: reminders and message history.
- `subscriptions`: RevenueCat-backed premium state.
- `ai_food_analyses`: AI results, confidence, and user corrections.
- `export_jobs`: PDF, Excel, and CSV export jobs.

## Edge Functions

### `ai-food-analysis`

Input:

```json
{
  "userId": "uuid",
  "imageUrl": "https://...",
  "cuisineHints": ["Gujarati", "Indian"]
}
```

Output:

```json
{
  "detectedItems": [
    {
      "foodName": "Paneer sabzi",
      "portion": "150 g",
      "calories": 330,
      "protein": 22,
      "carbs": 14,
      "fat": 21,
      "fiber": 3,
      "confidence": 0.84
    }
  ]
}
```

### `nutrition-coach`

Input: `profile`, `day`, `question`.

Output: short coaching message suitable for in-app chat.

### `daily-summary`

Input: `userId`.

Output: daily calorie and macro totals.
