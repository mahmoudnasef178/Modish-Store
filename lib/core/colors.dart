import 'package:flutter/material.dart';

// Light
const Color kPrimaryColor = Color(0xff9F8383);
const Color kSecondColor = Color(0xffF8F9FA);
const Color primaryColorText = Color(0xff574964);
const Color secondaryColorText = Color(0xffAEAEAE);

// Dark
const Color kSecondColorDark = Color(0xff1A1A2E);
const Color primaryColorTextDark = Color(0xffF8F9FA);
const Color cardColorDark = Color(0xff2A2A3E);

// ✅ Helper functions - استخدمهم في الـ widgets
Color kBgColor(BuildContext context) =>
    Theme.of(context).scaffoldBackgroundColor;

Color kCardColor(BuildContext context) => Theme.of(context).cardColor;

Color kPrimaryText(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
    ? primaryColorTextDark
    : primaryColorText;

Color kSecondaryText(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
    ? const Color(0xff9E9E9E)
    : secondaryColorText;
