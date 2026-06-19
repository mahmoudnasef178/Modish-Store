import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modish_store/core/colors.dart';
import 'package:modish_store/core/fontstyle.dart';
import 'package:modish_store/core/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductColor extends StatefulWidget {
  final String productId;
  const ProductColor({super.key, required this.productId});

  @override
  State<ProductColor> createState() => _ProductColorState();
}

class _ProductColorState extends State<ProductColor> {
  int selectIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadSelectedColor();
  }

  Future<void> _loadSelectedColor() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIndex = prefs.getInt('product_color_${widget.productId}');
    if (savedIndex != null && savedIndex < kProductColors.length) {
      if (mounted) {
        setState(() {
          selectIndex = savedIndex;
        });
      }
    } else {
      // By default, save index 0 if nothing is saved yet
      await prefs.setInt('product_color_${widget.productId}', 0);
    }
  }

  Future<void> _saveSelectedColor(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('product_color_${widget.productId}', index);
  }

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
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: kProductColors.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: customContainerColor(kProductColors[index], index),
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
        _saveSelectedColor(index);
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
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
