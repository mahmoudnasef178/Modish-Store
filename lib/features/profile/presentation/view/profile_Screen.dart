import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/core/colors.dart';
import 'package:graduation_project/core/fontstyle.dart';
import 'package:graduation_project/features/HomePage/presentation/view/widget/custom_AppBar.dart';
import 'package:graduation_project/features/login_signup/login/presentation/view/widget/custom_textField.dart';
import 'package:graduation_project/features/profile/data/models/user_model.dart';
import 'package:graduation_project/features/profile/data/repo/profile_repo.dart';
import 'package:graduation_project/features/profile/logic/profile/profile_cubit.dart';
import 'package:graduation_project/features/profile/logic/profile/profile_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(ProfileRepository())..loadUser(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _fieldsPopulated = false;
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _populateFields(UserModel user) {
    if (!_fieldsPopulated) {
      _nameController.text = user.displayName;
      _emailController.text = user.email;
      _fieldsPopulated = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide > 600;

    final avatarRadius = size.shortestSide * (isTablet ? 0.1 : 0.13);
    final avatarIconSize = avatarRadius * 1.1;
    final horizontalPadding = size.width * (isTablet ? 0.1 : 0.06);
    final titleFontSize = size.shortestSide * (isTablet ? 0.03 : 0.045);
    final buttonHeight = size.height * 0.065;
    final verticalSpacing = size.height * 0.02;

    return Scaffold(
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            setState(() => _fieldsPopulated = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileError &&
              context.read<ProfileCubit>().currentUser == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: size.shortestSide * 0.12,
                    color: Colors.red,
                  ),
                  SizedBox(height: verticalSpacing),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: titleFontSize * 0.8,
                    ),
                  ),
                  SizedBox(height: verticalSpacing),
                  ElevatedButton(
                    onPressed: () => context.read<ProfileCubit>().loadUser(),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          final cubit = context.read<ProfileCubit>();
          final user = cubit.currentUser;
          if (user != null) _populateFields(user);

          final isUpdating = state is ProfileUpdating;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: size.height * 0.01,
              horizontal: horizontalPadding,
            ),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: size.width * 0.07),
                    child: CustomAppbar(
                      leftIcon: "assets/icons/Arrow.svg",
                      title: "Profile",
                      rightIcon: "",
                      showIcon: false,
                      leftIconOnTap: () => Navigator.pop(context),
                    ),
                  ),
                  Gap(size.height * 0.04),

                  GestureDetector(
                    onTap: () => cubit.pickImage(),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: avatarRadius,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: cubit.pickedImage != null
                              ? FileImage(File(cubit.pickedImage!.path))
                              : null,
                          child: cubit.pickedImage == null
                              ? Icon(
                                  Icons.person,
                                  size: avatarIconSize,
                                  color: Colors.grey.shade400,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(size.shortestSide * 0.015),
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: size.shortestSide * 0.04,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),

                  if (user != null)
                    Text(
                      user.displayName,
                      style: TextStyle(
                        fontSize: titleFontSize * 1.1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  SizedBox(height: verticalSpacing * 1.5),

                  _buildLabel('Name', titleFontSize),
                  SizedBox(height: verticalSpacing * 0.8),
                  CustomTextfield(
                    hintText: "Your Name",
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      if (value.contains(' ')) {
                        return 'Name cannot contain spaces';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: verticalSpacing * 1.5),

                  _buildLabel('Email Address', titleFontSize),
                  SizedBox(height: verticalSpacing * 0.8),
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
                  SizedBox(height: verticalSpacing * 1.5),

                  _buildLabel('Current Password', titleFontSize),
                  SizedBox(height: verticalSpacing * 0.8),
                  CustomTextfield(
                    hintText: "Current Password",
                    controller: _currentPasswordController,
                    showIcon: true,
                    obscureText: !_isCurrentPasswordVisible,
                    onIconTap: () => setState(
                      () => _isCurrentPasswordVisible =
                          !_isCurrentPasswordVisible,
                    ),
                    validator: (value) {
                      if (_newPasswordController.text.isNotEmpty &&
                          (value == null || value.isEmpty)) {
                        return 'Please enter your current password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: verticalSpacing * 1.5),

                  _buildLabel('New Password', titleFontSize),
                  SizedBox(height: verticalSpacing * 0.8),
                  CustomTextfield(
                    hintText: "New Password",
                    controller: _newPasswordController,
                    showIcon: true,
                    obscureText: !_isNewPasswordVisible,
                    onIconTap: () => setState(
                      () => _isNewPasswordVisible = !_isNewPasswordVisible,
                    ),
                    validator: (value) {
                      if (value != null && value.isNotEmpty && value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: verticalSpacing * 2),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: isUpdating
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                cubit.updateUser(
                                  newUserName: _nameController.text.trim(),
                                  newEmail: _emailController.text.trim(),
                                  currentPassword:
                                      _currentPasswordController.text
                                          .trim()
                                          .isEmpty
                                      ? null
                                      : _currentPasswordController.text.trim(),
                                  newPassword:
                                      _newPasswordController.text.trim().isEmpty
                                      ? null
                                      : _newPasswordController.text.trim(),
                                );
                              }
                              Navigator.pop(context);
                            },
                      child: Container(
                        height: buttonHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: kPrimaryColor,
                        ),
                        child: isUpdating
                            ? const Center(
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Center(
                                child: Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    fontSize: titleFontSize * 0.85,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: verticalSpacing),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper method for field labels
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
