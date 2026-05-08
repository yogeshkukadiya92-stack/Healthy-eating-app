import 'package:flutter/material.dart';

import '../../shared/models/nutrition_models.dart';
import '../../shared/widgets/glass_card.dart';

class AiScannerScreen extends StatelessWidget {
  const AiScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final results = const [
      AiFoodResult(foodName: 'Gujarati dal', portion: '1 bowl', calories: 180, protein: 8, carbs: 26, fat: 5, confidence: .91),
      AiFoodResult(foodName: 'Rotli', portion: '2 pieces', calories: 210, protein: 6, carbs: 42, fat: 3, confidence: .87),
      AiFoodResult(foodName: 'Paneer sabzi', portion: '150 g', calories: 330, protein: 22, carbs: 14, fat: 21, confidence: .84),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('AI food scan')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
        children: [
          AspectRatio(
            aspectRatio: 3 / 4,
            child: GlassCard(
              padding: EdgeInsets.zero,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: Colors.black87),
                  const Center(child: Icon(Icons.camera_alt_rounded, color: Colors.white, size: 62)),
                  Positioned.fill(
                    child: CustomPaint(painter: _ScannerOverlayPainter()),
                  ),
                  const Positioned(
                    left: 18,
                    right: 18,
                    bottom: 18,
                    child: LinearProgressIndicator(value: .72),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text('Detected foods', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          for (final item in results) ...[
            GlassCard(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.foodName, style: const TextStyle(fontWeight: FontWeight.w800)),
                        Text('${item.portion} • ${item.calories} kcal • P ${item.protein}g C ${item.carbs}g F ${item.fat}g'),
                        Text('Confidence ${(item.confidence * 100).round()}%'),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.tune_rounded)),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
          FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.check_rounded), label: const Text('Add to daily log')),
        ],
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF42D7A5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(44, 88, size.width - 88, 110), const Radius.circular(18)), paint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(72, 250, size.width - 144, 92), const Radius.circular(18)), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
