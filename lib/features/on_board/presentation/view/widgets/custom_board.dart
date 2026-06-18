import 'package:flutter/material.dart';
import 'package:modish_store/core/fontstyle.dart';

class CustomBoard extends StatelessWidget {
  const CustomBoard({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  final String image;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final titleFontSize = size.shortestSide * 0.09;
    final subFontSize = size.shortestSide * 0.048;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(right: size.width * 0.08),
          child: SizedBox(
            width: size.width,
            height: size.height * 0.4, // ✅ ارتفاع ثابت نسبي
            child: Image.asset(image, fit: BoxFit.contain),
          ),
        ),
        SizedBox(height: size.height * 0.06),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: titleFontSize,
              color: const Color(0xff574964),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        SizedBox(height: size.height * 0.025),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: Text(
            subTitle,
            textAlign: TextAlign.center,
            style: t20.copyWith(
              color: const Color(0xffAEAEAE),
              fontSize: subFontSize,
            ),
          ),
        ),
      ],
    );
  }
}
