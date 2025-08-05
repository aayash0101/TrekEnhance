// auth_helper.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthHelper {
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'auth_token';

  // Get current user ID from stored user data
  static Future<String?> getuserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userKey);
      
      if (userData != null) {
        final Map<String, dynamic> user = jsonDecode(userData);
        return user['id'] as String?;
      }
      return null;
    } catch (e) {
      print('Error getting current user ID: $e');
      return null;
    }
  }

  // Get current user data
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userKey);
      
      if (userData != null) {
        return jsonDecode(userData) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      final userData = prefs.getString(_userKey);
      
      return token != null && userData != null;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  // Save user data after login
  static Future<void> saveUserData(Map<String, dynamic> user, String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(user));
      await prefs.setString(_tokenKey, token);
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  // Clear user data on logout
  static Future<void> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.remove(_tokenKey);
    } catch (e) {
      print('Error clearing user data: $e');
    }
  }

  // Get auth token
  static Future<String?> getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      print('Error getting auth token: $e');
      return null;
    }
  }
}