import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/memory_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('التحديات والأهداف',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: Consumer2<MemoryProvider, SettingsProvider>(
          builder: (context, memory, settings, _) {
            final todayStats = memory.getTodayStats();
            final todayCards = todayStats['totalCards'] as int;
            final dailyGoal = settings.dailyGoal;
            final dailyProgress =
                (todayCards / dailyGoal).clamp(0.0, 1.0);

            final weeklyStats = memory.getWeeklyStats();
            final weeklyTotal = weeklyStats.fold<int>(
                0, (p, e) => p + (e['totalCards'] as int));
            final weeklyGoal = dailyGoal * 7;
            final weeklyProgress =
                (weeklyTotal / weeklyGoal).clamp(0.0, 1.0);

            final streak = memory.streak;
            final streakGoal = 7;
            final streakProgress = (streak / streakGoal).clamp(0.0, 1.0);

            final mastered = memory.masteredCount;
            final masterGoal = 10;
            final masterProgress = (mastered / masterGoal).clamp(0.0, 1.0);

            final studyMinutes = StorageService.totalStudyMinutes;
            final studyMinutesGoal = 60;
            final studyProgress =
                (studyMinutes / studyMinutesGoal).clamp(0.0, 1.0);

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _summaryCard(
                  isDark: isDark,
                  dailyProgress: dailyProgress,
                  streakDays: streak,
                ),
                const SizedBox(height: 18),
                _sectionLabel('تحدياتك الحالية', isDark),
                const SizedBox(height: 10),
                _ChallengeCard(
                  title: 'هدفك اليومي',
                  subtitle: '$todayCards / $dailyGoal محفوظات اليوم',
                  icon: Icons.today_rounded,
                  color: AppTheme.emerald,
                  progress: dailyProgress,
                  reward: '+10 نقاط',
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                _ChallengeCard(
                  title: 'هدف الأسبوع',
                  subtitle: '$weeklyTotal / $weeklyGoal محفوظات هذا الأسبوع',
                  icon: Icons.date_range_rounded,
                  color: AppTheme.deepTeal,
                  progress: weeklyProgress,
                  reward: '+50 نقطة',
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                _ChallengeCard(
                  title: 'اِستمرار 7 أيام',
                  subtitle: '$streak / $streakGoal أيام متتالية',
                  icon: Icons.local_fire_department_rounded,
                  color: AppTheme.coral,
                  progress: streakProgress,
                  reward: 'شارة المواظبة',
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                _ChallengeCard(
                  title: 'اتقان 10 محفوظات',
                  subtitle: '$mastered / $masterGoal محفوظات متقنة',
                  icon: Icons.star_rounded,
                  color: AppTheme.primaryGold,
                  progress: masterProgress,
                  reward: 'شارة المتقن',
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                _ChallengeCard(
                  title: 'ساعة دراسة',
                  subtitle: '$studyMinutes / $studyMinutesGoal دقيقة',
                  icon: Icons.timer_rounded,
                  color: AppTheme.softPurple,
                  progress: studyProgress,
                  reward: 'شارة المجتهد',
                  isDark: isDark,
                ),
                const SizedBox(height: 24),
                _motivationCard(isDark),
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _summaryCard({
    required bool isDark,
    required double dailyProgress,
    required int streakDays,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.headerGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.deepNavy.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 95,
            height: 95,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: dailyProgress,
                  strokeWidth: 8,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  valueColor:
                      const AlwaysStoppedAnimation(AppTheme.primaryGold),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(dailyProgress * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGold,
                      ),
                    ),
                    Text(
                      'اليوم',
                      style: TextStyle(
                        fontSize: 10,
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
                Row(
                  children: [
                    const Icon(Icons.local_fire_department_rounded,
                        color: AppTheme.coral, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      '$streakDays يوم متواصل',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'أكمل تحديات اليوم لتحصل على الجوائز',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.7),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isDark ? AppTheme.darkTextPrimary : AppTheme.textDark,
        ),
      ),
    );
  }

  Widget _motivationCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryGold.withValues(alpha: 0.12),
            AppTheme.deepTeal.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppTheme.primaryGold.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.format_quote_rounded,
              size: 32, color: AppTheme.primaryGold),
          const SizedBox(height: 10),
          Text(
            '«وَمَنْ جَاهَدَ فَإِنَّمَا يُجَاهِدُ لِنَفْسِهِ»',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              height: 1.8,
              fontFamily: 'Amiri',
              fontWeight: FontWeight.bold,
              color: isDark ? AppTheme.darkTextPrimary : AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'العنكبوت: 6',
            style: TextStyle(
              fontSize: 12,
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

class _ChallengeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final double progress;
  final String reward;
  final bool isDark;

  const _ChallengeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.progress,
    required this.reward,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final completed = progress >= 1.0;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCardBg : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: completed
              ? AppTheme.emerald.withValues(alpha: 0.6)
              : color.withValues(alpha: 0.18),
          width: completed ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppTheme.darkTextPrimary
                            : AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppTheme.darkTextSecondary
                            : AppTheme.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
              if (completed)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.emerald.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_rounded,
                          size: 12, color: AppTheme.emerald),
                      SizedBox(width: 2),
                      Text(
                        'مكتمل',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.emerald,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: isDark ? AppTheme.darkDivider : AppTheme.cream,
              valueColor: AlwaysStoppedAnimation(
                completed ? AppTheme.emerald : color,
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.card_giftcard_rounded,
                  size: 13, color: AppTheme.primaryGold),
              const SizedBox(width: 4),
              Text(
                'المكافأة: $reward',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkGold,
                ),
              ),
              const Spacer(),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
