import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _loggedInKey = 'logged_in';

  // บันทึกสถานะการล็อกอิน
  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_loggedInKey, value);
  }

  // ตรวจสอบว่าผู้ใช้ล็อกอินแล้วหรือยัง
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  // ล้างสถานะการล็อกอินเมื่อผู้ใช้ Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
