import 'package:flutter/material.dart';
import '../atoms/tip_card.dart';
import 'package:escape/theme/app_theme.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TipsCarousel extends StatefulWidget {
  final List<TipItem> tips;
  final String title;

  const TipsCarousel({
    super.key,
    required this.tips,
    this.title = 'Coping Strategies',
  });

  @override
  State<TipsCarousel> createState() => _TipsCarouselState();
}

class _TipsCarouselState extends State<TipsCarousel> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 16),
        CarouselSlider.builder(
          itemCount: widget.tips.length,
          options: CarouselOptions(
            height: 200, // Fixed height that should accommodate most content
            aspectRatio: 16 / 9,
            viewportFraction: 0.85,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            final tip = widget.tips[index];
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
        const SizedBox(height: 16),
        // Indicator dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.tips.map((tip) {
            final index = widget.tips.indexOf(tip);
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index
                    ? AppTheme.primaryGreen
                    : AppTheme.accentGreen,
              ),
            );
          }).toList(),
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
