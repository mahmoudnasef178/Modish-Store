import 'package:flutter/material.dart';
import 'package:graduation_project/core/colors.dart';
import 'package:graduation_project/core/fontstyle.dart';

class CustomFrame extends StatelessWidget {
  const CustomFrame({
    super.key,
    this.onTap,
    required this.text1,
    required this.text2,
  });
  final String text1;
  final String text2;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text1,
            style: t18.copyWith(
              color: kPrimaryText(context),
              fontWeight: FontWeight.w900,
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              text2,
              style: t16.copyWith(
                color: kSecondaryText(context),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
