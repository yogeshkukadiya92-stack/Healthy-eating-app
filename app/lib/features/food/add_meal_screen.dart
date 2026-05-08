import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../shared/widgets/glass_card.dart';

class AddMealScreen extends StatelessWidget {
  const AddMealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final foods = ['Paneer tikka', 'Dal rice', 'Oats whey bowl', 'Thepla curd', 'Grilled chicken'];

    return Scaffold(
      appBar: AppBar(title: const Text('Add meal')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/ai-scanner'),
        icon: const Icon(Icons.camera_alt_rounded),
        label: const Text('AI scan'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 110),
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search food, barcode, or voice',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: IconButton(onPressed: () {}, icon: const Icon(Icons.mic_rounded)),
            ),
          ),
          const SizedBox(height: 16),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'recent', label: Text('Recent')),
              ButtonSegment(value: 'favorite', label: Text('Favorites')),
              ButtonSegment(value: 'custom', label: Text('Custom')),
            ],
            selected: const {'recent'},
            onSelectionChanged: (_) {},
          ),
          const SizedBox(height: 16),
          for (final food in foods) ...[
            GlassCard(
              child: Row(
                children: [
                  const CircleAvatar(child: Icon(Icons.restaurant_rounded)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(food, style: const TextStyle(fontWeight: FontWeight.w800)),
                        const Text('320 kcal • P 24g C 36g F 9g'),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.add_circle_rounded)),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 16),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Portion selector', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                const TextField(decoration: InputDecoration(labelText: 'Grams')),
                const SizedBox(height: 10),
                const TextField(decoration: InputDecoration(labelText: 'Serving size')),
                const SizedBox(height: 12),
                FilledButton(onPressed: () {}, child: const Text('Save meal')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
