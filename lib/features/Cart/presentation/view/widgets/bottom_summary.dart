import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/core/colors.dart';
import 'package:graduation_project/core/fontstyle.dart';
import 'package:graduation_project/features/Cart/data/models/cart_model.dart';
import 'package:graduation_project/features/Cart/presentation/view/checkout_page.dart';

class BottomSummary extends StatelessWidget {
  final CartModel cart;
  const BottomSummary({super.key, required this.cart});

  static const double shippingFee = 40.90;

  @override
  Widget build(BuildContext context) {
    final total = cart.totalPrice + shippingFee;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          SummaryRow(
            label: 'Subtotal',
            value: '\$${cart.totalPrice.toStringAsFixed(2)}',
          ),
          const Gap(8),
          SummaryRow(
            label: 'Shipping',
            value: '\$${shippingFee.toStringAsFixed(2)}',
          ),
          const Gap(12),
          const Divider(height: 1, color: Color(0xffEEEEEE)),
          const Gap(12),
          SummaryRow(
            label: 'Total Cost',
            value: '\$${total.toStringAsFixed(2)}',
            isBold: true,
          ),
          const Gap(20),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CheckoutPage(cart: cart)),
            ),
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: kPrimaryColor,
              ),
              child: Center(
                child: Text(
                  'Checkout',
                  style: t18.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
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

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: t14.copyWith(
            color: isBold ? primaryColorText : secondaryColorText,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: t14.copyWith(
            color: primaryColorText,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
