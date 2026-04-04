import 'package:hive/hive.dart';

part 'memory_item.g.dart';

@HiveType(typeId: 0)
class MemoryItem extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  String category;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime nextReviewAt;

  @HiveField(6)
  int repetitionLevel; // مستوى التكرار (0-7)

  @HiveField(7)
  int totalReviews;

  @HiveField(8)
  int correctReviews;

  @HiveField(9)
  double easeFactor; // عامل السهولة للتكرار المتباعد

  @HiveField(10)
  List<String> hints; // تلميحات للمساعدة

  @HiveField(11)
  bool isFavorite;

  @HiveField(12)
  String? audioPath; // مسار الصوت إن وجد

  @HiveField(13)
  int colorIndex; // لون البطاقة

  MemoryItem({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.createdAt,
    required this.nextReviewAt,
    this.repetitionLevel = 0,
    this.totalReviews = 0,
    this.correctReviews = 0,
    this.easeFactor = 2.5,
    this.hints = const [],
    this.isFavorite = false,
    this.audioPath,
    this.colorIndex = 0,
  });

  // حساب نسبة الإتقان
  double get masteryPercentage {
    if (totalReviews == 0) return 0;
    return (correctReviews / totalReviews * 100).clamp(0, 100);
  }

  // هل حان وقت المراجعة؟
  bool get isDueForReview => DateTime.now().isAfter(nextReviewAt);

  // مستوى الإتقان كنص
  String get masteryLevelText {
    if (repetitionLevel <= 1) return 'مبتدئ';
    if (repetitionLevel <= 3) return 'متعلم';
    if (repetitionLevel <= 5) return 'متقدم';
    return 'متقن';
  }

  // لون مستوى الإتقان
  int get masteryColorIndex {
    if (repetitionLevel <= 1) return 0; // أحمر
    if (repetitionLevel <= 3) return 3; // أصفر
    if (repetitionLevel <= 5) return 1; // أزرق فاتح
    return 5; // أخضر
  }
}
