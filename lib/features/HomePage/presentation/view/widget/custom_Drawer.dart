import 'package:flutter/material.dart';
import 'package:graduation_project/core/colors.dart';
import 'package:graduation_project/features/HomePage/presentation/view/notification_View.dart';
import 'package:graduation_project/features/HomePage/presentation/view/widget/custom_ListTile.dart';
import 'package:graduation_project/features/login_signup/login/logic/login/login_cubit.dart';
import 'package:graduation_project/features/profile/about%20us/about_us.dart';
import 'package:graduation_project/features/profile/presentation/view/Favorite/favorite_Page.dart';
import 'package:graduation_project/features/profile/presentation/view/Support/email_chooser_sheet.dart';
import 'package:graduation_project/features/profile/presentation/view/category/category_Page.dart';
import 'package:graduation_project/features/profile/presentation/view/profile_Screen.dart';
import 'package:graduation_project/features/splash/presentation/view/splash_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String _email = '';
  String _displayName = '';
  String _imagePath = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('email') ?? '';
      _displayName = prefs.getString('displayName') ?? '';
      _imagePath = prefs.getString('profile_image_path') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .5,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * .1),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(62),
                    child: _imagePath.isNotEmpty
                        ? Image.file(
                            File(_imagePath),
                            height: 68,
                            width: 68,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            "assets/images/My_Image.png",
                            height: 68,
                            width: 68,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        _displayName.isNotEmpty
                            ? _displayName
                            : _email.split('@')[0],
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: primaryColorText,
                        ),
                      ),
                      subtitle: Text(
                        _email,
                        style: TextStyle(color: secondaryColorText),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 86),
            CustomListtile(
              icon: "assets/icons/drawer_icon/Profile.svg",
              text: "Profile",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
            ),
            SizedBox(height: 32),
            CustomListtile(
              icon: "assets/icons/drawer_icon/Notifications.svg",
              text: "Notification",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationView()),
                );
              },
            ),
            SizedBox(height: 32),
            CustomListtile(
              icon: "assets/icons/drawer_icon/Path.svg",
              text: "Favorite",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoriteViewPage()),
                );
              },
            ),
            SizedBox(height: 32),
            CustomListtile(
              icon: "assets/icons/drawer_icon/category.svg",
              text: "Category",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CategorySection()),
                );
              },
            ),
            SizedBox(height: 32),
            CustomListtile(
              icon: "assets/icons/drawer_icon/support.svg",
              text: "Support",
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  backgroundColor: const Color(0xFF2A2A2A),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) => const EmailChooserSheet(),
                );
              },
            ),
            SizedBox(height: 32),
            CustomListtile(
              icon: "assets/icons/drawer_icon/About_us.svg",
              text: "About Us",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutUsPage()),
                );
              },
            ),
            SizedBox(height: 32),
            CustomListtile(
              icon: "assets/icons/logout-svgrepo-com.svg",
              text: "Logout",
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: const Text(
                      'Logout',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    content: const Text('Are you sure you want to logout?'),
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
            ),
          ],
        ),
      ),
    );
  }
}
