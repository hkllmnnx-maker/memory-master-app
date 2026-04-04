import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../models/memory_item.dart';
import '../providers/memory_provider.dart';
import '../theme/app_theme.dart';
import 'dart:math';

class ReviewScreen extends StatefulWidget {
  final List<MemoryItem> items;

  const ReviewScreen({super.key, required this.items});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool _showContent = false;
  int _correctAnswers = 0;
  int _showHintIndex = -1;
  late DateTime _startTime;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  late ConfettiController _confettiController;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  MemoryItem get _currentItem => widget.items[_currentIndex];

  void _flipCard() {
    setState(() => _showContent = !_showContent);
    if (_showContent) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
  }

  void _rateAnswer(int quality) {
    if (quality >= 3) _correctAnswers++;

    context.read<MemoryProvider>().reviewItem(_currentItem, quality);

    if (_currentIndex < widget.items.length - 1) {
      setState(() {
        _currentIndex++;
        _showContent = false;
        _showHintIndex = -1;
        _flipController.reset();
      });
    } else {
      // انتهت المراجعة
      _finishReview();
    }
  }

  void _finishReview() {
    final duration = DateTime.now().difference(_startTime).inSeconds;

    context.read<MemoryProvider>().saveStudySession(
      totalCards: widget.items.length,
      correctAnswers: _correctAnswers,
      durationSeconds: duration,
      category: 'mixed',
    );

    setState(() => _isFinished = true);
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    if (_isFinished) return _buildResultScreen();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.bgLight, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              _buildProgressBar(),
              Expanded(child: _buildCardArea()),
              if (_showContent) _buildRatingButtons(),
              const SizedBox(height: 20),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => _showExitDialog(),
            icon: const Icon(Icons.close_rounded),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey.shade200,
            ),
          ),
          Text(
            '${_currentIndex + 1} / ${widget.items.length}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.mintGreen.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: AppTheme.mintGreen, size: 18),
                const SizedBox(width: 4),
                Text(
                  '$_correctAnswers',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.mintGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: LinearProgressIndicator(
          value: (_currentIndex + 1) / widget.items.length,
          minHeight: 8,
          backgroundColor: Colors.grey.shade200,
          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.teal),
        ),
      ),
    );
  }

  Widget _buildCardArea() {
    final color = AppTheme.categoryColors[
        _currentItem.colorIndex % AppTheme.categoryColors.length];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _flipCard,
              child: AnimatedBuilder(
                animation: _flipAnimation,
                builder: (context, child) {
                  final angle = _flipAnimation.value * pi;
                  final showBack = angle > pi / 2;

                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle),
                    child: showBack
                        ? Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..rotateY(pi),
                            child: _buildBackCard(color),
                          )
                        : _buildFrontCard(color),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (!_showContent) ...[
            // التلميحات
            if (_currentItem.hints.isNotEmpty)
              _buildHintsArea(),
            const SizedBox(height: 12),
            // زر الكشف
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _flipCard,
                icon: const Icon(Icons.visibility_rounded),
                label: const Text('اكشف الإجابة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFrontCard(Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.psychology, color: Colors.white38, size: 50),
          const SizedBox(height: 20),
          Text(
            _currentItem.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'مستوى: ${_currentItem.masteryLevelText}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'اضغط لكشف المحتوى',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackCard(Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_stories, color: color.withValues(alpha: 0.3), size: 40),
            const SizedBox(height: 16),
            Text(
              _currentItem.content,
              style: const TextStyle(
                fontSize: 20,
                height: 1.8,
                color: AppTheme.textDark,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHintsArea() {
    return Column(
      children: [
        TextButton.icon(
          onPressed: () {
            setState(() {
              _showHintIndex = (_showHintIndex + 1)
                  .clamp(0, _currentItem.hints.length - 1);
            });
          },
          icon: const Icon(Icons.lightbulb_outline, size: 18),
          label: Text(
            _showHintIndex < 0 ? 'أظهر تلميح' : 'تلميح آخر',
            style: const TextStyle(fontSize: 14),
          ),
        ),
        if (_showHintIndex >= 0)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: AppTheme.golden.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.golden.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Text('💡', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _currentItem.hints[_showHintIndex],
                    style: const TextStyle(
                      color: AppTheme.textDark,
                      fontSize: 14,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildRatingButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const Text(
            'كيف كان تذكرك؟',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildRateButton('لم أتذكر', 0, AppTheme.coral, Icons.close),
              const SizedBox(width: 8),
              _buildRateButton('بصعوبة', 2, AppTheme.warmOrange, Icons.sentiment_dissatisfied),
              const SizedBox(width: 8),
              _buildRateButton('جيد', 3, AppTheme.teal, Icons.sentiment_satisfied),
              const SizedBox(width: 8),
              _buildRateButton('ممتاز!', 5, AppTheme.mintGreen, Icons.star),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRateButton(String label, int quality, Color color, IconData icon) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _rateAnswer(quality),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
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
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    final duration = DateTime.now().difference(_startTime).inSeconds;
    final accuracy = widget.items.isNotEmpty
        ? (_correctAnswers / widget.items.length * 100)
        : 0.0;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accuracy >= 70
                      ? AppTheme.mintGreen.withValues(alpha: 0.1)
                      : AppTheme.coral.withValues(alpha: 0.1),
                  AppTheme.bgLight,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      accuracy >= 80 ? '🎉' : accuracy >= 50 ? '👍' : '💪',
                      style: const TextStyle(fontSize: 70),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      accuracy >= 80
                          ? 'ممتاز! أداء رائع!'
                          : accuracy >= 50
                              ? 'جيد! استمر في التحسن'
                              : 'لا بأس! المراجعة تصنع الفرق',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    // الإحصائيات
                    Row(
                      children: [
                        _buildResultStat(
                          'الدقة',
                          '${accuracy.toStringAsFixed(0)}%',
                          Icons.gps_fixed,
                          accuracy >= 70 ? AppTheme.mintGreen : AppTheme.coral,
                        ),
                        const SizedBox(width: 12),
                        _buildResultStat(
                          'الصحيحة',
                          '$_correctAnswers/${widget.items.length}',
                          Icons.check_circle,
                          AppTheme.teal,
                        ),
                        const SizedBox(width: 12),
                        _buildResultStat(
                          'الوقت',
                          '${(duration ~/ 60)}:${(duration % 60).toString().padLeft(2, '0')}',
                          Icons.timer,
                          AppTheme.softPurple,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.home_rounded),
                        label: const Text('العودة للرئيسية'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.coral,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // الكونفيتي
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: [
                AppTheme.coral,
                AppTheme.teal,
                AppTheme.golden,
                AppTheme.softPurple,
                AppTheme.mintGreen,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultStat(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.15),
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
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'الخروج من المراجعة؟',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'سيتم فقدان تقدمك في هذه الجلسة',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('متابعة'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.coral),
            child: const Text('خروج'),
          ),
        ],
      ),
    );
  }
}

class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;

  const AnimatedBuilder({
    super.key,
    required Animation<double> animation,
    required this.builder,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return builder(context, null);
  }
}
