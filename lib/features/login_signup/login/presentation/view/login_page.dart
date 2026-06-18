import 'package:flutter/material.dart';
import 'package:modish_store/features/login_signup/login/presentation/view/widget/login_body.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: LoginBody(),
        ),
      ),
    );
  }
}
