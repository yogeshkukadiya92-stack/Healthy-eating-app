import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/nutrition_models.dart';

final dailyNutritionProvider = Provider<DailyNutrition>((ref) {
  return const DailyNutrition(
    consumedCalories: 1420,
    protein: 96,
    carbs: 154,
    fat: 42,
    waterMl: 1800,
    steps: 7420,
    target: MacroTarget(
      calories: 2100,
      protein: 140,
      carbs: 230,
      fat: 70,
      waterMl: 3000,
    ),
  );
});

final mealTimelineProvider = Provider<List<MealItem>>((ref) {
  return const [
    MealItem(
      name: 'Paneer bhurji bowl',
      imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
      calories: 430,
      protein: 32,
      carbs: 38,
      fat: 16,
      time: '8:20 AM',
    ),
    MealItem(
      name: 'Gujarati thali',
      imageUrl: 'https://images.unsplash.com/photo-1585937421612-70a008356fbe',
      calories: 690,
      protein: 28,
      carbs: 94,
      fat: 22,
      time: '1:10 PM',
    ),
    MealItem(
      name: 'Protein smoothie',
      imageUrl: 'https://images.unsplash.com/photo-1553530666-ba11a7da3888',
      calories: 300,
      protein: 36,
      carbs: 22,
      fat: 4,
      time: '5:45 PM',
    ),
  ];
});
