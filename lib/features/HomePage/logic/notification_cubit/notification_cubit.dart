import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modish_store/core/services/notification_storage_service.dart';
import 'package:modish_store/features/HomePage/data/models/notification/notification_model.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  Future<void> loadNotifications() async {
    emit(NotificationLoading());
    try {
      final list = await NotificationStorageService.getNotifications();
      emit(NotificationLoaded(list));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> addNotification(NotificationModel notification) async {
    try {
      await NotificationStorageService.addNotification(notification);
      await loadNotifications();
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await NotificationStorageService.markAsRead(id);
      final list = await NotificationStorageService.getNotifications();
      emit(NotificationLoaded(list));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      await NotificationStorageService.deleteNotification(id);
      final list = await NotificationStorageService.getNotifications();
      emit(NotificationLoaded(list));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> clearAllNotifications() async {
    try {
      await NotificationStorageService.clearAll();
      emit(NotificationLoaded(const []));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}
