import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modish_store/features/HomePage/logic/notification_cubit/notification_cubit.dart';
import 'package:modish_store/features/HomePage/presentation/view/notification/widgets/notification_body.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationCubit()..loadNotifications(),
      child: const Scaffold(body: NotificationBody()),
    );
  }
}
