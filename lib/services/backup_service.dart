import 'dart:convert';
import '../models/memory_item.dart';
import '../models/category.dart';
import '../models/study_session.dart';
import 'storage_service.dart';

/// خدمة النسخ الاحتياطي (تصدير/استيراد) للبيانات
class BackupService {
  /// تصدير البيانات كسلسلة JSON
  static String exportData() {
    final items = StorageService.getAllMemoryItems();
    final categories = StorageService.getAllCategories();
    final sessions = StorageService.getAllSessions();

    final data = {
      'version': '1.1.0',
      'exportedAt': DateTime.now().toIso8601String(),
      'metadata': {
        'streak': StorageService.streak,
        'totalStudyMinutes': StorageService.totalStudyMinutes,
      },
      'items': items.map((i) => _itemToJson(i)).toList(),
      'categories': categories.map((c) => _categoryToJson(c)).toList(),
      'sessions': sessions.map((s) => _sessionToJson(s)).toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  /// استيراد البيانات من JSON
  static Future<ImportResult> importData(String jsonStr) async {
    try {
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;

      int itemsCount = 0;
      int categoriesCount = 0;
      int sessionsCount = 0;

      // Import categories
      if (data['categories'] is List) {
        for (final c in data['categories'] as List) {
          final cat = _jsonToCategory(c as Map<String, dynamic>);
          await StorageService.addCategory(cat);
          categoriesCount++;
        }
      }

      // Import items
      if (data['items'] is List) {
        for (final i in data['items'] as List) {
          final item = _jsonToItem(i as Map<String, dynamic>);
          await StorageService.addMemoryItem(item);
          itemsCount++;
        }
      }

      // Import sessions
      if (data['sessions'] is List) {
        for (final s in data['sessions'] as List) {
          final session = _jsonToSession(s as Map<String, dynamic>);
          await StorageService.addSession(session);
          sessionsCount++;
        }
      }

      // Import metadata
      if (data['metadata'] is Map) {
        final meta = data['metadata'] as Map<String, dynamic>;
        if (meta['streak'] is int) {
          StorageService.streak = meta['streak'] as int;
        }
        if (meta['totalStudyMinutes'] is int) {
          StorageService.totalStudyMinutes =
              meta['totalStudyMinutes'] as int;
        }
      }

      return ImportResult(
        success: true,
        itemsCount: itemsCount,
        categoriesCount: categoriesCount,
        sessionsCount: sessionsCount,
      );
    } catch (e) {
      return ImportResult(
        success: false,
        error: 'خطأ في قراءة البيانات: $e',
      );
    }
  }

  static Map<String, dynamic> _itemToJson(MemoryItem i) => {
        'id': i.id,
        'title': i.title,
        'content': i.content,
        'category': i.category,
        'createdAt': i.createdAt.toIso8601String(),
        'nextReviewAt': i.nextReviewAt.toIso8601String(),
        'repetitionLevel': i.repetitionLevel,
        'totalReviews': i.totalReviews,
        'correctReviews': i.correctReviews,
        'easeFactor': i.easeFactor,
        'hints': i.hints,
        'isFavorite': i.isFavorite,
        'colorIndex': i.colorIndex,
      };

  static MemoryItem _jsonToItem(Map<String, dynamic> j) => MemoryItem(
        id: j['id'] as String,
        title: j['title'] as String,
        content: j['content'] as String,
        category: j['category'] as String,
        createdAt: DateTime.parse(j['createdAt'] as String),
        nextReviewAt: DateTime.parse(j['nextReviewAt'] as String),
        repetitionLevel: (j['repetitionLevel'] as int?) ?? 0,
        totalReviews: (j['totalReviews'] as int?) ?? 0,
        correctReviews: (j['correctReviews'] as int?) ?? 0,
        easeFactor: (j['easeFactor'] as num?)?.toDouble() ?? 2.5,
        hints: ((j['hints'] as List?) ?? []).map((e) => e.toString()).toList(),
        isFavorite: (j['isFavorite'] as bool?) ?? false,
        colorIndex: (j['colorIndex'] as int?) ?? 0,
      );

  static Map<String, dynamic> _categoryToJson(Category c) => {
        'id': c.id,
        'name': c.name,
        'icon': c.icon,
        'colorIndex': c.colorIndex,
        'createdAt': c.createdAt.toIso8601String(),
      };

  static Category _jsonToCategory(Map<String, dynamic> j) => Category(
        id: j['id'] as String,
        name: j['name'] as String,
        icon: j['icon'] as String,
        colorIndex: (j['colorIndex'] as int?) ?? 0,
        createdAt: DateTime.parse(j['createdAt'] as String),
      );

  static Map<String, dynamic> _sessionToJson(StudySession s) => {
        'id': s.id,
        'date': s.date.toIso8601String(),
        'totalCards': s.totalCards,
        'correctAnswers': s.correctAnswers,
        'durationSeconds': s.durationSeconds,
        'category': s.category,
      };

  static StudySession _jsonToSession(Map<String, dynamic> j) => StudySession(
        id: j['id'] as String,
        date: DateTime.parse(j['date'] as String),
        totalCards: (j['totalCards'] as int?) ?? 0,
        correctAnswers: (j['correctAnswers'] as int?) ?? 0,
        durationSeconds: (j['durationSeconds'] as int?) ?? 0,
        category: j['category'] as String? ?? 'general',
      );
}

class ImportResult {
  final bool success;
  final int itemsCount;
  final int categoriesCount;
  final int sessionsCount;
  final String? error;

  ImportResult({
    required this.success,
    this.itemsCount = 0,
    this.categoriesCount = 0,
    this.sessionsCount = 0,
    this.error,
  });
}
