import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/core/colors.dart';
import 'package:graduation_project/core/fontstyle.dart';
import 'package:graduation_project/features/HomePage/logic/Navigation_Cubit/navigation_cubit.dart';
import 'package:graduation_project/features/HomePage/presentation/view/notification_View.dart';
import 'package:graduation_project/features/HomePage/presentation/view/widget/custom_AppBar.dart';
import 'package:graduation_project/features/login_signup/login/logic/login/login_cubit.dart';
import 'package:graduation_project/features/profile/about%20us/about_us.dart';
import 'package:graduation_project/features/profile/presentation/view/Favorite/favorite_Page.dart';
import 'package:graduation_project/features/profile/presentation/view/Support/email_chooser_sheet.dart';
import 'package:graduation_project/features/profile/presentation/view/category/category_Page.dart';
import 'package:graduation_project/features/profile/presentation/view/profile_Screen.dart';
import 'package:graduation_project/features/profile/presentation/view/widgets/custom_Container_ProfilePage.dart';
import 'package:graduation_project/features/profile/presentation/view/widgets/custom_Linear.dart';
import 'package:graduation_project/features/splash/presentation/view/splash_view.dart';

class ProfileviewpageBody extends StatelessWidget {
  const ProfileviewpageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalPadding = size.width * 0.06;
    final itemSpacing = size.height * 0.02;
    final titleFontSize = size.shortestSide * 0.045;

    return SingleChildScrollView(
      // ✅ عشان لو الشاشة صغيرة محتش overflow
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: size.width * 0.02),
            child: CustomAppbar(
              leftIcon: "assets/icons/Arrow.svg",
              title: "Profile",
              rightIcon: "",
              showIcon: false,
              leftIconOnTap: () =>
                  context.read<NavigationCubit>().changeIndex(0),
            ),
          ),

          Gap(size.height * 0.04),
          Text(
            "Account Settings",
            style: t18.copyWith(
              color: primaryColorText,
              fontSize: titleFontSize,
            ),
          ),
          Gap(size.height * 0.03),

          _buildItem(
            context,
            icon: "assets/icons/drawer_icon/Profile.svg",
            text: "Profile",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfileScreen()),
            ),
            spacing: itemSpacing,
          ),

          _buildItem(
            context,
            icon: "assets/icons/drawer_icon/Notifications.svg",
            text: "Notification",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => NotificationView()),
            ),
            spacing: itemSpacing,
          ),

          _buildItem(
            context,
            icon: "assets/icons/drawer_icon/Path.svg",
            text: "Favorite",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FavoriteViewPage()),
            ),
            spacing: itemSpacing,
          ),

          _buildItem(
            context,
            icon: "assets/icons/drawer_icon/category.svg",
            text: "Category",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CategorySection()),
            ),
            spacing: itemSpacing,
          ),

          _buildItem(
            context,
            icon: "assets/icons/drawer_icon/support.svg",
            text: "Support",
            onTap: () => showModalBottomSheet(
              context: context,
              backgroundColor: const Color(0xFF2A2A2A),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => const EmailChooserSheet(),
            ),
            spacing: itemSpacing,
          ),

          _buildItem(
            context,
            icon: "assets/icons/drawer_icon/About_us.svg",
            text: "About Us",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutUsPage()),
            ),
            spacing: itemSpacing,
          ),

          _buildItem(
            context,
            icon: "assets/icons/logout-svgrepo-com.svg",
            text: "Logout",
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: titleFontSize,
                    ),
                  ),
                  content: Text(
                    'Are you sure you want to logout?',
                    style: TextStyle(fontSize: titleFontSize * 0.8),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await LoginCubit.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => SplashView()),
                  (route) => false,
                );
              }
            },
            spacing: itemSpacing,
            isLast: true, // ✅ آخر عنصر مش هيحط divider
          ),

          SizedBox(height: size.height * 0.03),
        ],
      ),
    );
  }

  // ✅ helper method عشان منكررش الكود
  Widget _buildItem(
    BuildContext context, {
    required String icon,
    required String text,
    required VoidCallback onTap,
    required double spacing,
    bool isLast = false,
  }) {
    return Column(
      children: [
        CustomContainerProfilepage(icon: icon, text: text, onTap: onTap),
        SizedBox(height: spacing),
        if (!isLast) ...[const CustomLinear(), SizedBox(height: spacing)],
      ],
    );
  }
}
