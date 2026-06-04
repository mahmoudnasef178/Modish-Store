import 'package:flutter/material.dart';

class CustomLinear extends StatelessWidget {
  const CustomLinear({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      width: double.infinity,
      color: Theme.of(context).cardColor,
    );
  }
}
