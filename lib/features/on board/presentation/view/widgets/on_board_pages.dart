import 'package:flutter/material.dart';
import 'package:graduation_project/features/on%20board/presentation/view/widgets/custom_board.dart';

class OnBoardPages extends StatelessWidget {
  const OnBoardPages({super.key, required this.controller});
  final PageController controller;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.7,
      child: PageView(
        controller: controller,
        children: [
          CustomBoard(
            image: "assets/on board/Mask Group (1).png",
            title: "Follow The Latest Fashion Style",
            subTitle:
                "There Are Many Beautiful And Attractive Clothes Missed To Your Room",
          ),
          CustomBoard(
            image: "assets/on board/Mask Group (2).png",
            title: "Start Journey With Modish",
            subTitle: "Smart, Gorgeous & Fashionable Collection",
          ),
        ],
      ),
    );
  }
}