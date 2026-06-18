import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modish_store/core/colors.dart';
import 'package:modish_store/core/fontstyle.dart';
import 'package:modish_store/core/utils.dart';

class ProductColor extends StatefulWidget {
  const ProductColor({super.key});

  @override
  State<ProductColor> createState() => _ProductColorState();
}

class _ProductColorState extends State<ProductColor> {
  List colors = [Colors.red, Colors.black, Colors.blue, Colors.brown.shade500];
  int selectIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("Color", style: t14.copyWith(color: kPrimaryText(context))),
        Spacer(),
        SizedBox(
          width: context.width * .5,
          height: 40,
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),

            scrollDirection: Axis.horizontal,
            itemCount: colors.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: customContainerColor(colors[index], index),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget customContainerColor(Color color, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectIndex = index;
        });
      },
      child: Container(
        width: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(64),
          color: color,
        ),
        child: Center(
          child: selectIndex == index
              ? SvgPicture.asset("assets/icons/Done.svg", height: 16)
              : SizedBox.shrink(),
        ),
      ),
    );
  }
}
