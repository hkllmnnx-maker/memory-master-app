import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/daily_wisdom_data.dart';
import '../../theme/app_theme.dart';

class DailyWisdomScreen extends StatelessWidget {
  const DailyWisdomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final verse = DailyWisdomData.getDailyVerse();
    final hadith = DailyWisdomData.getDailyHadith();
    final dua = DailyWisdomData.getDailyDua();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 150,
              backgroundColor: AppTheme.deepTeal,
              iconTheme: const IconThemeData(color: Colors.white),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: AppTheme.headerGradient,
                  ),
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
                              Icons.lightbulb_rounded,
                              color: AppTheme.primaryGold,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                ShaderMask(
                                  shaderCallback: (b) =>
                                      const LinearGradient(
                                    colors: [
                                      AppTheme.primaryGold,
                                      AppTheme.lightGold
                                    ],
                                  ).createShader(b),
                                  child: const Text(
                                    'تذكرة اليوم',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _formatDate(DateTime.now()),
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
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
              sliver: SliverList.separated(
                itemCount: 3,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return _WisdomCard(
                        item: verse,
                        title: 'آية اليوم',
                        icon: Icons.menu_book_rounded,
                        color: AppTheme.primaryGold,
                        gradient: AppTheme.goldGradient,
                        isDark: isDark,
                      );
                    case 1:
                      return _WisdomCard(
                        item: hadith,
                        title: 'حديث اليوم',
                        icon: Icons.format_quote_rounded,
                        color: AppTheme.emerald,
                        gradient: AppTheme.emeraldGradient,
                        isDark: isDark,
                      );
                    case 2:
                      return _WisdomCard(
                        item: dua,
                        title: 'دعاء اليوم',
                        icon: Icons.spa_rounded,
                        color: AppTheme.softPurple,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C5CE7), Color(0xFF8E7EF0)],
                        ),
                        isDark: isDark,
                      );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}

class _WisdomCard extends StatelessWidget {
  final WisdomItem item;
  final String title;
  final IconData icon;
  final Color color;
  final Gradient gradient;
  final bool isDark;

  const _WisdomCard({
    required this.item,
    required this.title,
    required this.icon,
    required this.color,
    required this.gradient,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCardBg : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: item.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('تم نسخ $title'),
                        duration: const Duration(seconds: 1),
                        backgroundColor: color,
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(Icons.copy_rounded,
                        color: Colors.white.withValues(alpha: 0.9),
                        size: 18),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  item.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 19,
                    height: 2.0,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppTheme.darkTextPrimary
                        : AppTheme.textDark,
                    fontFamily: 'Amiri',
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.book_outlined,
                        size: 14,
                        color: isDark
                            ? AppTheme.darkTextMuted
                            : AppTheme.textGrey),
                    const SizedBox(width: 6),
                    Text(
                      item.source,
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppTheme.darkTextSecondary
                            : AppTheme.textGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
