import 'package:flutter/material.dart';
import 'package:graduation_project/core/colors.dart';

class CustomEmojy extends StatelessWidget {
  const CustomEmojy({super.key, required this.pageController});
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dotHeight = size.shortestSide * 0.012;
    final dotLarge = size.width * 0.1;
    final dotSmall = size.width * 0.025;
    final spacing = size.width * 0.03;

    final currentPage =
        pageController.page ?? pageController.initialPage.toDouble();
    final isFirst = currentPage <= 0.8;

    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: dotHeight,
          width: isFirst ? dotLarge : dotSmall,
          decoration: BoxDecoration(
            color: isFirst ? kPrimaryColor : const Color(0xffFFDAB3),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        SizedBox(width: spacing),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: dotHeight,
          width: isFirst ? dotSmall : dotLarge,
          decoration: BoxDecoration(
            color: isFirst ? const Color(0xffFFDAB3) : kPrimaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}
