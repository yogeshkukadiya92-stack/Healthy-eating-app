class MacroTarget {
  const MacroTarget({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.waterMl,
  });

  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final int waterMl;
}

class DailyNutrition {
  const DailyNutrition({
    required this.consumedCalories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.waterMl,
    required this.steps,
    required this.target,
  });

  final int consumedCalories;
  final int protein;
  final int carbs;
  final int fat;
  final int waterMl;
  final int steps;
  final MacroTarget target;

  int get remainingCalories => target.calories - consumedCalories;
  double get calorieProgress => consumedCalories / target.calories;
  double get proteinProgress => protein / target.protein;
  double get waterProgress => waterMl / target.waterMl;
}

class MealItem {
  const MealItem({
    required this.name,
    required this.imageUrl,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.time,
  });

  final String name;
  final String imageUrl;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final String time;
}

class AiFoodResult {
  const AiFoodResult({
    required this.foodName,
    required this.portion,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.confidence,
  });

  final String foodName;
  final String portion;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final double confidence;
}
