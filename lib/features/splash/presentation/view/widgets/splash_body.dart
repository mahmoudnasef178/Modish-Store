import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:modish_store/features/HomePage/presentation/view/home/homepage.dart';
import 'package:modish_store/features/login_signup/login/logic/login/login_cubit.dart';
import 'package:modish_store/features/on_board/presentation/view/on_board_view.dart';

class SplashBody extends StatefulWidget {
  const SplashBody({super.key});

  @override
  State<SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    Future.delayed(const Duration(seconds: 4), () async {
      final isLoggedIn = await LoginCubit.isLoggedIn();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => isLoggedIn ? const Homepage() : OnBoardView(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // ✅ بيحسب حجم الصورة بناءً على أصغر بعد عشان يشتغل على كل الشاشات
    final imageSize = size.shortestSide * 0.45;

    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * math.pi,
            child: child,
          );
        },
        child: Image.asset(
          "assets/icons/sobhan-joodi-ZgOwzl9YQJU-unsplash (1)_prev_ui 2.png",
          width: imageSize,
          height: imageSize,
        ),
      ),
    );
  }
}
