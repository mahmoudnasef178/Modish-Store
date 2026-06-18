import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modish_store/core/colors.dart';
import 'package:modish_store/core/fontstyle.dart';
import 'package:modish_store/features/HomePage/presentation/view/home/homepage.dart';
import 'package:modish_store/features/login_signup/login/data/repo/login_repo.dart';
import 'package:modish_store/features/login_signup/login/logic/login/login_cubit.dart';
import 'package:modish_store/features/login_signup/login/logic/login/login_state.dart';
import 'package:modish_store/features/login_signup/login/presentation/view/widget/custom_buttom_login_signup.dart';
import 'package:modish_store/features/login_signup/login/presentation/view/widget/custom_text.dart';
import 'package:modish_store/features/login_signup/login/presentation/view/widget/custom_text_field.dart';
import 'package:modish_store/features/login_signup/signup/presentation/view/signup_page.dart';

import 'package:modish_store/core/di/service_locator.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(getIt<LoginRepository>()),
      child: const _LoginForm(),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _emailOrUserNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailOrUserNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<LoginCubit>().login(
        emailOrUserName: _emailOrUserNameController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final titleFontSize = size.shortestSide * 0.09;
    final subFontSize = size.shortestSide * 0.045;
    final labelFontSize = size.shortestSide * 0.045;

    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const Homepage()),
            (route) => false,
          );
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: SingleChildScrollView(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteractionIfError,
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.12),

                // ✅ Title
                Text(
                  "Hello Again!",
                  style: t24.copyWith(
                    fontSize: titleFontSize,
                    color: primaryColorText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Text(
                  "Welcome Back You've Been Missed!",
                  style: t18.copyWith(
                    color: secondaryColorText,
                    fontSize: subFontSize,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: size.height * 0.06),

                _buildLabel("Email Address", labelFontSize),
                SizedBox(height: size.height * 0.015),
                CustomTextfield(
                  hintText: "Email Address",
                  controller: _emailOrUserNameController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email or username';
                    }
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.03),

                _buildLabel("Password", labelFontSize),
                SizedBox(height: size.height * 0.015),
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    final isVisible = context
                        .read<LoginCubit>()
                        .isPasswordVisible;
                    return CustomTextfield(
                      hintText: "Password",
                      controller: _passwordController,
                      showIcon: true,
                      obscureText: !isVisible,
                      onIconTap: () =>
                          context.read<LoginCubit>().togglePasswordVisibility(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    );
                  },
                ),
                SizedBox(height: size.height * 0.05),

                // ✅ Login button
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    final isLoading = state is LoginLoading;
                    return isLoading
                        ? const CircularProgressIndicator()
                        : CustomButtomLoginSignup(
                            text: "Login",
                            onTap: () => _onLogin(context),
                          );
                  },
                ),
                SizedBox(height: size.height * 0.02),
                CustomText(
                  text1: "Don't have an account?",
                  text2: "Sign Up. ",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignupPage()),
                    );
                  },
                ),
                SizedBox(height: size.height * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, double fontSize) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: t18.copyWith(
          color: primaryColorText,
          fontWeight: FontWeight.w600,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
