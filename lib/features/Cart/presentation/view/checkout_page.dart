import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:graduation_project/core/colors.dart';
import 'package:graduation_project/core/fontstyle.dart';
import 'package:graduation_project/features/Cart/data/models/cart_model.dart';
import 'package:graduation_project/features/Cart/data/repo/cart_repo.dart';

class CheckoutPage extends StatefulWidget {
  final CartModel cart;
  const CheckoutPage({super.key, required this.cart});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  final _phoneController = TextEditingController();
  String _paymentMethod = 'cash';
  bool _isLoading = false;

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    if (_paymentMethod == 'card') {
      final confirmed = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const _CardPaymentSheet(),
      );
      if (confirmed != true) return;
    }

    setState(() => _isLoading = true);
    try {
      final dio = Dio();
      try {
        await dio.get(
          'https://gradutionapi-production.up.railway.app/api/v1/products',
          options: Options(sendTimeout: Duration(seconds: 5)),
        );
      } catch (_) {}

      await Future.delayed(const Duration(seconds: 2));

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId') ?? '';
      final userEmail = prefs.getString('email') ?? '';
      print('📧 userEmail: $userEmail');

      final orderItems = widget.cart.cartItems
          .map((item) => {'product': item.productId, 'quantity': item.quantity})
          .toList();

      final displayName = prefs.getString('displayName') ?? 'Customer';

      final response = await dio.post(
        'https://gradutionapi-production.up.railway.app/api/v1/Order/BasketOrder',
        data: {
          'orderItems': orderItems,
          'shippingAddress1': _addressController.text.trim(),
          'city': _cityController.text.trim(),
          'zip': _zipController.text.trim(),
          'phone': _phoneController.text.trim(),
          'country': 'Egypt',
          'status': 'Pending',
          'user': userId,
          'firstName': displayName, // ✅ حط الاسم هنا
          'lastName': '',
        },
      );

      print('✅ Order Response: ${response.data}');

      // ✅ بعت الـ email
      try {
        final emailDio = Dio();
        final emailResponse = await emailDio.post(
          'https://api.emailjs.com/api/v1.0/email/send',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'origin': 'http://localhost',
            },
          ),
          data: {
            'service_id': 'service_q7sw7w7',
            'template_id': 'template_j6nbley',
            'user_id': 'kBpJi2toH4-hSqrtZ',
            'accessToken': 'hDfUXKsDxYZ91etL3aIe_',
            'template_params': {
              'email': userEmail,
              'order_id': response.data['id'] ?? response.data['_id'] ?? '',
              'items': widget.cart.cartItems
                  .map(
                    (item) =>
                        '${item.productName} x${item.quantity} = \$${item.totalPrice.toStringAsFixed(2)}',
                  )
                  .join('\n'),
              'cost_shipping': '40.90',
              'cost_total': (widget.cart.totalPrice + 40.9).toStringAsFixed(2),
            },
          },
        );
        print('✅ Email sent: ${emailResponse.data}');
      } catch (e) {
        print('❌ Email error: $e');
      }

      try {
        await CartRepository().clearCart();
      } catch (_) {
        print('⚠️ Cart clear failed but order was placed');
      }

      if (mounted) _showSuccessDialog();
    } on DioException catch (e) {
      print('❌ DioError: ${e.message}');
      print('❌ Response: ${e.response?.data}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.response?.data ?? e.message}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
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
              'Your order has been placed successfully. We\'ll contact you soon!',
              textAlign: TextAlign.center,
              style: t14.copyWith(color: secondaryColorText),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondColor,
      appBar: AppBar(
        backgroundColor: kSecondColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: const Icon(Icons.arrow_back_ios, color: primaryColorText),
          ),
        ),
        title: Text(
          'Checkout',
          style: t18.copyWith(
            color: primaryColorText,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Summary
              _SectionTitle(title: 'Order Summary'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    ...widget.cart.cartItems.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${item.productName} x${item.quantity}',
                                style: t14.copyWith(color: primaryColorText),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '\$ ${item.totalPrice.toStringAsFixed(2)}',
                              style: t14.copyWith(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    // ✅ سعر المنتجات
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subtotal',
                          style: t14.copyWith(color: secondaryColorText),
                        ),
                        Text(
                          '\$ ${widget.cart.totalPrice.toStringAsFixed(2)}',
                          style: t14.copyWith(color: secondaryColorText),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // ✅ سعر الديلفري
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delivery',
                          style: t14.copyWith(color: secondaryColorText),
                        ),
                        Text(
                          '\$ 40.90',
                          style: t14.copyWith(color: secondaryColorText),
                        ),
                      ],
                    ),
                    const Divider(),
                    // ✅ الإجمالي مع الديلفري
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: t16.copyWith(
                            color: primaryColorText,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '\$ ${(widget.cart.totalPrice + 40.9).toStringAsFixed(2)}',
                          style: t16.copyWith(
                            color: primaryColorText,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Shipping Info
              _SectionTitle(title: 'Shipping Information'),
              const SizedBox(height: 12),
              _CustomField(
                controller: _addressController,
                hint: 'Street Address',
                icon: Icons.location_on_outlined,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Please enter your address' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _CustomField(
                      controller: _cityController,
                      hint: 'City',
                      icon: Icons.location_city_outlined,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _CustomField(
                      controller: _zipController,
                      hint: 'ZIP Code',
                      icon: Icons.markunread_mailbox_outlined,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _CustomField(
                controller: _phoneController,
                hint: 'Phone Number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Please enter your phone' : null,
              ),
              const SizedBox(height: 24),

              // Payment Method
              _SectionTitle(title: 'Payment Method'),
              const SizedBox(height: 12),
              _PaymentOption(
                label: 'Cash on Delivery',
                icon: Icons.money_rounded,
                value: 'cash',
                groupValue: _paymentMethod,
                onChanged: (v) => setState(() => _paymentMethod = v!),
              ),
              const SizedBox(height: 8),
              _PaymentOption(
                label: 'Credit Card',
                icon: Icons.credit_card_rounded,
                value: 'card',
                groupValue: _paymentMethod,
                onChanged: (v) => setState(() => _paymentMethod = v!),
              ),
              const SizedBox(height: 32),

              // Place Order Button
              GestureDetector(
                onTap: _isLoading ? null : _placeOrder,
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
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Place Order',
                            style: t16.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: t16.copyWith(color: primaryColorText, fontWeight: FontWeight.w800),
    );
  }
}

class _CustomField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _CustomField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: secondaryColorText, fontSize: 13),
        prefixIcon: Icon(icon, color: kPrimaryColor, size: 20),
        filled: true,
        fillColor: Colors.white,
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
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  const _PaymentOption({
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
          color: isSelected ? kPrimaryColor.withOpacity(0.08) : Colors.white,
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
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: kPrimaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _CardPaymentSheet extends StatefulWidget {
  const _CardPaymentSheet();

  @override
  State<_CardPaymentSheet> createState() => _CardPaymentSheetState();
}

class _CardPaymentSheetState extends State<_CardPaymentSheet> {
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
                      builder: (_, value, __) => Text(
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
                          builder: (_, value, __) => Text(
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
                          builder: (_, value, __) => Text(
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
                  if (v.replaceAll(' ', '').length < 16)
                    return 'Invalid card number';
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
                        if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(v))
                          return 'Invalid';
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
      hintStyle: TextStyle(color: secondaryColorText, fontSize: 13),
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
