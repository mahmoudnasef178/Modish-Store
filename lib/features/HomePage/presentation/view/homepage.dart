import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/Cart/presentation/view/cartPage.dart';
import 'package:graduation_project/features/HomePage/logic/Navigation_Cubit/navigation_cubit.dart';
import 'package:graduation_project/features/HomePage/logic/Navigation_Cubit/navigation_state.dart';
import 'package:graduation_project/features/HomePage/presentation/view/widget/customBottomNavigationBar.dart';
import 'package:graduation_project/features/HomePage/presentation/view/widget/custom_Drawer.dart';
import 'package:graduation_project/features/HomePage/presentation/view/widget/homePage_body.dart';
import 'package:graduation_project/features/profile/presentation/view/ProfileViewPage.dart';
import 'package:graduation_project/features/search/presentation/view/searchViewPage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late PageController _pageController;

  List<Widget> get _pages => [
        HomepageBody(globalKey: _scaffoldKey),
        const Searchviewpage(),
        const CartPage(),
        const Profileviewpage(),
      ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationCubit(),
      child: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_pageController.hasClients &&
                _pageController.page?.round() != state.currentIndex) {
              _pageController.animateToPage(
                state.currentIndex,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          });

          final width = MediaQuery.of(context).size.width;
          final isMobile = width < 600;
          final isDesktop = width >= 1024;

          final pageView = PageView(
            controller: _pageController,
            physics: const ClampingScrollPhysics(),
            onPageChanged: (index) {
              context.read<NavigationCubit>().changeIndex(index);
            },
            children: _pages,
          );

          if (isMobile) {
            // ── Mobile: Drawer + BottomNavigationBar ──────────────────
            return Scaffold(
              key: _scaffoldKey,
              drawer: const Drawer(child: CustomDrawer()),
              body: pageView,
              bottomNavigationBar: const Custombottomnavigationbar(),
            );
          }

          // ── Tablet / Desktop / Web: NavigationRail ────────────────
          return Scaffold(
            body: Row(
              children: [
                _NavRail(
                  currentIndex: state.currentIndex,
                  onTap: (i) =>
                      context.read<NavigationCubit>().changeIndex(i),
                  extended: isDesktop,
                ),
                const VerticalDivider(width: 1),
                Expanded(child: pageView),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Navigation Rail (Tablet + Desktop) ─────────────────────────────────────
class _NavRail extends StatelessWidget {
  const _NavRail({
    required this.currentIndex,
    required this.onTap,
    required this.extended,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool extended;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final railBg = isDark ? const Color(0xff1C1C2E) : const Color(0xffFAF8FB);
    final selectedColor = const Color(0xff9F8383);
    final unselectedColor = isDark ? Colors.white38 : Colors.grey;

    return NavigationRail(
      extended: extended,
      backgroundColor: railBg,
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      selectedIconTheme: IconThemeData(color: selectedColor, size: 26),
      unselectedIconTheme: IconThemeData(color: unselectedColor, size: 24),
      selectedLabelTextStyle: TextStyle(
        color: selectedColor,
        fontWeight: FontWeight.w700,
        fontSize: 13,
      ),
      unselectedLabelTextStyle: TextStyle(color: unselectedColor, fontSize: 12),
      leading: extended
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'Modish',
                style: TextStyle(
                  color: selectedColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            )
          : const SizedBox(height: 24),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.search_outlined),
          selectedIcon: Icon(Icons.search),
          label: Text('Search'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.shopping_cart_outlined),
          selectedIcon: Icon(Icons.shopping_cart),
          label: Text('Cart'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: Text('Profile'),
        ),
      ],
    );
  }
}
