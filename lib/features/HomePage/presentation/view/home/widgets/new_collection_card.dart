import 'package:flutter/material.dart';
import 'package:modish_store/core/colors.dart';
import 'package:modish_store/core/fontstyle.dart';

class NewCollectionCard extends StatelessWidget {
  const NewCollectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      width: double.infinity,
      color: kCardColor(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: MediaQuery.of(context).size.width * .08),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "NEW COLLECTION".toUpperCase(),
                style: t16.copyWith(color: kSecondaryText(context)),
              ),

              Text(
                "HANG OUT \n& PARTY",
                style: t22.copyWith(color: kPrimaryText(context)),
              ),
            ],
          ),
          SizedBox(width: 16),

          Expanded(
            child: Stack(
              children: [
                Positioned(
                  right: 5,
                  child: Image.asset(
                    "assets/images/New_Collection_Card/Ellipse 251.png",
                    height: 170,
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 12,
                  child: Image.asset(
                    "assets/images/New_Collection_Card/Ellipse 250.png",
                    height: 140,
                  ),
                ),
                Positioned(
                  right: 15,
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
