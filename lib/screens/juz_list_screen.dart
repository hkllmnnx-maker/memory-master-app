import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';
import '../theme/app_theme.dart';

class JuzListScreen extends StatelessWidget {
  const JuzListScreen({super.key});

  static const List<String> juzNames = [
    'الم', 'سيقول', 'تلك الرسل', 'لن تنالوا', 'والمحصنات',
    'لا يحب الله', 'وإذا سمعوا', 'ولو أننا', 'قال الملأ',
    'واعلموا', 'يعتذرون', 'وما من دابة', 'وما أبرئ',
    'ربما', 'سبحان الذي', 'قال ألم', 'اقترب للناس',
    'قد أفلح', 'وقال الذين', 'أمن خلق', 'اتل ما أوحي',
    'ومن يقنت', 'وما لي', 'فمن أظلم', 'إليه يرد',
    'حم', 'قال فما خطبكم', 'قد سمع الله', 'تبارك الذي',
    'عم',
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final juzs = provider.quranService.juzs;
        final isDark = provider.isDarkMode;

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0D1F17) : AppColors.bgLight,
          body: Column(
            children: [
              // Header
              Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.headerGradient,
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          'الأجزاء',
                          style: TextStyle(
                            color: AppColors.accentLight,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'تقدم الحفظ: ${provider.memService.memorizedCount} / 604 صفحة',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: provider.memService.memorizedPercentage / 100,
                            backgroundColor: Colors.white.withValues(alpha: 0.15),
                            valueColor: const AlwaysStoppedAnimation(AppColors.accentLight),
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${provider.memService.memorizedPercentage.toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Juz grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    final juzNum = index + 1;
                    final juz = juzs[juzNum];
                    if (juz == null) return const SizedBox();

                    // Calculate memorization progress for this juz
                    int memorized = 0;
                    final totalPages = juz.endPage - juz.startPage + 1;
                    for (int p = juz.startPage; p <= juz.endPage; p++) {
                      if (provider.memService.isMemorized(p)) memorized++;
                    }
                    final progress = totalPages > 0 ? memorized / totalPages : 0.0;

                    return _buildJuzCard(
                      context,
                      provider,
                      juzNum,
                      juz.startPage,
                      progress,
                      isDark,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildJuzCard(
    BuildContext context,
    AppProvider provider,
    int juzNum,
    int startPage,
    double progress,
    bool isDark,
  ) {
    final juzName = juzNum <= juzNames.length ? juzNames[juzNum - 1] : '';
    
    return Material(
      color: isDark ? const Color(0xFF1E3A2F) : AppColors.bgCard,
      borderRadius: BorderRadius.circular(14),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          provider.setCurrentPage(startPage);
          provider.setNavIndex(1); // Switch to reader
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Juz number circle
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: AppColors.headerGradient,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$juzNum',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                juzName,
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 4),
              Text(
                'ص $startPage',
                style: TextStyle(
                  color: isDark ? Colors.white54 : AppColors.textMuted,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 6),
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : AppColors.primary.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation(
                    progress >= 1.0 ? AppColors.accentLight : AppColors.primaryLight,
                  ),
                  minHeight: 4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  color: isDark ? Colors.white54 : AppColors.textMuted,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
