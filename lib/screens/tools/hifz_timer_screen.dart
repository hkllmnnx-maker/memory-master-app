import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

/// مؤقت الحفظ - يعتمد على تقنية "البومودورو" مع دورات للحفظ والمراجعة
class HifzTimerScreen extends StatefulWidget {
  const HifzTimerScreen({super.key});

  @override
  State<HifzTimerScreen> createState() => _HifzTimerScreenState();
}

enum _TimerPhase { focus, shortBreak, longBreak }

class _HifzTimerScreenState extends State<HifzTimerScreen> {
  int _focusMinutes = 25;
  int _shortBreakMinutes = 5;
  int _longBreakMinutes = 15;

  _TimerPhase _currentPhase = _TimerPhase.focus;
  int _remainingSeconds = 25 * 60;
  Timer? _timer;
  bool _isRunning = false;
  int _completedFocusCycles = 0;
  int _totalFocusMinutesToday = 0;

  int get _totalSeconds {
    switch (_currentPhase) {
      case _TimerPhase.focus:
        return _focusMinutes * 60;
      case _TimerPhase.shortBreak:
        return _shortBreakMinutes * 60;
      case _TimerPhase.longBreak:
        return _longBreakMinutes * 60;
    }
  }

  String get _phaseName {
    switch (_currentPhase) {
      case _TimerPhase.focus:
        return 'وقت الحفظ';
      case _TimerPhase.shortBreak:
        return 'استراحة قصيرة';
      case _TimerPhase.longBreak:
        return 'استراحة طويلة';
    }
  }

  Color get _phaseColor {
    switch (_currentPhase) {
      case _TimerPhase.focus:
        return AppTheme.deepTeal;
      case _TimerPhase.shortBreak:
        return AppTheme.emerald;
      case _TimerPhase.longBreak:
        return AppTheme.softPurple;
    }
  }

