import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../azkar/azkar_list_screen.dart';
import 'tasbih_screen.dart';
import 'hifz_timer_screen.dart';
import 'achievements_screen.dart';
import 'asma_ul_husna_screen.dart';
import 'daily_wisdom_screen.dart';
import 'challenges_screen.dart';
import '../settings/settings_screen.dart';

/// شاشة الأدوات - تجمع كل الأدوات الإسلامية والمساعدة
class ToolsHubScreen extends StatelessWidget {
  const ToolsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final tools = [
      _ToolData(
        title: 'تذكرة اليوم',
        subtitle: 'آية وحديث ودعاء يومياً',
        icon: Icons.lightbulb_rounded,
        gradient: const LinearGradient(
          colors: [Color(0xFFD4A853), Color(0xFFE8C97A)],
        ),
        target: const DailyWisdomScreen(),
      ),
      _ToolData(
        title: 'حصن المسلم',
        subtitle: 'أذكار الصباح والمساء والنوم',
        icon: Icons.auto_awesome_rounded,
        gradient: const LinearGradient(
          colors: [Color(0xFF0D6E6E), Color(0xFF148F8F)],
        ),
        target: const AzkarListScreen(),
      ),
      _ToolData(
        title: 'الأسماء الحسنى',
        subtitle: '99 اسماً لله تعالى مع شرحها',
        icon: Icons.star_rounded,
        gradient: const LinearGradient(
          colors: [Color(0xFFE84393), Color(0xFFFF7AB6)],
        ),
        target: const AsmaUlHusnaScreen(),
      ),
      _ToolData(
        title: 'السبحة الإلكترونية',
        subtitle: 'عد التسبيح والذكر',
        icon: Icons.circle_outlined,
        gradient: const LinearGradient(
          colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
        ),
        target: const TasbihScreen(),
      ),
      _ToolData(
        title: 'مؤقت الحفظ',
        subtitle: 'جلسات تركيز للحفظ والمراجعة',
        icon: Icons.timer_rounded,
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9F43), Color(0xFFFFB872)],
        ),
        target: const HifzTimerScreen(),
      ),
      _ToolData(
        title: 'التحديات',
        subtitle: 'أهدافك اليومية والأسبوعية',
        icon: Icons.flag_rounded,
        gradient: const LinearGradient(
          colors: [Color(0xFFE74C3C), Color(0xFFEC7063)],
        ),
        target: const ChallengesScreen(),
      ),
      _ToolData(
        title: 'الإنجازات',
        subtitle: 'شاراتك وتقدمك العلمي',
        icon: Icons.emoji_events_rounded,
        gradient: const LinearGradient(
          colors: [Color(0xFF6C5CE7), Color(0xFF8E7EF0)],
        ),
        target: const AchievementsScreen(),
      ),
      _ToolData(
        title: 'الإعدادات',
        subtitle: 'المظهر والخط والتذكيرات',
        icon: Icons.settings_rounded,
        gradient: const LinearGradient(
          colors: [Color(0xFF34495E), Color(0xFF2C3E50)],
        ),
        target: const SettingsScreen(),
      ),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 150,
              backgroundColor: AppTheme.deepTeal,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                      gradient: AppTheme.headerGradient),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGold
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: AppTheme.primaryGold
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: const Icon(
                              Icons.apps_rounded,
                              color: AppTheme.primaryGold,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                    colors: [
                                      AppTheme.primaryGold,
                                      AppTheme.lightGold
                                    ],
                                  ).createShader(bounds),
                                  child: const Text(
                                    'الأدوات',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'أدوات إسلامية ومساعدة للحفظ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white
                                        .withValues(alpha: 0.65),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              sliver: SliverGrid.builder(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.95,
                ),
                itemCount: tools.length,
                itemBuilder: (context, index) {
                  return _ToolCard(
                    data: tools[index],
                    isDark: isDark,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
  final Widget target;

  _ToolData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.target,
  });
}

class _ToolCard extends StatelessWidget {
  final _ToolData data;
  final bool isDark;

  const _ToolCard({required this.data, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => data.target),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: data.gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: ((data.gradient as LinearGradient).colors.first)
                    .withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(data.icon, color: Colors.white, size: 26),
              ),
              const Spacer(),
              Text(
                data.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                data.subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.8),
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'افتح',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withValues(alpha: 0.95),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_back_rounded,
                      color: Colors.white, size: 14),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
