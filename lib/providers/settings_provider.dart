import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

/// مزود الإعدادات: الثيم، حجم الخط، اللون الرئيسي، اللغة ...
class SettingsProvider extends ChangeNotifier {
  static const String _boxName = 'settings';

  late Box _box;

  // Keys
  static const String _kThemeMode = 'themeMode';
  static const String _kFontScale = 'fontScale';
  static const String _kArabicFont = 'arabicFont';
  static const String _kPrimaryColorIndex = 'primaryColorIndex';
  static const String _kDailyGoal = 'dailyGoal';
  static const String _kNotificationsEnabled = 'notifications';
  static const String _kSoundEnabled = 'soundEnabled';
  static const String _kShowTajweed = 'showTajweed';

  ThemeMode _themeMode = ThemeMode.light;
  double _fontScale = 1.0;
  String _arabicFont = 'Amiri';
  int _primaryColorIndex = 0;
  int _dailyGoal = 20;
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _showTajweed = true;

  // Getters
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  double get fontScale => _fontScale;
  String get arabicFont => _arabicFont;
  int get primaryColorIndex => _primaryColorIndex;
  int get dailyGoal => _dailyGoal;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get soundEnabled => _soundEnabled;
  bool get showTajweed => _showTajweed;

  /// تهيئة المزود بعد فتح صندوق Hive
  Future<void> init() async {
    _box = Hive.box(_boxName);
    _loadSettings();
  }

  void _loadSettings() {
    final themeStr = _box.get(_kThemeMode, defaultValue: 'light') as String;
    _themeMode = _parseThemeMode(themeStr);
    _fontScale = (_box.get(_kFontScale, defaultValue: 1.0) as num).toDouble();
    _arabicFont = _box.get(_kArabicFont, defaultValue: 'Amiri') as String;
    _primaryColorIndex = _box.get(_kPrimaryColorIndex, defaultValue: 0) as int;
    _dailyGoal = _box.get(_kDailyGoal, defaultValue: 20) as int;
    _notificationsEnabled =
        _box.get(_kNotificationsEnabled, defaultValue: true) as bool;
    _soundEnabled = _box.get(_kSoundEnabled, defaultValue: true) as bool;
    _showTajweed = _box.get(_kShowTajweed, defaultValue: true) as bool;
  }

  ThemeMode _parseThemeMode(String s) {
    switch (s) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }

  String _themeModeToString(ThemeMode m) {
    switch (m) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
      default:
        return 'light';
    }
  }

  // Setters
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _box.put(_kThemeMode, _themeModeToString(mode));
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    await setThemeMode(
      _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
    );
  }

  Future<void> setFontScale(double scale) async {
    _fontScale = scale.clamp(0.8, 1.6);
    await _box.put(_kFontScale, _fontScale);
    notifyListeners();
  }

  Future<void> setArabicFont(String font) async {
    _arabicFont = font;
    await _box.put(_kArabicFont, font);
    notifyListeners();
  }

  Future<void> setPrimaryColorIndex(int index) async {
    _primaryColorIndex = index;
    await _box.put(_kPrimaryColorIndex, index);
    notifyListeners();
  }

  Future<void> setDailyGoal(int goal) async {
    _dailyGoal = goal.clamp(5, 200);
    await _box.put(_kDailyGoal, _dailyGoal);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool v) async {
    _notificationsEnabled = v;
    await _box.put(_kNotificationsEnabled, v);
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool v) async {
    _soundEnabled = v;
    await _box.put(_kSoundEnabled, v);
    notifyListeners();
  }

  Future<void> setShowTajweed(bool v) async {
    _showTajweed = v;
    await _box.put(_kShowTajweed, v);
    notifyListeners();
  }

  /// ألوان رئيسية متاحة
  static const List<Map<String, dynamic>> availablePrimaryColors = [
    {'name': 'الفيروزي الأصيل', 'color': Color(0xFF0D6E6E)},
    {'name': 'الذهبي الفاخر', 'color': Color(0xFFD4A853)},
    {'name': 'الزمردي', 'color': Color(0xFF2ECC71)},
    {'name': 'البنفسجي الملكي', 'color': Color(0xFF6C5CE7)},
    {'name': 'العنابي', 'color': Color(0xFF8E3B3B)},
    {'name': 'الأزرق السماوي', 'color': Color(0xFF2980B9)},
  ];

  /// خطوط عربية متاحة
  static const List<Map<String, String>> availableArabicFonts = [
    {'name': 'أميري (تقليدي)', 'value': 'Amiri'},
    {'name': 'الخط العثماني', 'value': 'Uthmani'},
    {'name': 'الخط الافتراضي', 'value': 'Default'},
  ];
}
