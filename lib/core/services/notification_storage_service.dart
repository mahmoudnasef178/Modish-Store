import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modish_store/features/HomePage/data/models/notification/notification_model.dart';

class NotificationStorageService {
  static const String _notificationsKey = 'user_notifications';

  static Future<List<NotificationModel>> getNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonStr = prefs.getString(_notificationsKey);
      if (jsonStr == null || jsonStr.isEmpty) {
        return [];
      }
      final List<dynamic> decodedList = jsonDecode(jsonStr);
      return decodedList.map((item) => NotificationModel.fromJson(item)).toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Latest first
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveNotifications(List<NotificationModel> notifications) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String jsonStr = jsonEncode(notifications.map((n) => n.toJson()).toList());
      await prefs.setString(_notificationsKey, jsonStr);
    } catch (_) {}
  }

  static Future<void> addNotification(NotificationModel notification) async {
    final list = await getNotifications();
    list.insert(0, notification); // Add to beginning
    await saveNotifications(list);
  }

  static Future<void> markAsRead(String id) async {
    final list = await getNotifications();
    final index = list.indexWhere((n) => n.id == id);
    if (index != -1) {
      list[index] = list[index].copyWith(isRead: true);
      await saveNotifications(list);
    }
  }

  static Future<void> deleteNotification(String id) async {
    final list = await getNotifications();
    list.removeWhere((n) => n.id == id);
    await saveNotifications(list);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_notificationsKey);
  }
}
