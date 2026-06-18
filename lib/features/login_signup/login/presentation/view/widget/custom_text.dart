import 'package:flutter/material.dart';
import 'package:modish_store/core/fontstyle.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text1,
    required this.text2,
    this.onTap,
  });
  final String text1;
  final String text2;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text1, style: t16.copyWith(color: Color(0xffAEAEAE))),
        SizedBox(width: 5),
        GestureDetector(
          onTap: onTap,
          child: Text(text2, style: t16.copyWith(color: Color(0xff574964))),
        ),
      ],
    );
  }
}
