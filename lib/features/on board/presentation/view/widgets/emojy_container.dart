import 'package:flutter/material.dart';

class EmojyContainer extends StatelessWidget {
  const EmojyContainer({
    super.key,
    required this.height,
    required this.weight,
    required this.color,
  });
  final double height;
  final double weight;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: weight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: color,
      ),
    );
  }
}
