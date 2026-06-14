import 'package:flutter/material.dart';
import 'package:graduation_project/features/login_signup/login/presentation/view/login_page.dart';
import 'package:graduation_project/features/on%20board/presentation/view/widgets/custom_container_boarding.dart';
import 'package:graduation_project/features/on%20board/presentation/view/widgets/custom_emojy.dart';
import 'package:graduation_project/features/on%20board/presentation/view/widgets/on_board_pages.dart';

class OnBoardBody extends StatefulWidget {
  const OnBoardBody({super.key});

  @override
  State<OnBoardBody> createState() => _OnBoardBodyState();
}

class _OnBoardBodyState extends State<OnBoardBody> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(left: size.width * 0.05),
      child: Column(
        children: [
          SizedBox(height: size.height * 0.1),
          OnBoardPages(controller: pageController),
          const Spacer(),
          Row(
            children: [
              CustomEmojy(pageController: pageController),
              const Spacer(),
              CustomContainerBoarding(
                pageController: pageController,
                onTap: () {
                  (pageController.page ?? pageController.initialPage) == 1
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => LoginPage()),
                        )
                      : pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeIn,
                        );
                },
              ),
              SizedBox(width: size.width * 0.07),
            ],
          ),
          SizedBox(height: size.height * 0.08),
        ],
      ),
    );
  }
}