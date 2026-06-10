import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:graduation_project/core/secure_storage_helper.dart';
import 'package:graduation_project/features/profile/data/models/user_model.dart';
import 'package:http/http.dart' as http;

class ProfileRepository {
  static const _baseUrl = 'http://ecommercetest2.runasp.net/api/ManageUser';

  Future<String?> _getToken() async {
    return SecureStorageHelper.getToken();
  }

  String? _extractUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      String payload = parts[1];
      switch (payload.length % 4) {
        case 2:
          payload += '==';
          break;
        case 3:
          payload += '=';
          break;
      }
      final decoded = utf8.decode(base64Url.decode(payload));
      final Map<String, dynamic> claims = jsonDecode(decoded);
      return claims['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];
    } catch (e) {
      return null;
    }
  }

  Future<UserModel> getCurrentUser() async {
    final token = await _getToken();
    if (token == null) throw Exception('No token found');

    String? userId = _extractUserIdFromToken(token);
    if (userId == null || userId.isEmpty) {
      userId = await SecureStorageHelper.getUserId();
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/GetAllUsers'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List users = jsonDecode(response.body);
      final userData = users.firstWhere(
        (u) => u['id'].toString().toLowerCase() == userId?.toLowerCase(),
        orElse: () => throw Exception('User not found'),
      );
      return UserModel.fromJson(userData);
    } else {
      throw Exception('Failed to load user: ${response.statusCode}');
    }
  }

  /// Updates user profile using query parameters.
  Future<void> updateUser({
    required String id,
    required String newUserName,
    required String newEmail,
    String? currentPassword,
    String? newPassword,
  }) async {
    final token = await _getToken();

    // Build query params manually to control encoding
    final queryParams = StringBuffer();
    queryParams.write('id=${Uri.encodeComponent(id)}');
    queryParams.write('&newUserName=${Uri.encodeComponent(newUserName)}');
    queryParams.write('&newEmail=${Uri.encodeComponent(newEmail)}');
    if (currentPassword != null && currentPassword.isNotEmpty) {
      queryParams.write(
        '&currentPassword=${Uri.encodeComponent(currentPassword)}',
      );
    }
    if (newPassword != null && newPassword.isNotEmpty) {
      queryParams.write('&newPassword=${Uri.encodeComponent(newPassword)}');
    }

    final uri = Uri.parse('$_baseUrl/UpdateUser?$queryParams');
    debugPrint('UPDATE URI: $uri');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    debugPrint('STATUS: ${response.statusCode}');
    debugPrint('BODY: ${response.body}');

    if (response.statusCode != 200) {
      try {
        final body = jsonDecode(response.body);
        if (body is Map && body.containsKey('message')) {
          final message = body['message'].toString();
          if (message.toLowerCase().contains('password')) {
            throw Exception('Current password is incorrect');
          }
          throw Exception(message);
        }
      } catch (e) {
        if (e is Exception) rethrow;
      }
      throw Exception('Failed to update profile');
    }
  }
}

