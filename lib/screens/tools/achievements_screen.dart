import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/memory_provider.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int target;
  final int Function(MemoryProvider) progress;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.target,
    required this.progress,
  });

  bool isUnlocked(MemoryProvider p) => progress(p) >= target;

  double progressRatio(MemoryProvider p) {
    if (target == 0) return 0;
    return (progress(p) / target).clamp(0.0, 1.0);
  }
}

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  static final List<Achievement> _achievements = [
    // Items-based
    Achievement(
      id: 'first_item',
      title: 'الخطوة الأولى',
      description: 'أضف أول محفوظ لك',
      icon: Icons.start_rounded,
      color: AppTheme.emerald,
      target: 1,
      progress: (p) => p.totalItems,
    ),
    Achievement(
      id: 'ten_items',
      title: 'الطالب المجتهد',
      description: 'أضف 10 محفوظات',
      icon: Icons.school_rounded,
      color: AppTheme.deepTeal,
      target: 10,
      progress: (p) => p.totalItems,
    ),
    Achievement(
      id: 'fifty_items',
      title: 'المكتبة الصاعدة',
      description: 'أضف 50 محفوظاً',
      icon: Icons.library_books_rounded,
      color: AppTheme.softPurple,
      target: 50,
      progress: (p) => p.totalItems,
    ),
    Achievement(
      id: 'hundred_items',
      title: 'الحافظ المجتهد',
      description: 'أضف 100 محفوظ',
      icon: Icons.auto_stories_rounded,
      color: AppTheme.primaryGold,
      target: 100,
      progress: (p) => p.totalItems,
    ),
    // Mastered
    Achievement(
      id: 'first_mastered',
      title: 'أول إتقان',
      description: 'أتقن أول محفوظ',
      icon: Icons.workspace_premium_rounded,
      color: AppTheme.warmOrange,
      target: 1,
      progress: (p) => p.masteredCount,
    ),
    Achievement(
      id: 'ten_mastered',
      title: 'المتقن البارع',
      description: 'أتقن 10 محفوظات',
      icon: Icons.verified_rounded,
      color: AppTheme.emerald,
      target: 10,
      progress: (p) => p.masteredCount,
    ),
    Achievement(
      id: 'fifty_mastered',
      title: 'سيد الإتقان',
      description: 'أتقن 50 محفوظاً',
      icon: Icons.emoji_events_rounded,
      color: AppTheme.primaryGold,
      target: 50,
      progress: (p) => p.masteredCount,
    ),
    // Streak-based
    Achievement(
      id: 'streak_3',
      title: 'بدايات متواصلة',
      description: 'حافظ على 3 أيام متتالية',
      icon: Icons.local_fire_department_rounded,
      color: AppTheme.coral,
      target: 3,
      progress: (p) => p.streak,
    ),
    Achievement(
      id: 'streak_7',
      title: 'أسبوع كامل',
      description: 'حافظ على 7 أيام متتالية',
      icon: Icons.whatshot_rounded,
      color: AppTheme.warmOrange,
      target: 7,
      progress: (p) => p.streak,
    ),
    Achievement(
      id: 'streak_30',
      title: 'شهر من العطاء',
      description: 'حافظ على 30 يوماً متتالياً',
      icon: Icons.calendar_month_rounded,
      color: AppTheme.pinkAccent,
      target: 30,
      progress: (p) => p.streak,
    ),
    Achievement(
      id: 'streak_100',
      title: 'المثابر الأسطوري',
      description: 'حافظ على 100 يوم متتالي',
      icon: Icons.bolt_rounded,
      color: AppTheme.softPurple,
      target: 100,
      progress: (p) => p.streak,
    ),
    // Study minutes
    Achievement(
      id: 'minutes_60',
      title: 'ساعة عطاء',
      description: 'ادرس 60 دقيقة إجمالاً',
      icon: Icons.timer_rounded,
      color: AppTheme.skyBlue,
      target: 60,
      progress: (p) => StorageService.totalStudyMinutes,
    ),
    Achievement(
      id: 'minutes_300',
      title: '5 ساعات عطاء',
      description: 'ادرس 300 دقيقة إجمالاً',
      icon: Icons.hourglass_full_rounded,
      color: AppTheme.deepTeal,
      target: 300,
      progress: (p) => StorageService.totalStudyMinutes,
    ),
    Achievement(
      id: 'minutes_1000',
      title: 'بحر من العطاء',
      description: 'ادرس 1000 دقيقة إجمالاً',
      icon: Icons.waves_rounded,
      color: AppTheme.teal,
      target: 1000,
      progress: (p) => StorageService.totalStudyMinutes,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الإنجازات والشارات',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: Consumer<MemoryProvider>(
          builder: (context, provider, _) {
            final unlocked =
                _achievements.where((a) => a.isUnlocked(provider)).length;
            final total = _achievements.length;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _buildStatsHeader(unlocked, total, isDark),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  sliver: SliverGrid.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: _achievements.length,
                    itemBuilder: (context, index) {
                      return _AchievementCard(
                        achievement: _achievements[index],
                        provider: provider,
                        isDark: isDark,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatsHeader(int unlocked, int total, bool isDark) {
    final percent = total == 0 ? 0.0 : unlocked / total;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.headerGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.deepNavy.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            height: 90,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: percent,
                  strokeWidth: 8,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  valueColor:
                      const AlwaysStoppedAnimation(AppTheme.primaryGold),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$unlocked',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGold,
                      ),
                    ),
                    Text(
                      '/ $total',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (b) => const LinearGradient(
                    colors: [AppTheme.primaryGold, AppTheme.lightGold],
                  ).createShader(b),
                  child: const Text(
                    'إنجازاتك',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'فُتح $unlocked إنجازاً من $total متاح',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: percent,
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                    valueColor:
                        const AlwaysStoppedAnimation(AppTheme.primaryGold),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final MemoryProvider provider;
  final bool isDark;

  const _AchievementCard({
    required this.achievement,
    required this.provider,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final unlocked = achievement.isUnlocked(provider);
    final progress = achievement.progressRatio(provider);
    final current = achievement.progress(provider);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCardBg : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: unlocked
              ? achievement.color.withValues(alpha: 0.55)
              : (isDark
                  ? AppTheme.darkDivider
                  : AppTheme.divider.withValues(alpha: 0.6)),
          width: unlocked ? 1.5 : 1,
        ),
        boxShadow: unlocked
            ? [
                BoxShadow(
                  color: achievement.color.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: unlocked
                      ? LinearGradient(
                          colors: [
                            achievement.color,
                            achievement.color.withValues(alpha: 0.6),
                          ],
                        )
                      : null,
                  color: unlocked
                      ? null
                      : (isDark
                          ? AppTheme.darkSurface
                          : AppTheme.cream),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  unlocked ? achievement.icon : Icons.lock_outline_rounded,
                  color: unlocked
                      ? Colors.white
                      : (isDark
                          ? AppTheme.darkTextMuted
                          : AppTheme.textLight),
                  size: 22,
                ),
              ),
              const Spacer(),
              if (unlocked)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.emerald.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.check_rounded,
                          size: 12, color: AppTheme.emerald),
                      SizedBox(width: 2),
                      Text(
                        'مفتوح',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.emerald,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            achievement.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? AppTheme.darkTextPrimary : AppTheme.textDark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            achievement.description,
            style: TextStyle(
              fontSize: 11,
              color: isDark
                  ? AppTheme.darkTextSecondary
                  : AppTheme.textGrey,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor:
                  (isDark ? AppTheme.darkDivider : AppTheme.cream),
              valueColor: AlwaysStoppedAnimation(
                unlocked ? AppTheme.emerald : achievement.color,
              ),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$current / ${achievement.target}',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppTheme.darkTextSecondary
                  : AppTheme.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}
