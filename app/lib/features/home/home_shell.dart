import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../shared/providers/demo_data_provider.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/progress_ring.dart';
import '../analytics/analytics_screen.dart';
import '../food/add_meal_screen.dart';
import '../profile/profile_screen.dart';
import '../progress/progress_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      const AnalyticsScreen(),
      const AddMealScreen(),
      const ProgressScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.auto_graph_rounded), label: 'Analytics'),
          NavigationDestination(icon: Icon(Icons.add_circle_rounded), label: 'Add'),
          NavigationDestination(icon: Icon(Icons.monitor_weight_rounded), label: 'Progress'),
          NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(dailyNutritionProvider);
    final meals = ref.watch(mealTimelineProvider);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 110),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good morning, Yogesh', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
                      Text('Friday, May 8 • 12 day streak'),
                    ],
                  ),
                ),
                const CircleAvatar(radius: 24, child: Icon(Icons.person_rounded)),
              ],
            ),
            const SizedBox(height: 18),
            GlassCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ProgressRing(progress: day.calorieProgress, label: 'Calories', value: '${day.remainingCalories}', color: colors.primary),
                      ProgressRing(progress: day.proteinProgress, label: 'Protein', value: '${day.protein}g', color: colors.secondary),
                      ProgressRing(progress: day.waterProgress, label: 'Water', value: '${(day.waterMl / 1000).toStringAsFixed(1)}L', color: Colors.blueAccent),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _MetricRow(items: {
                    'Carbs': '${day.carbs}/${day.target.carbs}g',
                    'Fat': '${day.fat}/${day.target.fat}g',
                    'Steps': '${day.steps}',
                  }),
                ],
              ),
            ).animate().fadeIn().slideY(begin: .08, end: 0),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _Action(icon: Icons.restaurant_rounded, label: 'Add Meal', onTap: () => context.push('/add-meal')),
                _Action(icon: Icons.qr_code_scanner_rounded, label: 'Scan Food', onTap: () => context.push('/ai-scanner')),
                _Action(icon: Icons.water_drop_rounded, label: 'Add Water', onTap: () {}),
                _Action(icon: Icons.monitor_weight_rounded, label: 'Add Weight', onTap: () {}),
                _Action(icon: Icons.auto_awesome_rounded, label: 'AI Suggestion', onTap: () {}),
              ],
            ),
            const SizedBox(height: 22),
            Text('Meal timeline', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            for (final meal in meals) ...[
              GlassCard(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.network(meal.imageUrl, width: 72, height: 72, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(meal.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                          Text('${meal.calories} kcal • P ${meal.protein}g C ${meal.carbs}g F ${meal.fat}g'),
                          Text(meal.time, style: Theme.of(context).textTheme.labelMedium),
                        ],
                      ),
                    ),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.edit_rounded)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.delete_outline_rounded)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.items});

  final Map<String, String> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items.entries.map((entry) {
        return Expanded(
          child: Column(
            children: [
              Text(entry.value, style: const TextStyle(fontWeight: FontWeight.w800)),
              Text(entry.key, style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 116,
      child: GlassCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Column(
          children: [
            Icon(icon),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}
