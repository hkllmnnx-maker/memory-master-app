import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/memory_provider.dart';
import '../../models/memory_item.dart';
import '../../theme/app_theme.dart';

/// شاشة المسابقة السريعة: عرض عنوان ويجب على المستخدم تذكر المحتوى
class QuickQuizScreen extends StatefulWidget {
  const QuickQuizScreen({super.key});

  @override
  State<QuickQuizScreen> createState() => _QuickQuizScreenState();
}

class _QuickQuizScreenState extends State<QuickQuizScreen> {
  late List<MemoryItem> _quizItems;
  int _currentIndex = 0;
  int _correctCount = 0;
  int _wrongCount = 0;
  bool _showAnswer = false;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _prepareQuiz();
  }

  void _prepareQuiz() {
    final all = context.read<MemoryProvider>().items.toList();
    all.shuffle(Random());
    _quizItems = all.take(10).toList();
    _currentIndex = 0;
    _correctCount = 0;
    _wrongCount = 0;
    _showAnswer = false;
    _started = false;
  }

  void _next(bool correct) {
    setState(() {
      if (correct) {
        _correctCount++;
      } else {
        _wrongCount++;
      }
      if (_currentIndex < _quizItems.length - 1) {
        _currentIndex++;
        _showAnswer = false;
      } else {
        _showFinalResult();
      }
    });
  }

  void _showFinalResult() {
    final accuracy = _quizItems.isEmpty
        ? 0
        : ((_correctCount / _quizItems.length) * 100).toInt();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Row(
            children: [
              Icon(
                accuracy >= 70
                    ? Icons.emoji_events_rounded
                    : Icons.tips_and_updates_rounded,
                color: accuracy >= 70
                    ? AppTheme.primaryGold
                    : AppTheme.deepTeal,
                size: 32,
              ),
              const SizedBox(width: 10),
              const Text('انتهت المسابقة!',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _resultRow('الإجابات الصحيحة', _correctCount.toString(),
                  AppTheme.emerald),
              const SizedBox(height: 8),
              _resultRow('الإجابات الخاطئة', _wrongCount.toString(),
                  AppTheme.coral),
              const SizedBox(height: 8),
              _resultRow('الدقة', '$accuracy%',
                  accuracy >= 70 ? AppTheme.emerald : AppTheme.warmOrange),
              const SizedBox(height: 16),
              Text(
                accuracy >= 90
                    ? 'ممتاز! أنت متقن 🌟'
                    : accuracy >= 70
                        ? 'أحسنت، تحتاج مراجعة قليلة'
                        : accuracy >= 50
                            ? 'جيد، واصل المراجعة'
                            : 'تحتاج للمزيد من المراجعة',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('خروج'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() => _prepareQuiz());
              },
              child: const Text('إعادة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('مسابقة الحفظ',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: _quizItems.isEmpty
            ? _buildEmpty(isDark)
            : !_started
                ? _buildIntro(isDark)
                : _buildQuizContent(isDark),
      ),
    );
  }

  Widget _buildEmpty(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkCardBg : AppTheme.cream,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.quiz_outlined,
                  size: 40, color: AppTheme.deepTeal),
            ),
            const SizedBox(height: 20),
            Text(
              'لا توجد محفوظات كافية',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppTheme.darkTextPrimary
                    : AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'أضف محفوظات أولاً لتتمكن من بدء المسابقة',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? AppTheme.darkTextSecondary
                    : AppTheme.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntro(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryGold.withValues(alpha: 0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(Icons.quiz_rounded,
                color: Colors.white, size: 56),
          ),
          const SizedBox(height: 24),
          Text(
            'جاهز للتحدي؟',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: isDark ? AppTheme.darkTextPrimary : AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'سنعرض عليك ${_quizItems.length} محفوظات بشكل عشوائي. تأمل العنوان وحاول تذكر المحتوى ثم تقيّم نفسك.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.8,
              color: isDark
                  ? AppTheme.darkTextSecondary
                  : AppTheme.textMedium,
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => setState(() => _started = true),
              icon: const Icon(Icons.play_arrow_rounded, size: 28),
              label: const Text(
                'ابدأ المسابقة',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizContent(bool isDark) {
    final item = _quizItems[_currentIndex];
    final progress = (_currentIndex + 1) / _quizItems.length;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress
          Row(
            children: [
              Text(
                '${_currentIndex + 1} / ${_quizItems.length}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppTheme.darkTextSecondary
                      : AppTheme.textGrey,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.emerald.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_rounded,
                        color: AppTheme.emerald, size: 14),
                    const SizedBox(width: 2),
                    Text('$_correctCount',
                        style: const TextStyle(
                            color: AppTheme.emerald,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.coral.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.close_rounded,
                        color: AppTheme.coral, size: 14),
                    const SizedBox(width: 2),
                    Text('$_wrongCount',
                        style: const TextStyle(
                            color: AppTheme.coral,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor:
                  isDark ? AppTheme.darkDivider : AppTheme.cream,
              valueColor: const AlwaysStoppedAnimation(AppTheme.deepTeal),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkCardBg : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? AppTheme.darkDivider
                        : AppTheme.divider,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.deepTeal.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.title_rounded,
                              color: AppTheme.deepTeal, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'العنوان',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppTheme.darkTextSecondary
                                : AppTheme.textGrey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppTheme.darkTextPrimary
                            : AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (!_showAnswer)
                      Center(
                        child: TextButton.icon(
                          onPressed: () =>
                              setState(() => _showAnswer = true),
                          icon: const Icon(Icons.visibility_rounded),
                          label: const Text('أظهر الإجابة'),
                        ),
                      )
                    else ...[
                      const Divider(),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGold
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.article_rounded,
                                color: AppTheme.primaryGold, size: 18),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'المحتوى',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppTheme.darkTextSecondary
                                  : AppTheme.textGrey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item.content,
                        style: TextStyle(
                          fontSize: 17,
                          height: 2.0,
                          fontFamily: 'Amiri',
                          color: isDark
                              ? AppTheme.darkTextPrimary
                              : AppTheme.textDark,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (_showAnswer) ...[
            const SizedBox(height: 12),
            Text(
              'كيف كانت إجابتك؟',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppTheme.darkTextSecondary
                    : AppTheme.textGrey,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _next(false),
                    icon: const Icon(Icons.close_rounded),
                    label: const Text('لم أتذكر'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      foregroundColor: AppTheme.coral,
                      side: const BorderSide(color: AppTheme.coral),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _next(true),
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('تذكرتُه'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.emerald,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
