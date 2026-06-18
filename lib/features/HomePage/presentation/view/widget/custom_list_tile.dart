import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modish_store/core/colors.dart';
import 'package:modish_store/core/fontstyle.dart';

class CustomListtile extends StatelessWidget {
  const CustomListtile({
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
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 22.0),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              height: 22,
              colorFilter: ColorFilter.mode(
                  kPrimaryText(context), BlendMode.srcIn),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * .1),
            Text(text, style: t20.copyWith(color: kPrimaryText(context))),
          ],
        ),
      ),
    );
  }
}