  IconData get _phaseIcon {
    switch (_currentPhase) {
      case _TimerPhase.focus:
        return Icons.menu_book_rounded;
      case _TimerPhase.shortBreak:
        return Icons.coffee_rounded;
      case _TimerPhase.longBreak:
        return Icons.self_improvement_rounded;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    if (_isRunning) return;
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _completeCurrentPhase();
      }
    });
  }

  void _pause() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = _totalSeconds;
      _isRunning = false;
    });
  }

  void _completeCurrentPhase() {
    _timer?.cancel();
    HapticFeedback.heavyImpact();

    if (_currentPhase == _TimerPhase.focus) {
      _completedFocusCycles++;
      _totalFocusMinutesToday += _focusMinutes;
      _showCompletionDialog();
      // Every 4 focus rounds -> long break
      final nextPhase = (_completedFocusCycles % 4 == 0)
          ? _TimerPhase.longBreak
          : _TimerPhase.shortBreak;
      setState(() {
        _currentPhase = nextPhase;
        _remainingSeconds = _totalSeconds;
        _isRunning = false;
      });
    } else {
      // Break done → back to focus
      setState(() {
        _currentPhase = _TimerPhase.focus;
        _remainingSeconds = _totalSeconds;
        _isRunning = false;
      });
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.celebration_rounded,
                  color: AppTheme.primaryGold, size: 28),
              SizedBox(width: 10),
              Text('أحسنت!',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(
            'أكملت جلسة حفظ ناجحة. الآن استراحة قصيرة ثم عُد أقوى!',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppTheme.darkTextSecondary
                  : AppTheme.textMedium,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('حسناً'),
            ),
          ],
        ),
      ),
    );
  }

  void _switchPhase(_TimerPhase phase) {
    _timer?.cancel();
    setState(() {
      _currentPhase = phase;
      _remainingSeconds = _totalSeconds;
      _isRunning = false;
    });
  }

  String _formatTime(int s) {
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final sec = (s % 60).toString().padLeft(2, '0');
    return '$m:$sec';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress =
        _totalSeconds == 0 ? 0.0 : 1 - (_remainingSeconds / _totalSeconds);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('مؤقت الحفظ',
              style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              onPressed: _showSettingsDialog,
              icon: const Icon(Icons.tune_rounded),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Phase selector
                Row(
                  children: [
                    _phaseChip(_TimerPhase.focus, 'حفظ', Icons.menu_book_rounded),
                    const SizedBox(width: 8),
                    _phaseChip(_TimerPhase.shortBreak, 'استراحة',
                        Icons.coffee_rounded),
                    const SizedBox(width: 8),
                    _phaseChip(_TimerPhase.longBreak, 'استراحة طويلة',
                        Icons.self_improvement_rounded),
                  ],
                ),
                const SizedBox(height: 32),
                // Timer circle
                Expanded(
                  child: Center(
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? AppTheme.darkCardBg : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: _phaseColor.withValues(alpha: 0.2),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 260,
                            height: 260,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 12,
                              backgroundColor: _phaseColor.withValues(alpha: 0.1),
                              valueColor: AlwaysStoppedAnimation(_phaseColor),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_phaseIcon, color: _phaseColor, size: 32),
                              const SizedBox(height: 8),
                              Text(
                                _phaseName,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppTheme.darkTextSecondary
                                      : AppTheme.textGrey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _formatTime(_remainingSeconds),
                                style: TextStyle(
                                  fontSize: 56,
                                  fontWeight: FontWeight.bold,
                                  color: _phaseColor,
                                  height: 1,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures()
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Stats
                Row(
                  children: [
                    Expanded(
                      child: _metricCard(
                        label: 'الدورات المكتملة',
                        value: '$_completedFocusCycles',
                        icon: Icons.check_circle_rounded,
                        color: AppTheme.emerald,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _metricCard(
                        label: 'دقائق الحفظ',
                        value: '$_totalFocusMinutesToday',
                        icon: Icons.timer_rounded,
                        color: AppTheme.primaryGold,
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Controls
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: _isRunning ? _pause : _start,
                        icon: Icon(
                          _isRunning
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          size: 26,
                        ),
                        label: Text(
                          _isRunning ? 'إيقاف مؤقت' : 'ابدأ',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _phaseColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _reset,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('تصفير'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                              color: _phaseColor.withValues(alpha: 0.5)),
                          foregroundColor: _phaseColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _phaseChip(_TimerPhase p, String label, IconData icon) {
    final selected = p == _currentPhase;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color c;
    switch (p) {
      case _TimerPhase.focus:
        c = AppTheme.deepTeal;
        break;
      case _TimerPhase.shortBreak:
        c = AppTheme.emerald;
        break;
      case _TimerPhase.longBreak:
        c = AppTheme.softPurple;
        break;
    }
    return Expanded(
      child: GestureDetector(
        onTap: () => _switchPhase(p),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? c.withValues(alpha: 0.12)
                : (isDark ? AppTheme.darkCardBg : AppTheme.cream),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? c
                  : (isDark ? AppTheme.darkDivider : Colors.transparent),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  color: selected
                      ? c
                      : (isDark
                          ? AppTheme.darkTextMuted
                          : AppTheme.textLight),
                  size: 18),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: selected
                      ? c
                      : (isDark
                          ? AppTheme.darkTextMuted
                          : AppTheme.textGrey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metricCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCardBg : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppTheme.darkTextSecondary
                        : AppTheme.textGrey,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (_) {
        int f = _focusMinutes;
        int s = _shortBreakMinutes;
        int l = _longBreakMinutes;
        return Directionality(
          textDirection: TextDirection.rtl,
          child: StatefulBuilder(
            builder: (context, setSt) => AlertDialog(
              title: const Text('إعدادات المؤقت',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _minuteSlider('وقت الحفظ', f, 5, 60, (v) {
                    setSt(() => f = v);
                  }),
                  _minuteSlider('استراحة قصيرة', s, 1, 20, (v) {
                    setSt(() => s = v);
                  }),
                  _minuteSlider('استراحة طويلة', l, 5, 40, (v) {
                    setSt(() => l = v);
                  }),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _focusMinutes = f;
                      _shortBreakMinutes = s;
                      _longBreakMinutes = l;
                      _remainingSeconds = _totalSeconds;
                      _isRunning = false;
                      _timer?.cancel();
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('حفظ'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _minuteSlider(
      String label, int value, int min, int max, Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text('$value د', style: const TextStyle(color: AppTheme.deepTeal)),
          ],
        ),
        Slider(
          value: value.toDouble(),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: max - min,
          onChanged: (v) => onChanged(v.toInt()),
        ),
      ],
    );
  }
}
