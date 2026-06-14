import 'package:flutter/material.dart';
import 'package:graduation_project/core/colors.dart';
import 'package:graduation_project/core/fontstyle.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
              size: 50,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Order Placed!',
            style: t18.copyWith(
              color: primaryColorText,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Your order has been placed successfully. We'll contact you soon!",
            textAlign: TextAlign.center,
            style: t14.copyWith(color: secondaryColorText),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
            child: Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xff9F8383), Color(0xff574964)],
                ),
              ),
              child: Center(
                child: Text(
                  'Back to Home',
                  style: t16.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
