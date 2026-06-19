import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modish_store/features/profile/data/models/user_model.dart';
import 'package:modish_store/features/profile/data/repo/profile_repo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repo;
  UserModel? currentUser;
  XFile? pickedImage;
  Uint8List? pickedImageBytes;

  ProfileCubit(this._repo) : super(ProfileInitial());

  Future<void> loadUser() async {
    if (isClosed) return;
    emit(ProfileLoading());
    try {
      currentUser = await _repo.getCurrentUser();
      
      final prefs = await SharedPreferences.getInstance();
      final base64Image = prefs.getString('profile_image_base64');
      if (base64Image != null) {
        pickedImageBytes = base64Decode(base64Image);
      } else {
        final savedImagePath = prefs.getString('profile_image_path');
        if (savedImagePath != null && !kIsWeb) {
          try {
            final file = File(savedImagePath);
            if (await file.exists()) {
              pickedImageBytes = await file.readAsBytes();
            }
          } catch (_) {}
        }
      }
      
      if (!isClosed) emit(ProfileLoaded(currentUser!));
    } catch (e) {
      if (!isClosed) emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateUser({
    required String newUserName,
    required String newEmail,
    String? currentPassword,
    String? newPassword,
  }) async {
    if (currentUser == null) return;
    emit(ProfileUpdating(currentUser!));
    try {
      await _repo.updateUser(
        id: currentUser!.id,
        newUserName: newUserName,
        newEmail: newEmail,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      currentUser = UserModel(
        id: currentUser!.id,
        displayName: newUserName,
        email: newEmail,
        phoneNumber: currentUser!.phoneNumber,
        roles: currentUser!.roles,
      );
      
      // Update local SharedPreferences metadata
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('displayName', newUserName);
      await prefs.setString('email', newEmail);

      if (!isClosed) emit(ProfileUpdated());
    } catch (e) {
      if (!isClosed) emit(ProfileError(e.toString()));
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 256,
      maxHeight: 256,
      imageQuality: 80,
    );
    if (image != null) {
      pickedImage = image;
      final bytes = await image.readAsBytes();
      pickedImageBytes = bytes;
      
      final prefs = await SharedPreferences.getInstance();
      final base64String = base64Encode(bytes);
      await prefs.setString('profile_image_base64', base64String);
      
      if (currentUser != null && !isClosed) emit(ProfileLoaded(currentUser!));
    }
  }
}
