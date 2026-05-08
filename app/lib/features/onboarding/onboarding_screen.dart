import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../shared/widgets/glass_card.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  final _steps = const [
    ('Welcome', 'Build a nutrition rhythm that fits real life.'),
    ('Gender', 'Personalize your calorie and macro estimates.'),
    ('Age', 'Tell us your age.'),
    ('Height', 'Set your height.'),
    ('Weight', 'Log your current and target weight.'),
    ('Goal', 'Lose fat, build muscle, or maintain.'),
    ('Activity', 'Choose your weekly movement level.'),
    ('Calories', 'Set or accept your daily calorie target.'),
    ('Protein', 'Pick a protein target.'),
    ('Water', 'Choose your hydration goal.'),
    ('Theme', 'Light, dark, or system.'),
    ('Notifications', 'Enable meal, water, and weight reminders.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(value: (_page + 1) / _steps.length),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (value) => setState(() => _page = value),
                itemCount: _steps.length,
                itemBuilder: (_, index) {
                  final step = _steps[index];
                  return Padding(
                    padding: const EdgeInsets.all(22),
                    child: Center(
                      child: GlassCard(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(step.$1, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
                            const SizedBox(height: 10),
                            Text(step.$2),
                            const SizedBox(height: 24),
                            TextField(decoration: InputDecoration(labelText: index < 2 ? 'Select option' : 'Your answer')),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: FilledButton(
                onPressed: () {
                  if (_page == _steps.length - 1) {
                    context.go('/');
                  } else {
                    _controller.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeOutCubic);
                  }
                },
                child: Text(_page == _steps.length - 1 ? 'Start tracking' : 'Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
