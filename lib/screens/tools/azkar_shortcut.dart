import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../azkar/azkar_list_screen.dart';
import 'tasbih_screen.dart';
import 'hifz_timer_screen.dart';
import 'quick_quiz_screen.dart';

/// صف اختصارات سريعة للأدوات الإسلامية الأكثر استخداماً
class AzkarShortcutRow extends StatelessWidget {
  const AzkarShortcutRow({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shortcuts = [
      _ShortcutData(
        label: 'أذكار',
        icon: Icons.auto_awesome_rounded,
        color: AppTheme.deepTeal,
        target: const AzkarListScreen(),
      ),
      _ShortcutData(
        label: 'التسبيح',
        icon: Icons.circle_outlined,
        color: AppTheme.emerald,
        target: const TasbihScreen(),
      ),
      _ShortcutData(
        label: 'مؤقت',
        icon: Icons.timer_rounded,
        color: AppTheme.warmOrange,
        target: const HifzTimerScreen(),
      ),
      _ShortcutData(
        label: 'مسابقة',
        icon: Icons.quiz_rounded,
        color: AppTheme.softPurple,
        target: const QuickQuizScreen(),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      child: Row(
        children: shortcuts.map((s) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _ShortcutButton(data: s, isDark: isDark),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ShortcutData {
  final String label;
  final IconData icon;
  final Color color;
  final Widget target;

  _ShortcutData({
    required this.label,
    required this.icon,
    required this.color,
    required this.target,
  });
}

class _ShortcutButton extends StatelessWidget {
  final _ShortcutData data;
  final bool isDark;
  const _ShortcutButton({required this.data, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => data.target),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkCardBg : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: data.color.withValues(alpha: 0.25),
            ),
            boxShadow: [
              BoxShadow(
                color: data.color.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      data.color,
                      data.color.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(data.icon, color: Colors.white, size: 20),
              ),
              const SizedBox(height: 6),
              Text(
                data.label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color:
                      isDark ? AppTheme.darkTextPrimary : AppTheme.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
