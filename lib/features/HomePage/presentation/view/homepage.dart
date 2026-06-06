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
          // Sync PageView when bottom nav index changes
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

          return Scaffold(
            key: _scaffoldKey,
            drawer: const Drawer(child: CustomDrawer()),
            body: PageView(
              controller: _pageController,
              physics: const ClampingScrollPhysics(),
              onPageChanged: (index) {
                // Sync bottom nav when user swipes
                context.read<NavigationCubit>().changeIndex(index);
              },
              children: _pages,
            ),
            bottomNavigationBar: const Custombottomnavigationbar(),
          );
        },
      ),
    );
  }
}
