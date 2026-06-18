import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:modish_store/core/colors.dart';
import 'package:modish_store/core/fontstyle.dart';
import 'package:modish_store/features/Cart/data/models/cart_model.dart';
import 'package:modish_store/features/Cart/data/repo/cart_repo.dart';
import 'package:modish_store/features/Cart/data/repo/order_repo.dart';
import 'package:modish_store/features/Cart/logic/checkout_cubit/checkout_cubit.dart';
import 'package:modish_store/features/Cart/logic/checkout_cubit/checkout_state.dart';
import 'package:modish_store/features/Cart/presentation/view/checkout/widgets/card_payment_sheet.dart';
import 'package:modish_store/features/Cart/presentation/view/checkout/widgets/custom_field.dart';
import 'package:modish_store/features/Cart/presentation/view/checkout/widgets/payment_option.dart';
import 'package:modish_store/features/Cart/presentation/view/checkout/widgets/section_title.dart';
import 'package:modish_store/features/Cart/presentation/view/checkout/widgets/success_dialog.dart';

class CheckoutPage extends StatelessWidget {
  final CartModel cart;
  const CheckoutPage({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CheckoutCubit(GetIt.I<OrderRepository>(), GetIt.I<CartRepository>()),
      child: _CheckoutView(cart: cart),
    );
  }
}

class _CheckoutView extends StatefulWidget {
  final CartModel cart;
  const _CheckoutView({required this.cart});

  @override
  State<_CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<_CheckoutView> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  final _phoneController = TextEditingController();
  String _paymentMethod = 'cash';

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _onPlaceOrder(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    if (_paymentMethod == 'card') {
      final confirmed = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const CardPaymentSheet(),
      );
      if (confirmed != true) return;
    }

    if (!context.mounted) return;

    context.read<CheckoutCubit>().placeOrder(
      cart: widget.cart,
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      zip: _zipController.text.trim(),
      phone: _phoneController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckoutCubit, CheckoutState>(
      listener: (context, state) {
        if (state is CheckoutSuccess) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const SuccessDialog(),
          );
        } else if (state is CheckoutError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: kSecondColor,
        appBar: AppBar(
          backgroundColor: kSecondColor,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Padding(
              padding: EdgeInsets.only(left: 18.0),
              child: Icon(Icons.arrow_back_ios, color: primaryColorText),
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
                // ─── Order Summary ───────────────────────────────────
                const SectionTitle(title: 'Order Summary'),
                const SizedBox(height: 12),
                _OrderSummaryCard(cart: widget.cart),
                const SizedBox(height: 24),

                // ─── Shipping Information ─────────────────────────────
                const SectionTitle(title: 'Shipping Information'),
                const SizedBox(height: 12),
                CustomField(
                  controller: _addressController,
                  hint: 'Street Address',
                  icon: Icons.location_on_outlined,
                  validator: (v) => v == null || v.isEmpty
                      ? 'Please enter your address'
                      : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: CustomField(
                        controller: _cityController,
                        hint: 'City',
                        icon: Icons.location_city_outlined,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomField(
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
                CustomField(
                  controller: _phoneController,
                  hint: 'Phone Number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Please enter your phone' : null,
                ),
                const SizedBox(height: 24),

                // ─── Payment Method ───────────────────────────────────
                const SectionTitle(title: 'Payment Method'),
                const SizedBox(height: 12),
                PaymentOption(
                  label: 'Cash on Delivery',
                  icon: Icons.money_rounded,
                  value: 'cash',
                  groupValue: _paymentMethod,
                  onChanged: (v) => setState(() => _paymentMethod = v!),
                ),
                const SizedBox(height: 8),
                PaymentOption(
                  label: 'Credit Card',
                  icon: Icons.credit_card_rounded,
                  value: 'card',
                  groupValue: _paymentMethod,
                  onChanged: (v) => setState(() => _paymentMethod = v!),
                ),
                const SizedBox(height: 32),

                // ─── Place Order Button ───────────────────────────────
                BlocBuilder<CheckoutCubit, CheckoutState>(
                  builder: (context, state) {
                    final isLoading = state is CheckoutLoading;
                    return GestureDetector(
                      onTap: isLoading ? null : () => _onPlaceOrder(context),
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
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  'Place Order',
                                  style: t16.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Displays order items, subtotal, delivery, and total in a card.
class _OrderSummaryCard extends StatelessWidget {
  final CartModel cart;
  static const double _shippingFee = 40.90;

  const _OrderSummaryCard({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Item rows
          ...cart.cartItems.map(
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
          // Subtotal
          _SummaryLine(
            label: 'Subtotal',
            value: '\$ ${cart.totalPrice.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 8),
          // Delivery
          const _SummaryLine(label: 'Delivery', value: '\$ 40.90'),
          const Divider(),
          // Total
          _SummaryLine(
            label: 'Total',
            value: '\$ ${(cart.totalPrice + _shippingFee).toStringAsFixed(2)}',
            isBold: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _SummaryLine({
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
          style: isBold
              ? t16.copyWith(
                  color: primaryColorText,
                  fontWeight: FontWeight.w800,
                )
              : t14.copyWith(color: secondaryColorText),
        ),
        Text(
          value,
          style: isBold
              ? t16.copyWith(
                  color: primaryColorText,
                  fontWeight: FontWeight.w900,
                )
              : t14.copyWith(color: secondaryColorText),
        ),
      ],
    );
  }
}
