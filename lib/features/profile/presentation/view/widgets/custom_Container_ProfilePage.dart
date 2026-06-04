import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graduation_project/core/colors.dart';
import 'package:graduation_project/core/fontstyle.dart';

class CustomContainerProfilepage extends StatelessWidget {
  const CustomContainerProfilepage({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
  });

  final String icon;
  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final iconSize = size.shortestSide * 0.065;
    final fontSize = size.shortestSide * 0.048;
    final arrowSize = size.shortestSide * 0.03;

    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(icon, height: iconSize, color: Colors.grey.shade700),
          SizedBox(width: size.width * 0.05),
          Text(
            text,
            style: t20.copyWith(color: primaryColorText, fontSize: fontSize),
          ),
          const Spacer(),
          SvgPicture.asset("assets/icons/Vector 175.svg", height: arrowSize),
        ],
      ),
    );
  }
}
