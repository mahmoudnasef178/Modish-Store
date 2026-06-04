import 'package:flutter/material.dart';
import 'package:graduation_project/core/colors.dart';
import 'package:graduation_project/core/fontstyle.dart';

class NewCollectionCard extends StatelessWidget {
  const NewCollectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      width: double.infinity,
      color: Color(0xffFFFFFF),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: MediaQuery.of(context).size.width * .08),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "NEW COLLECTION".toUpperCase(),
                style: t16.copyWith(color: secondaryColorText),
              ),
              SizedBox(height: 16),
              Text(
                "HANG OUT \n& PARTY",
                style: t22.copyWith(color: primaryColorText),
              ),
            ],
          ),

          Expanded(
            child: Stack(
              children: [
                Positioned(
                  right: 30,
                  child: Image.asset(
                    "assets/images/New_Collection_Card/Ellipse 251.png",
                    height: 170,
                  ),
                ),
                Positioned(
                  right: 44,
                  top: 12,
                  child: Image.asset(
                    "assets/images/New_Collection_Card/Ellipse 250.png",
                    height: 140,
                  ),
                ),
                Positioned(
                  right: 50,
                  child: Image.asset(
                    "assets/images/New_Collection_Card/image.png",
                    height: 190,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
