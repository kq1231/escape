import 'package:flutter/material.dart';
import '../atoms/tip_card.dart';

class TipsCarousel extends StatelessWidget {
  final List<TipItem> tips;
  final String title;

  const TipsCarousel({
    super.key,
    required this.tips,
    this.title = 'Helpful Tips',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 150,
          child: PageView.builder(
            itemCount: tips.length,
            itemBuilder: (context, index) {
              final tip = tips[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TipCard(
                  title: tip.title,
                  content: tip.content,
                  icon: tip.icon,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class TipItem {
  final String title;
  final String content;
  final IconData? icon;

  const TipItem({required this.title, required this.content, this.icon});
}
