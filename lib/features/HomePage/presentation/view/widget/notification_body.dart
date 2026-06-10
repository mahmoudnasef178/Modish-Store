import 'package:flutter/material.dart';
import 'package:graduation_project/core/colors.dart';
import 'package:graduation_project/core/fontstyle.dart';
import 'package:graduation_project/features/HomePage/presentation/view/widget/custom_AppBar.dart';

class NotificationBody extends StatelessWidget {
  const NotificationBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: CustomAppbar(
            leftIcon: "assets/icons/Arrow.svg",
            title: "Notification",
            rightIcon: "",
            showIcon: false,
            leftIconOnTap: () {
              Navigator.pop(context);
            },
          ),
        ),

        SizedBox(height: MediaQuery.of(context).size.height * .2),
        Image.asset("assets/images/illustration  & text.png", height: 280),
        SizedBox(height: 32),
        Text(
          "NO NOTIFICATIONS",
          style: t18.copyWith(
            color: kPrimaryText(context),
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
