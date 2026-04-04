import 'package:flutter/foundation.dart' hide Category;
import 'package:uuid/uuid.dart';
import '../models/memory_item.dart';
import '../models/category.dart';
import '../models/study_session.dart';
import '../services/storage_service.dart';
import '../services/spaced_repetition_service.dart';

class MemoryProvider extends ChangeNotifier {
  List<MemoryItem> _items = [];
  List<Category> _categories = [];
  List<MemoryItem> _dueItems = [];
  String _selectedCategory = 'all';

  // Getters
  List<MemoryItem> get items => _items;
  List<Category> get categories => _categories;
  List<MemoryItem> get dueItems => _dueItems;
  String get selectedCategory => _selectedCategory;

  int get totalItems => _items.length;
  int get dueCount => _dueItems.length;
  int get masteredCount => _items.where((i) => i.repetitionLevel >= 6).length;
  int get streak => StorageService.streak;

  double get overallProgress {
    if (_items.isEmpty) return 0;
    double totalMastery = 0;
    for (final item in _items) {
      totalMastery += item.masteryPercentage;
    }
    return totalMastery / _items.length;
  }

  List<MemoryItem> get filteredItems {
    if (_selectedCategory == 'all') return _items;
    if (_selectedCategory == 'favorites') return StorageService.getFavoriteItems();
    if (_selectedCategory == 'due') return _dueItems;
    return StorageService.getItemsByCategory(_selectedCategory);
  }

  /// تحميل البيانات من التخزين
  void loadData() {
    _items = StorageService.getAllMemoryItems();
    _categories = StorageService.getAllCategories();
    _dueItems = StorageService.getDueItems();
    notifyListeners();
  }

  /// تعيين الفئة المحددة
  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// إضافة محفوظ جديد
  Future<void> addItem({
    required String title,
    required String content,
    required String category,
    List<String> hints = const [],
    int colorIndex = 0,
  }) async {
    final item = MemoryItem(
      id: const Uuid().v4(),
      title: title,
      content: content,
      category: category,
      createdAt: DateTime.now(),
      nextReviewAt: DateTime.now(), // مراجعة فورية
      hints: hints,
      colorIndex: colorIndex,
    );

    await StorageService.addMemoryItem(item);
    loadData();
  }

  /// تحديث محفوظ
  Future<void> updateItem(MemoryItem item) async {
    await StorageService.updateMemoryItem(item);
    loadData();
  }

  /// حذف محفوظ
  Future<void> deleteItem(String id) async {
    await StorageService.deleteMemoryItem(id);
    loadData();
  }

  /// تبديل المفضلة
  Future<void> toggleFavorite(MemoryItem item) async {
    item.isFavorite = !item.isFavorite;
    await StorageService.updateMemoryItem(item);
    loadData();
  }

  /// مراجعة محفوظ (التكرار المتباعد)
  Future<void> reviewItem(MemoryItem item, int quality) async {
    SpacedRepetitionService.reviewItem(item, quality);
    await StorageService.updateMemoryItem(item);
    loadData();
  }

  /// حفظ جلسة دراسة
  Future<void> saveStudySession({
    required int totalCards,
    required int correctAnswers,
    required int durationSeconds,
    required String category,
  }) async {
    final session = StudySession(
      id: const Uuid().v4(),
      date: DateTime.now(),
      totalCards: totalCards,
      correctAnswers: correctAnswers,
      durationSeconds: durationSeconds,
      category: category,
    );

    await StorageService.addSession(session);
    StorageService.updateStreak();
    StorageService.totalStudyMinutes =
        StorageService.totalStudyMinutes + (durationSeconds ~/ 60);
    loadData();
  }

  /// إضافة فئة جديدة
  Future<void> addCategory({
    required String name,
    required String icon,
    required int colorIndex,
  }) async {
    final category = Category(
      id: const Uuid().v4(),
      name: name,
      icon: icon,
      colorIndex: colorIndex,
      createdAt: DateTime.now(),
    );

    await StorageService.addCategory(category);
    loadData();
  }

  /// حذف فئة
  Future<void> deleteCategory(String id) async {
    await StorageService.deleteCategory(id);
    loadData();
  }

  /// الحصول على إحصائيات اليوم
  Map<String, dynamic> getTodayStats() {
    final today = DateTime.now();
    final sessions = StorageService.getSessionsByDate(today);

    int totalCards = 0;
    int correctCards = 0;
    int totalDuration = 0;

    for (final s in sessions) {
      totalCards += s.totalCards;
      correctCards += s.correctAnswers;
      totalDuration += s.durationSeconds;
    }

    return {
      'sessions': sessions.length,
      'totalCards': totalCards,
      'correctCards': correctCards,
      'duration': totalDuration,
      'accuracy': totalCards > 0 ? (correctCards / totalCards * 100) : 0.0,
    };
  }

  /// الحصول على إحصائيات الأسبوع
  List<Map<String, dynamic>> getWeeklyStats() {
    final now = DateTime.now();
    final List<Map<String, dynamic>> weekStats = [];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final sessions = StorageService.getSessionsByDate(date);

      int totalCards = 0;
      int correctCards = 0;

      for (final s in sessions) {
        totalCards += s.totalCards;
        correctCards += s.correctAnswers;
      }

      weekStats.add({
        'date': date,
        'dayName': _getArabicDayName(date.weekday),
        'totalCards': totalCards,
        'correctCards': correctCards,
        'sessions': sessions.length,
      });
    }

    return weekStats;
  }

  String _getArabicDayName(int weekday) {
    const days = ['الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
    return days[weekday - 1];
  }
}
