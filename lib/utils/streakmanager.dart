import 'package:shared_preferences/shared_preferences.dart';

class StreakManager {
  static const String _lastUsedKey = 'last_used_date';
  static const String _streakKey = 'current_streak';

  Future<void> updateStreak() async {
    final prefs = await SharedPreferences.getInstance();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final lastUsedString = prefs.getString(_lastUsedKey);
    final lastUsedDate = lastUsedString != null
        ? DateTime.parse(lastUsedString)
        : null;

    int currentStreak = prefs.getInt(_streakKey) ?? 0;

    if (lastUsedDate == null) {
      // First time using the app
      currentStreak = 0;
    } else {
      final difference = today.difference(lastUsedDate).inDays;

      if (difference == 1) {
        // Used app the next day — increment streak
        currentStreak += 1;
      } else if (difference > 1) {
        // Missed one or more days — reset streak
        currentStreak = 0;
      } else {
        // Already used today — don't increment
        return;
      }
    }

    // Save updates
    await prefs.setString(_lastUsedKey, today.toIso8601String());
    await prefs.setInt(_streakKey, currentStreak);
  }

  Future<int> getCurrentStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 0;
  }
}
