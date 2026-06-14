import 'package:flutter/material.dart';
import 'package:graduation_project/core/colors.dart';
import 'package:graduation_project/core/fontstyle.dart';

class CardPaymentSheet extends StatefulWidget {
  const CardPaymentSheet({super.key});

  @override
  State<CardPaymentSheet> createState() => _CardPaymentSheetState();
}

class _CardPaymentSheetState extends State<CardPaymentSheet> {
  final _cardFormKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _obscureCvv = true;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  String _formatCardNumber(String value) {
    value = value.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < value.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(value[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Form(
          key: _cardFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Card Details',
                style: t18.copyWith(
                  color: primaryColorText,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 20),

              // Card Preview
              Container(
                width: double.infinity,
                height: 180,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xff574964), Color(0xff9F8383)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.credit_card,
                      color: Colors.white,
                      size: 32,
                    ),
                    const Spacer(),
                    ValueListenableBuilder(
                      valueListenable: _cardNumberController,
                      builder: (_, value, _) => Text(
                        value.text.isEmpty
                            ? '**** **** **** ****'
                            : value.text.padRight(19, '*'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ValueListenableBuilder(
                          valueListenable: _cardHolderController,
                          builder: (_, value, _) => Text(
                            value.text.isEmpty
                                ? 'CARD HOLDER'
                                : value.text.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: _expiryController,
                          builder: (_, value, _) => Text(
                            value.text.isEmpty ? 'MM/YY' : value.text,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Card Number
              TextFormField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                maxLength: 19,
                decoration: _inputDecoration(
                  hint: 'Card Number',
                  icon: Icons.credit_card,
                ),
                onChanged: (v) {
                  final formatted = _formatCardNumber(v);
                  if (formatted != v) {
                    _cardNumberController.value = TextEditingValue(
                      text: formatted,
                      selection: TextSelection.collapsed(
                        offset: formatted.length,
                      ),
                    );
                  }
                },
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  if (v.replaceAll(' ', '').length < 16) {
                    return 'Invalid card number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Card Holder
              TextFormField(
                controller: _cardHolderController,
                textCapitalization: TextCapitalization.words,
                decoration: _inputDecoration(
                  hint: 'Card Holder Name',
                  icon: Icons.person_outline,
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              // Expiry & CVV
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryController,
                      keyboardType: TextInputType.number,
                      maxLength: 5,
                      decoration: _inputDecoration(
                        hint: 'MM/YY',
                        icon: Icons.calendar_today_outlined,
                      ),
                      onChanged: (v) {
                        if (v.length == 2 && !v.contains('/')) {
                          _expiryController.text = '$v/';
                          _expiryController.selection = TextSelection.collapsed(
                            offset: _expiryController.text.length,
                          );
                        }
                      },
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(v)) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                      obscureText: _obscureCvv,
                      decoration:
                          _inputDecoration(
                            hint: 'CVV',
                            icon: Icons.lock_outline,
                          ).copyWith(
                            suffixIcon: GestureDetector(
                              onTap: () =>
                                  setState(() => _obscureCvv = !_obscureCvv),
                              child: Icon(
                                _obscureCvv
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: kPrimaryColor,
                                size: 20,
                              ),
                            ),
                          ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        if (v.length < 3) return 'Invalid CVV';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Confirm Button
              GestureDetector(
                onTap: () {
                  if (_cardFormKey.currentState!.validate()) {
                    Navigator.pop(context, true);
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    gradient: const LinearGradient(
                      colors: [Color(0xff9F8383), Color(0xff574964)],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Confirm Payment',
                      style: t16.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: secondaryColorText, fontSize: 13),
      prefixIcon: Icon(icon, color: kPrimaryColor, size: 20),
      counterText: '',
      filled: true,
      fillColor: const Color(0xffF8F8F8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kPrimaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }
}
