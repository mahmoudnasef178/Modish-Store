import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:graduation_project/core/colors.dart';
import 'package:graduation_project/core/fontstyle.dart';
import 'package:graduation_project/features/HomePage/presentation/view/homepage.dart';
import 'package:graduation_project/features/login_signup/login/presentation/view/widget/custom_buttom_login_signup.dart';
import 'package:graduation_project/features/login_signup/login/presentation/view/widget/custom_text.dart';
import 'package:graduation_project/features/login_signup/login/presentation/view/widget/custom_textField.dart';
import 'package:graduation_project/features/login_signup/signup/data/repo/signUp_repo.dart';
import 'package:graduation_project/features/login_signup/signup/logic/sign_up/sign_up_cubit.dart';
import 'package:graduation_project/features/login_signup/signup/logic/sign_up/sign_up_state.dart';

class SignupBody extends StatelessWidget {
  const SignupBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupCubit(GetIt.I<SignupRepository>()),
      child: const _SignupForm(),
    );
  }
}

class _SignupForm extends StatefulWidget {
  const _SignupForm();

  @override
  State<_SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<_SignupForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignup(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<SignupCubit>().register(
        email: _emailController.text.trim(),
        userName: _nameController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final titleFontSize = size.shortestSide * 0.08;
    final subFontSize = size.shortestSide * 0.045;
    final labelFontSize = size.shortestSide * 0.045;
    final backBtnSize = size.shortestSide * 0.12;
    final backIconSize = size.shortestSide * 0.045;

    return BlocListener<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Homepage()),
          );
        } else if (state is SignupFailure) {
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
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: size.height * 0.07),

                // ✅ Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: size.width * 0.04),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: backBtnSize,
                        width: backBtnSize,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(64),
                          color: Colors.transparent,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: size.width * 0.00),
                          child: Icon(Icons.arrow_back_ios, size: backIconSize),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.04),

                // ✅ Title
                Text(
                  "Create Account",
                  style: t20.copyWith(
                    fontSize: titleFontSize,
                    color: primaryColorText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Text(
                  "Let's Create Account Together",
                  style: t18.copyWith(
                    color: secondaryColorText,
                    fontSize: subFontSize,
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                _buildLabel("Name", labelFontSize),
                SizedBox(height: size.height * 0.015),
                CustomTextfield(
                  hintText: "Your Name",
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.03),

                _buildLabel("Email Address", labelFontSize),
                SizedBox(height: size.height * 0.015),
                CustomTextfield(
                  hintText: "Email Address",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(
                      r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.03),

                // Password field
                _buildLabel("Password", labelFontSize),
                SizedBox(height: size.height * 0.015),
                BlocBuilder<SignupCubit, SignupState>(
                  builder: (context, state) {
                    final isVisible = context
                        .read<SignupCubit>()
                        .isPasswordVisible;
                    return CustomTextfield(
                      hintText: "Password",
                      controller: _passwordController,
                      showIcon: true,
                      obscureText: !isVisible,
                      onIconTap: () => context
                          .read<SignupCubit>()
                          .togglePasswordVisibility(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    );
                  },
                ),
                SizedBox(height: size.height * 0.05),

                // Sign Up button
                BlocBuilder<SignupCubit, SignupState>(
                  builder: (context, state) {
                    final isLoading = state is SignupLoading;
                    return isLoading
                        ? const CircularProgressIndicator()
                        : CustomButtomLoginSignup(
                            text: "Sign Up",
                            onTap: () => _onSignup(context),
                          );
                  },
                ),
                SizedBox(height: size.height * 0.02),
                CustomText(
                  text1: "Already have an account?",
                  text2: "Login ",
                  onTap: () => Navigator.pop(context),
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
