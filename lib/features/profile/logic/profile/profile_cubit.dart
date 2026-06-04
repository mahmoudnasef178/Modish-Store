import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/profile/data/models/user_model.dart';
import 'package:graduation_project/features/profile/data/repo/profile_repo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repo;
  UserModel? currentUser;
  XFile? pickedImage;

  ProfileCubit(this._repo) : super(ProfileInitial());

  Future<void> loadUser() async {
    emit(ProfileLoading());
    try {
      currentUser = await _repo.getCurrentUser();
      // ✅ جيب الصورة المحفوظة
      final prefs = await SharedPreferences.getInstance();
      final savedImagePath = prefs.getString('profile_image_path');
      if (savedImagePath != null) {
        pickedImage = XFile(savedImagePath);
      }
      emit(ProfileLoaded(currentUser!));
    } catch (e) {
      emit(ProfileError(e.toString()));
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
      if (!isClosed) emit(ProfileUpdated());
    } catch (e) {
      if (!isClosed) emit(ProfileError(e.toString()));
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedImage = image;
      // ✅ احفظ الـ path
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_path', image.path);
      if (currentUser != null && !isClosed) emit(ProfileLoaded(currentUser!));
    }
  }
}
