import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graduation_project/core/colors.dart';
import 'package:graduation_project/core/fontstyle.dart';
import 'package:graduation_project/core/theme/theme_cubit.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({
    super.key,
    required this.leftIcon,
    required this.title,
    required this.rightIcon,
    this.leftIconOnTap,
    this.rightIconOnTap,
    this.showIcon = true,
    this.showThemeToggle = false, // ✅ اختياري - مش كل الصفحات محتاجاه
  });

  final bool showIcon;
  final bool showThemeToggle;
  final String leftIcon;
  final String title;
  final String rightIcon;
  final void Function()? leftIconOnTap;
  final void Function()? rightIconOnTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * .08),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Icon
            GestureDetector(
              onTap: leftIconOnTap,
              child: SizedBox(
                height: 32,
                width: 32,
                child: Center(child: SvgPicture.asset(leftIcon, height: 20)),
              ),
            ),

            // Title
            Text(
              title,
              style: t22.copyWith(
                color: primaryColorText,
                fontWeight: FontWeight.w900,
              ),
            ),

            // Right side
            Row(
              children: [
                // ✅ زرار الـ dark mode
                if (showThemeToggle)
                  BlocBuilder<ThemeCubit, bool>(
                    builder: (context, isDark) {
                      return GestureDetector(
                        onTap: () => context.read<ThemeCubit>().toggleTheme(),
                        child: Container(
                          height: 32,
                          width: 36,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? const Color(0xff2A2A3E)
                                : const Color(0xffF0EAF0),
                          ),
                          child: Icon(
                            isDark ? Icons.light_mode : Icons.dark_mode,
                            size: 22,
                            color: kPrimaryColor,
                          ),
                        ),
                      );
                    },
                  ),

                // Right Icon
                if (showIcon)
                  GestureDetector(
                    onTap: rightIconOnTap,
                    child: SvgPicture.asset(rightIcon, height: 30),
                  )
                else
                  const SizedBox(width: 32),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
