import 'package:hive_flutter/hive_flutter.dart';
import '../models/memory_item.dart';
import '../models/category.dart';
import '../models/study_session.dart';

class StorageService {
  static const String memoryBoxName = 'memory_items';
  static const String categoryBoxName = 'categories';
  static const String sessionBoxName = 'study_sessions';
  static const String settingsBoxName = 'settings';

  static late Box<MemoryItem> _memoryBox;
  static late Box<Category> _categoryBox;
  static late Box<StudySession> _sessionBox;
  static late Box _settingsBox;

  /// تهيئة Hive والصناديق
  static Future<void> init() async {
    await Hive.initFlutter();

    // تسجيل المحولات
    Hive.registerAdapter(MemoryItemAdapter());
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(StudySessionAdapter());

    // فتح الصناديق
    _memoryBox = await Hive.openBox<MemoryItem>(memoryBoxName);
    _categoryBox = await Hive.openBox<Category>(categoryBoxName);
    _sessionBox = await Hive.openBox<StudySession>(sessionBoxName);
    _settingsBox = await Hive.openBox(settingsBoxName);

    // إنشاء فئات افتراضية إذا لم تكن موجودة
    if (_categoryBox.isEmpty) {
      await _createDefaultCategories();
    }
  }

  static Future<void> _createDefaultCategories() async {
    final defaults = [
      Category(id: 'quran', name: 'القرآن الكريم', icon: 'menu_book', colorIndex: 1, createdAt: DateTime.now()),
      Category(id: 'hadith', name: 'الأحاديث النبوية', icon: 'auto_stories', colorIndex: 5, createdAt: DateTime.now()),
      Category(id: 'vocab', name: 'المفردات واللغات', icon: 'translate', colorIndex: 2, createdAt: DateTime.now()),
      Category(id: 'study', name: 'المواد الدراسية', icon: 'school', colorIndex: 3, createdAt: DateTime.now()),
      Category(id: 'poetry', name: 'الشعر والأدب', icon: 'edit_note', colorIndex: 6, createdAt: DateTime.now()),
      Category(id: 'general', name: 'محفوظات عامة', icon: 'lightbulb', colorIndex: 4, createdAt: DateTime.now()),
    ];

    for (final cat in defaults) {
      await _categoryBox.put(cat.id, cat);
    }
  }

  // ========== إدارة المحفوظات ==========

  static Box<MemoryItem> get memoryBox => _memoryBox;

  static List<MemoryItem> getAllMemoryItems() {
    return _memoryBox.values.toList();
  }

  static List<MemoryItem> getItemsByCategory(String categoryId) {
    return _memoryBox.values
        .where((item) => item.category == categoryId)
        .toList();
  }

  static List<MemoryItem> getDueItems() {
    final now = DateTime.now();
    return _memoryBox.values
        .where((item) => item.nextReviewAt.isBefore(now))
        .toList()
      ..sort((a, b) => a.nextReviewAt.compareTo(b.nextReviewAt));
  }

  static List<MemoryItem> getFavoriteItems() {
    return _memoryBox.values
        .where((item) => item.isFavorite)
        .toList();
  }

  static Future<void> addMemoryItem(MemoryItem item) async {
    await _memoryBox.put(item.id, item);
  }

  static Future<void> updateMemoryItem(MemoryItem item) async {
    await item.save();
  }

  static Future<void> deleteMemoryItem(String id) async {
    await _memoryBox.delete(id);
  }

  // ========== إدارة الفئات ==========

  static Box<Category> get categoryBox => _categoryBox;

  static List<Category> getAllCategories() {
    return _categoryBox.values.toList();
  }

  static Category? getCategoryById(String id) {
    return _categoryBox.get(id);
  }

  static Future<void> addCategory(Category category) async {
    await _categoryBox.put(category.id, category);
  }

  static Future<void> deleteCategory(String id) async {
    await _categoryBox.delete(id);
  }

  // ========== إدارة جلسات الدراسة ==========

  static Box<StudySession> get sessionBox => _sessionBox;

  static List<StudySession> getAllSessions() {
    return _sessionBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  static List<StudySession> getSessionsByDate(DateTime date) {
    return _sessionBox.values.where((s) {
      return s.date.year == date.year &&
          s.date.month == date.month &&
          s.date.day == date.day;
    }).toList();
  }

  static Future<void> addSession(StudySession session) async {
    await _sessionBox.put(session.id, session);
  }

  // ========== الإعدادات ==========

  static int get streak => _settingsBox.get('streak', defaultValue: 0);
  static set streak(int val) => _settingsBox.put('streak', val);

  static DateTime? get lastStudyDate {
    final val = _settingsBox.get('lastStudyDate');
    return val is DateTime ? val : null;
  }

  static set lastStudyDate(DateTime? val) => _settingsBox.put('lastStudyDate', val);

  static int get totalStudyMinutes => _settingsBox.get('totalStudyMinutes', defaultValue: 0);
  static set totalStudyMinutes(int val) => _settingsBox.put('totalStudyMinutes', val);

  /// تحديث سلسلة الدراسة اليومية
  static void updateStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final last = lastStudyDate;

    if (last == null) {
      streak = 1;
    } else {
      final lastDay = DateTime(last.year, last.month, last.day);
      final diff = today.difference(lastDay).inDays;
      if (diff == 1) {
        streak = streak + 1;
      } else if (diff > 1) {
        streak = 1;
      }
    }
    lastStudyDate = now;
  }
}
