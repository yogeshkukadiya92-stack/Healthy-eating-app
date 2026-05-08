import 'package:flutter/material.dart';

import '../../shared/widgets/glass_card.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 110),
        children: [
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Weight trend', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                Text('76.4 kg', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900)),
                const Text('Weekly average • BMI 23.8 • Goal ETA 9 weeks'),
              ],
            ),
          ),
          const SizedBox(height: 14),
          GlassCard(
            child: Column(
              children: [
                _Row(label: 'Body fat', value: '18.2%'),
                _Row(label: 'Muscle mass', value: '34.1 kg'),
                _Row(label: 'Hydration streak', value: '8 days'),
                _Row(label: 'XP points', value: '4,850'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
    );
  }
}
