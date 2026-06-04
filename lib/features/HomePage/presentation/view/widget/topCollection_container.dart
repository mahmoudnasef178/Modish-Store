import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/core/colors.dart';
import 'package:graduation_project/core/fontstyle.dart';

class TopcollectionContainer extends StatelessWidget {
  const TopcollectionContainer({
    super.key,
    required this.title,
    required this.subTitle,
    required this.height,
    required this.image,
    required this.imagehight,
    required this.titleHeight,
    required this.subTitleHeight,
    required this.heightContainer,
    required this.widthContainer,
  });
  final String title, subTitle;
  final double height;
  final String image;
  final double imagehight;
  final double titleHeight;
  final double subTitleHeight;
  final double heightContainer;
  final double widthContainer;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xffE2E2E2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
          child: Row(
            children: [
              Gap(16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: t18.copyWith(
                      color: Color(0xff777E90),
                      fontSize: titleHeight,
                    ),
                  ),
                  Gap(22),
                  Text(
                    subTitle,
                    style: t20.copyWith(
                      color: primaryColorText,
                      fontSize: subTitleHeight,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ],
              ),
              Gap(16),
              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 30,
                      top: 40,
                      child: Container(
                        height: heightContainer,
                        width: widthContainer,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(64),
                          color: Colors.white54,
                        ),
                      ),
                    ),

                    Positioned(
                      left: 10,
                      right: 10,

                      child: SizedBox(
                        height: imagehight,

                        child: Image.asset(image, fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
