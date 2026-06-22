import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../model/counselling_state_model.dart';
import 'shared_widgets.dart';

class IntroSlider extends StatefulWidget {
  final List<IntroCardData> introCards;
  final bool isDark;
  final Color borderColor;

  const IntroSlider({
    super.key,
    required this.introCards,
    required this.isDark,
    required this.borderColor,
  });

  @override
  State<IntroSlider> createState() => _IntroSliderState();
}

class _IntroSliderState extends State<IntroSlider> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.introCards.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.introCards.length,
          itemBuilder: (context, index, realIndex) {
            final card = widget.introCards[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.isDark ? Colors.white.withOpacity(0.04) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: widget.borderColor),
                boxShadow: CounsellingUi.cardShadow(widget.isDark),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: card.iconColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(card.icon, color: card.iconColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 13.5,
                            color: widget.isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                            height: 1.4,
                            fontFamily: 'DM Sans',
                          ),
                          children: [
                            if (card.prefix.isNotEmpty)
                              TextSpan(text: card.prefix),
                            if (card.highlight.isNotEmpty)
                              TextSpan(
                                text: card.highlight,
                                style: TextStyle(
                                  color: card.highlightColor,
                                  fontWeight: card.isHighlightBold ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            if (card.suffix.isNotEmpty)
                              TextSpan(text: card.suffix),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          options: CarouselOptions(
            height: 100, // Adjust height based on content
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        AnimatedSmoothIndicator(
          activeIndex: _currentIndex,
          count: widget.introCards.length,
          effect: ExpandingDotsEffect(
            dotHeight: 6,
            dotWidth: 6,
            expansionFactor: 3,
            spacing: 6,
            activeDotColor: GixaColors.orange,
            dotColor: widget.isDark ? Colors.white24 : Colors.black12,
          ),
        ),
      ],
    );
  }
}
