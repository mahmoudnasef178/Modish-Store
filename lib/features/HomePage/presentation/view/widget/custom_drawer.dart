import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modish_store/core/colors.dart';
import 'package:modish_store/features/HomePage/presentation/view/notification/notification_view.dart';
import 'package:modish_store/features/HomePage/presentation/view/widget/custom_list_tile.dart';
import 'package:modish_store/features/login_signup/login/logic/login/login_cubit.dart';
import 'package:modish_store/features/profile/about_us/about_us.dart';
import 'package:modish_store/features/profile/presentation/view/Favorite/favorite_page.dart';
import 'package:modish_store/features/profile/presentation/view/Support/email_chooser_sheet.dart';
import 'package:modish_store/features/HomePage/presentation/view/category/category_page.dart';
import 'package:modish_store/features/profile/presentation/view/profile_screen.dart';
import 'package:modish_store/features/splash/presentation/view/splash_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String _email = '';
  String _displayName = '';
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    final rawName = prefs.getString('displayName') ?? '';
    final email = prefs.getString('email') ?? '';

    // Avoid showing the email as the display name
    String resolvedName;
    if (rawName.isNotEmpty && !rawName.contains('@')) {
      resolvedName = rawName;
    } else if (email.contains('@')) {
      resolvedName = email.split('@')[0];
    } else {
      resolvedName = rawName;
    }

    final base64Image = prefs.getString('profile_image_base64');
    Uint8List? bytes;
    if (base64Image != null) {
      try {
        bytes = base64Decode(base64Image);
      } catch (_) {}
    } else {
      final savedImagePath = prefs.getString('profile_image_path') ?? '';
      if (savedImagePath.isNotEmpty && !kIsWeb) {
        try {
          final file = File(savedImagePath);
          if (file.existsSync()) {
            bytes = file.readAsBytesSync();
          }
        } catch (_) {}
      }
    }

    setState(() {
      _email = email;
      _displayName = resolvedName;
      _imageBytes = bytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xff1e1e1e) : Colors.white;

    return Drawer(
      backgroundColor: bgColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                    _loadUserData();
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 34,
                        backgroundColor: const Color(0xff9F8383),
                        backgroundImage: _imageBytes != null
                            ? MemoryImage(_imageBytes!)
                            : null,
                        child: _imageBytes == null
                            ? const Icon(
                                Icons.person,
                                size: 34,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(
                            _displayName.isNotEmpty
                                ? _displayName
                                : _email.split('@')[0],
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: kPrimaryText(context),
                            ),
                          ),
                          subtitle: Text(
                            _email,
                            style: TextStyle(color: kSecondaryText(context)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                CustomListtile(
                  icon: "assets/icons/drawer_icon/Profile.svg",
                  text: "Profile",
                  onTap: () async {
                    Navigator.pop(context);
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                    _loadUserData();
                  },
                ),
                const SizedBox(height: 24),
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
                const SizedBox(height: 24),
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
                const SizedBox(height: 24),
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
                const SizedBox(height: 24),
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
                const SizedBox(height: 24),
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
                const SizedBox(height: 24),
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
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
