import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:modish_store/core/colors.dart';
import 'package:modish_store/core/fontstyle.dart';
import 'package:modish_store/features/profile/data/models/user_model.dart';
import 'package:modish_store/features/profile/data/repo/profile_repo.dart';
import 'package:modish_store/features/profile/logic/profile/profile_cubit.dart';
import 'package:modish_store/features/profile/logic/profile/profile_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(GetIt.I<ProfileRepository>())..loadUser(),
      child: const Scaffold(
        body: _ProfileView(),
      ),
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

    final avatarRadius = size.shortestSide * (isTablet ? 0.12 : 0.15);
    final horizontalPadding = size.width * (isTablet ? 0.1 : 0.05);
    final verticalSpacing = size.height * 0.02;

    final cardColor = Theme.of(context).brightness == Brightness.dark
        ? cardColorDark
        : Colors.white;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new, color: primaryColorText),
        ),
        title: Text(
          "Edit Profile",
          style: t18.copyWith(color: primaryColorText, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
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
            Navigator.pop(context); // Close screen ONLY after successful update
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
                    Icons.error_outline_rounded,
                    size: 64,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 16),
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
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: horizontalPadding,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // ─── Profile Avatar Section ─────────────────────────
                  Center(
                    child: GestureDetector(
                      onTap: () => cubit.pickImage(),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xff9F8383), width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: avatarRadius,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage: cubit.pickedImage != null
                                  ? FileImage(File(cubit.pickedImage!.path))
                                  : null,
                              child: cubit.pickedImage == null
                                  ? Icon(
                                      Icons.person,
                                      size: avatarRadius * 1.1,
                                      color: Colors.grey.shade400,
                                    )
                                  : null,
                            ),
                          ),
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xff9F8383),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Tap to change profile picture",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ─── Input Fields Card ──────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _ProfileInputField(
                          label: 'Full Name',
                          hint: 'Your Name',
                          prefixIcon: Icons.person_outline_rounded,
                          controller: _nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            if (value.trim().contains(' ')) {
                              return 'Name cannot contain spaces';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: verticalSpacing),

                        _ProfileInputField(
                          label: 'Email Address',
                          hint: 'Email Address',
                          prefixIcon: Icons.mail_outline_rounded,
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
                        SizedBox(height: verticalSpacing),

                        _ProfileInputField(
                          label: 'Current Password',
                          hint: 'Enter current password to save changes',
                          prefixIcon: Icons.lock_outline_rounded,
                          controller: _currentPasswordController,
                          isPassword: true,
                          validator: (value) {
                            if (_newPasswordController.text.isNotEmpty &&
                                (value == null || value.isEmpty)) {
                              return 'Please enter your current password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: verticalSpacing),

                        _ProfileInputField(
                          label: 'New Password',
                          hint: 'Optional: Enter new password',
                          prefixIcon: Icons.lock_reset_rounded,
                          controller: _newPasswordController,
                          isPassword: true,
                          validator: (value) {
                            if (value != null && value.isNotEmpty && value.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ─── Save Changes Button ───────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: GestureDetector(
                      onTap: isUpdating
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                cubit.updateUser(
                                  newUserName: _nameController.text.trim(),
                                  newEmail: _emailController.text.trim(),
                                  currentPassword:
                                      _currentPasswordController.text.trim().isEmpty
                                          ? null
                                          : _currentPasswordController.text.trim(),
                                  newPassword:
                                      _newPasswordController.text.trim().isEmpty
                                          ? null
                                          : _newPasswordController.text.trim(),
                                );
                              }
                            },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          gradient: const LinearGradient(
                            colors: [Color(0xff9F8383), Color(0xff574964)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff574964).withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
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
                            : const Center(
                                child: Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProfileInputField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData prefixIcon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextInputType? keyboardType;

  const _ProfileInputField({
    required this.label,
    required this.hint,
    required this.prefixIcon,
    required this.controller,
    this.validator,
    this.isPassword = false,
    this.keyboardType,
  });

  @override
  State<_ProfileInputField> createState() => _ProfileInputFieldState();
}

class _ProfileInputFieldState extends State<_ProfileInputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final textColor = kPrimaryText(context);
    final fieldBg = Theme.of(context).brightness == Brightness.dark
        ? Theme.of(context).scaffoldBackgroundColor
        : Colors.grey.shade50;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Text(
            widget.label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: primaryColorText,
            ),
          ),
        ),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,
          style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontWeight: FontWeight.w400),
            prefixIcon: Icon(widget.prefixIcon, color: const Color(0xff9F8383), size: 20),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: Colors.grey.shade400,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscureText = !_obscureText),
                  )
                : null,
            filled: true,
            fillColor: fieldBg,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xff9F8383), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
