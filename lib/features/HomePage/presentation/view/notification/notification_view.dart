import 'package:flutter/material.dart';
import 'package:modish_store/features/HomePage/presentation/view/notification/widgets/notification_body.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: NotificationBody());
  }
}
