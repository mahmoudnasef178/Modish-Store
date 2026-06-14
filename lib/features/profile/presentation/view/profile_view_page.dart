import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:graduation_project/features/profile/data/repo/profile_repo.dart';
import 'package:graduation_project/features/profile/logic/profile/profile_cubit.dart';
import 'package:graduation_project/features/profile/presentation/view/widgets/profileViewPage_Body.dart';

class Profileviewpage extends StatelessWidget {
  const Profileviewpage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(GetIt.I<ProfileRepository>())..loadUser(),
      child: const Scaffold(
        body: ProfileviewpageBody(),
      ),
    );
  }
}
