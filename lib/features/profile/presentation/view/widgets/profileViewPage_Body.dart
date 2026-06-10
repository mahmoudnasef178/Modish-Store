import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graduation_project/core/colors.dart';
import 'package:graduation_project/core/fontstyle.dart';
import 'package:graduation_project/features/HomePage/logic/Navigation_Cubit/navigation_cubit.dart';
import 'package:graduation_project/features/HomePage/presentation/view/notification_View.dart';
import 'package:graduation_project/features/login_signup/login/logic/login/login_cubit.dart';
import 'package:graduation_project/features/profile/about%20us/about_us.dart';
import 'package:graduation_project/features/profile/presentation/view/Favorite/favorite_Page.dart';
import 'package:graduation_project/features/profile/presentation/view/Support/email_chooser_sheet.dart';
import 'package:graduation_project/features/profile/presentation/view/category/category_Page.dart';
import 'package:graduation_project/features/profile/presentation/view/profile_Screen.dart';
import 'package:graduation_project/features/splash/presentation/view/splash_view.dart';
import 'package:graduation_project/features/profile/logic/profile/profile_cubit.dart';
import 'package:graduation_project/features/profile/logic/profile/profile_state.dart';

class ProfileviewpageBody extends StatelessWidget {
  const ProfileviewpageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide > 600;
    final horizontalPadding = size.width * (isTablet ? 0.08 : 0.05);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.read<NavigationCubit>().changeIndex(0),
          child: const Icon(Icons.arrow_back_ios_new, color: primaryColorText),
        ),
        title: Text(
          "Profile Settings",
          style: t18.copyWith(color: primaryColorText, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final cubit = context.read<ProfileCubit>();
          final user = cubit.currentUser;
          final imageFile = cubit.pickedImage != null ? File(cubit.pickedImage!.path) : null;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Header User Profile Card ─────────────────────────
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    ).then((_) => cubit.loadUser());
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xff9F8383), Color(0xff574964)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff574964).withValues(alpha: 0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 36,
                                backgroundColor: Colors.white24,
                                backgroundImage: imageFile != null ? FileImage(imageFile) : null,
                                child: imageFile == null
                                    ? const Icon(Icons.person, size: 36, color: Colors.white)
                                    : null,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 11,
                                  color: Color(0xff574964),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.displayName ?? "Loading...",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user?.email ?? "Tap to setup your profile",
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.75),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // ─── Group 1: Account Settings ────────────────────────
                _buildSectionTitle("Account Settings"),
                const SizedBox(height: 12),
                _buildCardGroup(
                  context,
                  items: [
                    _ProfileOptionData(
                      icon: "assets/icons/drawer_icon/Profile.svg",
                      title: "Edit Profile Info",
                      color: const Color(0xffF2EDE7),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProfileScreen()),
                        ).then((_) => cubit.loadUser());
                      },
                    ),
                    _ProfileOptionData(
                      icon: "assets/icons/drawer_icon/Notifications.svg",
                      title: "Notification",
                      color: const Color(0xffFFF3E0),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const NotificationView()),
                      ),
                    ),
                    _ProfileOptionData(
                      icon: "assets/icons/drawer_icon/Path.svg",
                      title: "My Favorites",
                      color: const Color(0xffFFEBEE),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FavoriteViewPage()),
                      ),
                    ),
                    _ProfileOptionData(
                      icon: "assets/icons/drawer_icon/category.svg",
                      title: "Explore Categories",
                      color: const Color(0xffE8EAF6),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CategorySection()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ─── Group 2: Support & App ───────────────────────────
                _buildSectionTitle("Support & About"),
                const SizedBox(height: 12),
                _buildCardGroup(
                  context,
                  items: [
                    _ProfileOptionData(
                      icon: "assets/icons/drawer_icon/support.svg",
                      title: "Customer Support",
                      color: const Color(0xffE0F2F1),
                      onTap: () => showModalBottomSheet(
                        context: context,
                        backgroundColor: const Color(0xFF2A2A2A),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (_) => const EmailChooserSheet(),
                      ),
                    ),
                    _ProfileOptionData(
                      icon: "assets/icons/drawer_icon/About_us.svg",
                      title: "About Us",
                      color: const Color(0xffF3E5F5),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AboutUsPage()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // ─── Logout Button ────────────────────────────────────
                _buildLogoutButton(context),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: primaryColorText,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildCardGroup(BuildContext context, {required List<_ProfileOptionData> items}) {
    final cardColor = Theme.of(context).brightness == Brightness.dark
        ? cardColorDark
        : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          thickness: 0.8,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white10
              : Colors.grey.shade100,
          indent: 64,
          endIndent: 16,
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildOptionItem(context, item);
        },
      ),
    );
  }

  Widget _buildOptionItem(BuildContext context, _ProfileOptionData item) {
    final textColor = kPrimaryText(context);

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(9),
              child: SvgPicture.asset(
                item.icon,
                colorFilter: const ColorFilter.mode(
                  Color(0xff574964),
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              item.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final cardColor = Theme.of(context).brightness == Brightness.dark
        ? cardColorDark
        : Colors.white;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Logout',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              content: const Text(
                'Are you sure you want to logout?',
                style: TextStyle(fontSize: 14),
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
            if (context.mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => SplashView()),
                (route) => false,
              );
            }
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(9),
                child: SvgPicture.asset(
                  "assets/icons/logout-svgrepo-com.svg",
                  colorFilter: const ColorFilter.mode(
                    Colors.red,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                "Logout",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.red,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: Colors.red.shade200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileOptionData {
  final String icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  _ProfileOptionData({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });
}
