import 'package:flutter/material.dart';
import 'package:graduation_project/core/colors.dart';
import 'package:graduation_project/core/fontstyle.dart';

class CustomContainerBoarding extends StatelessWidget {
  const CustomContainerBoarding({
    super.key,
    this.onTap,
    required this.pageController,
  });

  final void Function()? onTap;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fontSize = size.shortestSide * 0.042;
    final horizontalPadding = size.width * 0.08;
    final verticalPadding = size.height * 0.018;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: kPrimaryColor,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Text(
              (pageController.page ?? pageController.initialPage) <= 0.5
                  ? "Next"
                  : "Get Start",
              style: t17.copyWith(
                color: kSecondColor,
                fontWeight: FontWeight.w700,
                fontSize: fontSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
