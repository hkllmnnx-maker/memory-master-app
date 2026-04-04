import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/quran_data.dart';
import '../../theme/app_theme.dart';
import '../../providers/memory_provider.dart';

/// شاشة جلسة الحفظ التفاعلية
/// تقنيات الحفظ المستخدمة:
/// 1. التكرار المتدرج
/// 2. التسميع الذاتي
/// 3. الإخفاء التدريجي
/// 4. الربط بالمعنى
class HifzSessionScreen extends StatefulWidget {
  final QuranSurah surah;
  final int startVerse;
  final int endVerse;

  const HifzSessionScreen({
    super.key,
    required this.surah,
    required this.startVerse,
    required this.endVerse,
  });

  @override
  State<HifzSessionScreen> createState() => _HifzSessionScreenState();
}

class _HifzSessionScreenState extends State<HifzSessionScreen>
    with TickerProviderStateMixin {
  int _currentStep = 0; // 0: قراءة, 1: ترديد, 2: إخفاء, 3: تسميع, 4: نتائج
  int _currentVerseIndex = 0;
  int _repetitionCount = 0;
  int _correctCount = 0;
  int _totalAttempts = 0;
  bool _showAnswer = false;
  double _hidePercentage = 0.0;
  late DateTime _startTime;
  Timer? _timer;
  int _elapsedSeconds = 0;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<String> _stepNames = [
    'القراءة والتدبر',
    'الترديد والتكرار',
    'الإخفاء التدريجي',
    'التسميع الذاتي',
    'النتائج',
  ];

  final List<IconData> _stepIcons = [
    Icons.menu_book_rounded,
    Icons.repeat_rounded,
    Icons.visibility_off_rounded,
    Icons.mic_rounded,
    Icons.emoji_events_rounded,
  ];

  int get _totalVerses => widget.endVerse - widget.startVerse + 1;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
    _fadeController.forward();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _elapsedSeconds++);
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 4) {
      _fadeController.reset();
      setState(() {
        _currentStep++;
        _currentVerseIndex = 0;
        _repetitionCount = 0;
        _showAnswer = false;
        _hidePercentage = _currentStep == 2 ? 0.3 : 0.0;
      });
      _fadeController.forward();
    }
  }

  void _nextVerse() {
    if (_currentVerseIndex < _totalVerses - 1) {
      _fadeController.reset();
      setState(() {
        _currentVerseIndex++;
        _repetitionCount = 0;
        _showAnswer = false;
      });
      _fadeController.forward();
    } else {
      _nextStep();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.warmWhite, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              _buildStepIndicator(),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildCurrentStepContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          InkWell(
            onTap: () => _showExitDialog(),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.close_rounded, size: 20),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.deepTeal.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer_outlined, size: 16, color: AppTheme.deepTeal),
                const SizedBox(width: 4),
                Text(
                  _formatTime(_elapsedSeconds),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.deepTeal,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryGold.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'سورة ${widget.surah.name}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.darkGold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: List.generate(5, (index) {
              final isActive = index == _currentStep;
              final isCompleted = index < _currentStep;
              return Expanded(
                child: Row(
                  children: [
                    if (index > 0)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isCompleted ? AppTheme.deepTeal : AppTheme.divider,
                        ),
                      ),
                    Container(
                      width: isActive ? 36 : 28,
                      height: isActive ? 36 : 28,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppTheme.deepTeal
                            : isCompleted
                                ? AppTheme.deepTeal
                                : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isActive || isCompleted
                              ? AppTheme.deepTeal
                              : AppTheme.divider,
                          width: 2,
                        ),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: AppTheme.deepTeal.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        isCompleted ? Icons.check : _stepIcons[index],
                        size: isActive ? 18 : 14,
                        color: isActive || isCompleted ? Colors.white : AppTheme.textLight,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            _stepNames[_currentStep],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.deepTeal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildReadingStep();
      case 1:
        return _buildRepetitionStep();
      case 2:
        return _buildHidingStep();
      case 3:
        return _buildRecitationStep();
      case 4:
        return _buildResultsStep();
      default:
        return const SizedBox();
    }
  }

  // الخطوة 1: القراءة والتدبر
  Widget _buildReadingStep() {
    final verseNum = widget.startVerse + _currentVerseIndex;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.deepTeal.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: AppTheme.deepTeal),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'اقرأ الآية بتدبر وتركيز، كرر القراءة 3 مرات على الأقل',
                    style: TextStyle(fontSize: 12, color: AppTheme.deepTeal),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // بطاقة الآية
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.primaryGold.withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryGold.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.deepNavy.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'الآية $verseNum',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.deepTeal,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Placeholder for verse text - in real app, load from Quran API
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.parchment,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _getVerseDisplay(verseNum),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                      height: 2.2,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'تكرار القراءة: $_repetitionCount / 3',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() => _repetitionCount++);
                  },
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  label: const Text('كرر القراءة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.cream,
                    foregroundColor: AppTheme.deepTeal,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _repetitionCount >= 3 ? _nextVerse : null,
                  icon: const Icon(Icons.arrow_back_rounded, size: 20),
                  label: Text(
                    _currentVerseIndex < _totalVerses - 1 ? 'الآية التالية' : 'المرحلة التالية',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.deepTeal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // الخطوة 2: الترديد والتكرار
  Widget _buildRepetitionStep() {
    final verseNum = widget.startVerse + _currentVerseIndex;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryGold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.record_voice_over, size: 18, color: AppTheme.darkGold),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'ردد الآية بصوت مرتفع مع التجويد، كرر 5 مرات',
                    style: TextStyle(fontSize: 12, color: AppTheme.darkGold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.deepNavy.withValues(alpha: 0.03),
                  AppTheme.deepTeal.withValues(alpha: 0.03),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.deepTeal.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Text(
                  'الآية $verseNum',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.deepTeal,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _getVerseDisplay(verseNum),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                      height: 2.0,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Repetition counter
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    return Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: i < _repetitionCount
                            ? AppTheme.deepTeal
                            : AppTheme.deepTeal.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          '${i + 1}',
                          style: TextStyle(
                            color: i < _repetitionCount ? Colors.white : AppTheme.textGrey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() => _repetitionCount++);
                  },
                  icon: const Icon(Icons.add_circle_outline, size: 20),
                  label: const Text('رددت الآية'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.cream,
                    foregroundColor: AppTheme.deepTeal,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _repetitionCount >= 5 ? _nextVerse : null,
                  icon: const Icon(Icons.arrow_back_rounded, size: 20),
                  label: Text(
                    _currentVerseIndex < _totalVerses - 1 ? 'الآية التالية' : 'المرحلة التالية',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.deepTeal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // الخطوة 3: الإخفاء التدريجي
  Widget _buildHidingStep() {
    final verseNum = widget.startVerse + _currentVerseIndex;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.softPurple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.visibility_off, size: 18, color: AppTheme.softPurple),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'نسبة الإخفاء: ${(_hidePercentage * 100).toInt()}% - حاول تذكر الكلمات المخفية',
                    style: const TextStyle(fontSize: 12, color: AppTheme.softPurple),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.softPurple.withValues(alpha: 0.2)),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.softPurple.withValues(alpha: 0.05),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'الآية $verseNum',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.softPurple,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _getHiddenVerseDisplay(verseNum, _hidePercentage),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                    height: 2.0,
                  ),
                ),
                const SizedBox(height: 20),
                // Hide percentage slider
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: AppTheme.softPurple,
                    inactiveTrackColor: AppTheme.softPurple.withValues(alpha: 0.2),
                    thumbColor: AppTheme.softPurple,
                    overlayColor: AppTheme.softPurple.withValues(alpha: 0.1),
                  ),
                  child: Slider(
                    value: _hidePercentage,
                    onChanged: (val) => setState(() => _hidePercentage = val),
                    divisions: 10,
                    label: '${(_hidePercentage * 100).toInt()}%',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (_showAnswer)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.emerald.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.emerald.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  const Text(
                    'الآية كاملة:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.emerald,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getVerseDisplay(verseNum),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppTheme.textDark,
                      height: 1.8,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => _showAnswer = !_showAnswer),
                  icon: Icon(
                    _showAnswer ? Icons.visibility_off : Icons.visibility,
                    size: 20,
                  ),
                  label: Text(_showAnswer ? 'إخفاء' : 'إظهار الإجابة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.cream,
                    foregroundColor: AppTheme.softPurple,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_hidePercentage < 1.0) {
                      setState(() {
                        _hidePercentage = (_hidePercentage + 0.2).clamp(0.0, 1.0);
                        _showAnswer = false;
                      });
                    } else {
                      _nextVerse();
                    }
                  },
                  icon: const Icon(Icons.arrow_back_rounded, size: 20),
                  label: Text(_hidePercentage >= 1.0
                      ? (_currentVerseIndex < _totalVerses - 1 ? 'الآية التالية' : 'المرحلة التالية')
                      : 'زد الإخفاء'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.softPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // الخطوة 4: التسميع الذاتي
  Widget _buildRecitationStep() {
    final verseNum = widget.startVerse + _currentVerseIndex;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.emerald.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.mic, size: 18, color: AppTheme.emerald),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'سمّع الآية من حفظك ثم تحقق من صحتها',
                    style: TextStyle(fontSize: 12, color: AppTheme.emerald),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // بطاقة التسميع
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.emerald.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppTheme.emerald.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.psychology_rounded,
                    color: AppTheme.emerald,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'الآية $verseNum',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.emerald,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'حاول تسميع الآية من حفظك',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textGrey,
                  ),
                ),
                const SizedBox(height: 20),
                if (_showAnswer)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.parchment,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _getVerseDisplay(verseNum),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textDark,
                        height: 2.0,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (!_showAnswer)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => setState(() => _showAnswer = true),
                icon: const Icon(Icons.visibility_rounded, size: 20),
                label: const Text('تحقق من الإجابة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.cream,
                  foregroundColor: AppTheme.emerald,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          if (_showAnswer) ...[
            const Text(
              'كيف كان تسميعك؟',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildRecitationRating('لم أتذكر', Icons.close_rounded, AppTheme.coral, false),
                const SizedBox(width: 8),
                _buildRecitationRating('بأخطاء', Icons.warning_amber_rounded, AppTheme.warmOrange, false),
                const SizedBox(width: 8),
                _buildRecitationRating('بتردد', Icons.swap_horiz_rounded, AppTheme.primaryGold, true),
                const SizedBox(width: 8),
                _buildRecitationRating('ممتاز', Icons.check_circle_rounded, AppTheme.emerald, true),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecitationRating(String label, IconData icon, Color color, bool isCorrect) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _totalAttempts++;
            if (isCorrect) _correctCount++;
            _showAnswer = false;
          });
          _nextVerse();
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // الخطوة 5: النتائج
  Widget _buildResultsStep() {
    final accuracy = _totalAttempts > 0 ? (_correctCount / _totalAttempts * 100) : 100.0;

    // Save session
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<MemoryProvider>().saveStudySession(
          totalCards: _totalVerses,
          correctAnswers: _correctCount,
          durationSeconds: _elapsedSeconds,
          category: 'quran',
        );
      }
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: accuracy >= 70
                  ? AppTheme.emerald.withValues(alpha: 0.15)
                  : AppTheme.primaryGold.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              accuracy >= 70 ? Icons.emoji_events_rounded : Icons.trending_up_rounded,
              color: accuracy >= 70 ? AppTheme.emerald : AppTheme.primaryGold,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            accuracy >= 80 ? 'ما شاء الله! حفظ ممتاز' : accuracy >= 60 ? 'جيد، واصل المراجعة' : 'لا بأس، كرر الحفظ',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'سورة ${widget.surah.name} - الآيات ${widget.startVerse} إلى ${widget.endVerse}',
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textGrey,
            ),
          ),
          const SizedBox(height: 28),
          // Stats cards
          Row(
            children: [
              _buildResultCard('الدقة', '${accuracy.toStringAsFixed(0)}%', Icons.gps_fixed_rounded, AppTheme.emerald),
              const SizedBox(width: 12),
              _buildResultCard('الآيات', '$_totalVerses', Icons.format_list_numbered_rounded, AppTheme.deepTeal),
              const SizedBox(width: 12),
              _buildResultCard('الوقت', _formatTime(_elapsedSeconds), Icons.timer_rounded, AppTheme.softPurple),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.home_rounded, size: 20),
              label: const Text('العودة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.deepTeal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppTheme.textGrey),
            ),
          ],
        ),
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('الخروج من جلسة الحفظ؟', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('سيتم فقدان تقدمك في هذه الجلسة', textAlign: TextAlign.center),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('متابعة')),
            ElevatedButton(
              onPressed: () { Navigator.pop(ctx); Navigator.pop(context); },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.coral),
              child: const Text('خروج'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _getVerseDisplay(int verseNum) {
    // In a real app, this would load actual Quran text from API/database
    // For now, showing a representative display
    return 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ ﴿$verseNum﴾';
  }

  String _getHiddenVerseDisplay(int verseNum, double hidePercent) {
    final text = _getVerseDisplay(verseNum);
    final words = text.split(' ');
    final hideCount = (words.length * hidePercent).round();

    final buffer = StringBuffer();
    for (int i = 0; i < words.length; i++) {
      if (i > 0) buffer.write(' ');
      if (i < hideCount) {
        buffer.write('___');
      } else {
        buffer.write(words[i]);
      }
    }
    return buffer.toString();
  }
}
