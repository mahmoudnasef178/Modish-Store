import 'package:flutter/material.dart';
import 'package:modish_store/core/colors.dart';
import 'package:modish_store/core/fontstyle.dart';

class PaymentOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  const PaymentOption({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryColor.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? kPrimaryColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? kPrimaryColor : secondaryColorText,
              size: 22,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: t14.copyWith(
                color: isSelected ? primaryColorText : secondaryColorText,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
            const Spacer(),
            RadioGroup<String>(
              groupValue: groupValue,
              onChanged: onChanged,
              child: Radio<String>(
                value: value,
                activeColor: kPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
