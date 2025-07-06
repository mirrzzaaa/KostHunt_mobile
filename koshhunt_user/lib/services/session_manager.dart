import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  // simpan id + email
  static Future<void> saveLoginSession({
    required int userId,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setInt('userId', userId);
    await prefs.setString('email', email);
  }

  static Future<int?> getUserId() async =>
      (await SharedPreferences.getInstance()).getInt('userId');

  static Future<void> clearSession() async {
    (await SharedPreferences.getInstance()).clear();
  }

  static Future<bool> isLoggedIn() async =>
      (await SharedPreferences.getInstance()).getBool('isLoggedIn') ?? false;

  static Future<String?> getEmail() async =>
      (await SharedPreferences.getInstance()).getString('email');
}
