import '../models/memory_item.dart';

/// خدمة التكرار المتباعد - خوارزمية SM-2 المحسنة
/// تعتمد على البحث العلمي لـ Piotr Wozniak
class SpacedRepetitionService {
  /// الفترات بالأيام لكل مستوى تكرار
  static const List<int> _intervals = [
    0,   // المستوى 0: فوري (نفس اليوم)
    1,   // المستوى 1: بعد يوم واحد
    3,   // المستوى 2: بعد 3 أيام
    7,   // المستوى 3: بعد أسبوع
    14,  // المستوى 4: بعد أسبوعين
    30,  // المستوى 5: بعد شهر
    60,  // المستوى 6: بعد شهرين
    120, // المستوى 7: بعد 4 أشهر
  ];

  /// تحديث عنصر بعد المراجعة
  /// [quality] جودة الإجابة من 0 إلى 5
  /// 0 = لم أتذكر أبداً
  /// 1 = تذكرت بصعوبة شديدة
  /// 2 = تذكرت بصعوبة
  /// 3 = تذكرت بعد تفكير
  /// 4 = تذكرت بسهولة
  /// 5 = تذكرت فوراً
  static MemoryItem reviewItem(MemoryItem item, int quality) {
    item.totalReviews++;

    if (quality >= 3) {
      // إجابة صحيحة
      item.correctReviews++;

      if (quality == 5) {
        // ممتاز - ارفع مستويين
        item.repetitionLevel = (item.repetitionLevel + 2).clamp(0, 7);
      } else {
        // جيد - ارفع مستوى واحد
        item.repetitionLevel = (item.repetitionLevel + 1).clamp(0, 7);
      }

      // تحديث عامل السهولة
      item.easeFactor = item.easeFactor +
          (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
      if (item.easeFactor < 1.3) item.easeFactor = 1.3;
    } else {
      // إجابة خاطئة - أعد المستوى
      if (quality == 0) {
        item.repetitionLevel = 0;
      } else {
        item.repetitionLevel = (item.repetitionLevel - 1).clamp(0, 7);
      }
      item.easeFactor = (item.easeFactor - 0.2).clamp(1.3, 3.0);
    }

    // حساب الموعد التالي
    final intervalDays = _getInterval(item.repetitionLevel, item.easeFactor);
    item.nextReviewAt = DateTime.now().add(Duration(days: intervalDays));

    return item;
  }

  static int _getInterval(int level, double easeFactor) {
    if (level >= _intervals.length) return 180;
    final baseInterval = _intervals[level];
    return (baseInterval * easeFactor / 2.5).round();
  }

  /// الحصول على نص وصف الفترة القادمة
  static String getNextReviewText(MemoryItem item) {
    final now = DateTime.now();
    final diff = item.nextReviewAt.difference(now);

    if (diff.isNegative) return 'حان وقت المراجعة!';
    if (diff.inMinutes < 60) return 'بعد ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'بعد ${diff.inHours} ساعة';
    if (diff.inDays == 1) return 'غداً';
    if (diff.inDays < 7) return 'بعد ${diff.inDays} أيام';
    if (diff.inDays < 30) return 'بعد ${(diff.inDays / 7).round()} أسابيع';
    return 'بعد ${(diff.inDays / 30).round()} أشهر';
  }

  /// الحصول على نصائح للحفظ حسب المستوى
  static String getMemorizationTip(int level) {
    final tips = [
      'اقرأ المحفوظ بصوت عالٍ عدة مرات 🎤',
      'حاول كتابة المحفوظ من ذاكرتك ✍️',
      'اربط المحفوظ بصورة ذهنية 🧠',
      'علّم غيرك ما حفظته 👨‍🏫',
      'راجع قبل النوم لتثبيت الذاكرة 🌙',
      'استخدم تقنية قصر الذاكرة 🏰',
      'اربط المعلومات بقصة متسلسلة 📖',
      'أنت متقن! استمر في المراجعة الدورية ⭐',
    ];
    return tips[level.clamp(0, 7)];
  }
}
