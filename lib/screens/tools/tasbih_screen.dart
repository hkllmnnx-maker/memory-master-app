import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen>
    with SingleTickerProviderStateMixin {
  int _count = 0;
  int _rounds = 0;
  int _target = 33;
  int _selectedPhrase = 0;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  final List<Map<String, dynamic>> _phrases = const [
    {
      'text': 'سُبْحَانَ اللَّهِ',
      'short': 'سبحان الله',
      'color': AppTheme.deepTeal,
    },
    {
      'text': 'الْحَمْدُ لِلَّهِ',
      'short': 'الحمد لله',
      'color': AppTheme.emerald,
    },
    {
      'text': 'اللَّهُ أَكْبَرُ',
      'short': 'الله أكبر',
      'color': AppTheme.primaryGold,
    },
    {
      'text': 'لَا إِلَهَ إِلَّا اللَّهُ',
      'short': 'لا إله إلا الله',
      'color': AppTheme.softPurple,
    },
    {
      'text': 'أَسْتَغْفِرُ اللَّهَ',
      'short': 'أستغفر الله',
      'color': AppTheme.burgundy,
    },
    {
      'text': 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ',
      'short': 'الصلاة على النبي',
      'color': AppTheme.teal,
    },
  ];

  final List<int> _targetOptions = [33, 99, 100, 500, 1000];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _tap() {
    setState(() {
      _count++;
      if (_count >= _target) {
        _rounds++;
        _count = 0;
        HapticFeedback.heavyImpact();
      } else {
        HapticFeedback.lightImpact();
      }
    });
    _pulseController.forward(from: 0).then((_) => _pulseController.reverse());
  }

  void _reset() {
    setState(() {
      _count = 0;
      _rounds = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final phrase = _phrases[_selectedPhrase];
    final color = phrase['color'] as Color;
    final progress = _target == 0 ? 0.0 : _count / _target;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('السبحة الإلكترونية',
              style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              tooltip: 'إعادة التصفير',
              onPressed: _reset,
              icon: const Icon(Icons.refresh_rounded),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Phrase selector
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _phrases.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final isSelected = _selectedPhrase == i;
                    final c = _phrases[i]['color'] as Color;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedPhrase = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? LinearGradient(colors: [
                                  c,
                                  c.withValues(alpha: 0.7)
                                ])
                              : null,
                          color: isSelected
                              ? null
                              : (isDark
                                  ? AppTheme.darkCardBg
                                  : AppTheme.cream),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? c
                                : (isDark
                                    ? AppTheme.darkDivider
                                    : AppTheme.divider),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _phrases[i]['short'] as String,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark
                                      ? AppTheme.darkTextPrimary
                                      : AppTheme.textDark),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Stats row
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatBox(
                        label: 'العدد',
                        value: '$_count',
                        color: color,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatBox(
                        label: 'الجولات',
                        value: '$_rounds',
                        color: AppTheme.primaryGold,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: _showTargetDialog,
                        child: _StatBox(
                          label: 'الهدف',
                          value: '$_target',
                          color: AppTheme.softPurple,
                          isDark: isDark,
                          trailingIcon: Icons.edit_rounded,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Counter circle
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: _tap,
                    child: AnimatedBuilder(
                      animation: _pulseAnim,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnim.value,
                          child: child,
                        );
                      },
                      child: Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              color.withValues(alpha: 0.95),
                              color.withValues(alpha: 0.7),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.45),
                              blurRadius: 40,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 240,
                              height: 240,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 8,
                                backgroundColor:
                                    Colors.white.withValues(alpha: 0.18),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white.withValues(alpha: 0.95),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  phrase['text'] as String,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Amiri',
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '$_count',
                                  style: const TextStyle(
                                    fontSize: 56,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                ),
                                Text(
                                  '/ $_target',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        Colors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'اضغط الدائرة للعد',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppTheme.darkTextMuted
                        : AppTheme.textLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTargetDialog() {
    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('اختر الهدف',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _targetOptions.map((t) {
              final isSelected = t == _target;
              return ListTile(
                onTap: () {
                  setState(() => _target = t);
                  Navigator.pop(context);
                },
                leading: Icon(
                  isSelected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: isSelected
                      ? AppTheme.deepTeal
                      : AppTheme.textLight,
                ),
                title: Text('$t مرة'),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isDark;
  final IconData? trailingIcon;

  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCardBg : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? AppTheme.darkTextSecondary : AppTheme.textGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 4),
                Icon(trailingIcon, size: 12, color: AppTheme.textLight),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
