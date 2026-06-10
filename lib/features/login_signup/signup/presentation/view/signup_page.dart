import 'package:flutter/material.dart';
import 'package:graduation_project/features/login_signup/signup/presentation/view/widgets/signup_body.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: SignupBody(),
        ),
      ),
    );
  }
}
