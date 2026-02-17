import 'package:shared_preferences/shared_preferences.dart';

class CoachService {
  static const _prefix = "coach_seen_";

  static Future<bool> hasSeen(String screen) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("$_prefix$screen") ?? false;
  }

  static Future<void> markSeen(String screen) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("$_prefix$screen", true);
  }

  static Future<void> reset(String screen) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("$_prefix$screen");
  }
}
