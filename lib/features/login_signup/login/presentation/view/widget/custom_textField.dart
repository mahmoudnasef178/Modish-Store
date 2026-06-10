import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  const CustomTextfield({
    super.key,
    required this.hintText,
    this.showIcon = false,
    this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText,
    this.onIconTap,
  });

  final String hintText;
  final bool showIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final VoidCallback? onIconTap;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  bool _internalObscure = true;

  bool get _isObscured => widget.obscureText ?? _internalObscure;

  OutlineInputBorder _border() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(32),
    borderSide: const BorderSide(color: Colors.transparent, width: 1),
  );
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Always use a light fill so text (which is forced dark) is readable
    final fillColor = isDark
        ? const Color(0xff2C2C2E) // dark card grey
        : const Color(0xffFFFFFF);
    final textColor = isDark ? Colors.white : Colors.black87;
    final iconColor = isDark ? Colors.white70 : Colors.grey;

    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      obscureText: widget.showIcon ? _isObscured : false,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        suffixIcon: widget.showIcon
            ? IconButton(
                onPressed: () {
                  if (widget.onIconTap != null) {
                    widget.onIconTap!();
                  } else {
                    setState(() => _internalObscure = !_internalObscure);
                  }
                },
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                  color: iconColor,
                ),
              )
            : const SizedBox.shrink(),
        hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey),
        hintText: widget.hintText,
        filled: true,
        fillColor: fillColor,
        border: _border(),
        enabledBorder: _border(),
        focusedBorder: _border(),
        disabledBorder: _border(),
        errorBorder: _border(),
        focusedErrorBorder: _border(),
      ),
    );
  }
}
