import 'package:flutter/material.dart';
import 'package:graduation_project/core/colors.dart';

class Customsearchtextfield extends StatelessWidget {
  const Customsearchtextfield({
    super.key,
    required this.hintText,
    this.controller,
  });

  final String hintText;
  final TextEditingController? controller;

  OutlineInputBorder _border() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(32),
    borderSide: const BorderSide(color: Colors.transparent, width: 1),
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // ✅ حجم الفونت يتكيف مع الشاشة
    final fontSize = size.shortestSide * 0.035;
    // ✅ حجم الأيقونة يتكيف مع الشاشة
    final iconSize = size.shortestSide * 0.06;

    return TextField(
      controller: controller,
      style: TextStyle(fontSize: fontSize),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search, size: iconSize),
        prefixIconColor: secondaryColorText,
        hintStyle: TextStyle(color: Colors.grey, fontSize: fontSize),
        hintText: hintText,
        filled: true,
        fillColor: Theme.of(context).cardColor, // ✅ بيتغير مع الدارك مود
        border: _border(),
        enabledBorder: _border(),
        focusedBorder: _border(),
        disabledBorder: _border(),
        errorBorder: _border(),
        focusedErrorBorder: _border(),
        // ✅ الـ padding يتكيف مع حجم الشاشة
        contentPadding: EdgeInsets.symmetric(
          vertical: size.height * 0.018,
          horizontal: size.width * 0.04,
        ),
      ),
    );
  }
}
