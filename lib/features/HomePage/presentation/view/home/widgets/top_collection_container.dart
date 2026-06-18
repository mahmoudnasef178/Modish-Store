import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:modish_store/core/colors.dart';
import 'package:modish_store/core/fontstyle.dart';

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
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xff2A2A3E)
              : const Color(0xffE2E2E2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: t18.copyWith(
                        color: const Color(0xff777E90),
                        fontSize: titleHeight,
                      ),
                    ),
                    const Gap(22),
                    Text(
                      subTitle,
                      style: t20.copyWith(
                        color: kPrimaryText(context),
                        fontSize: subTitleHeight,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(16),
              Expanded(
                flex: 4,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Positioned(
                        right: -widthContainer / 22,
                        bottom: (height - heightContainer) / 2,
                        child: Container(
                          height: heightContainer,
                          width: widthContainer,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white.withValues(alpha: 0.1)
                                : Colors.white54,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: -40,
                        child: Image.asset(
                          image,
                          height: height,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
