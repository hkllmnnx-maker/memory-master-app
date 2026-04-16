import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';
import '../theme/app_theme.dart';

class PageJumpScreen extends StatefulWidget {
  const PageJumpScreen({super.key});

  @override
  State<PageJumpScreen> createState() => _PageJumpScreenState();
}

class _PageJumpScreenState extends State<PageJumpScreen> {
  final _pageController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(AppProvider provider) {
    final text = _pageController.text.trim();
    if (text.isEmpty) {
      setState(() => _errorText = 'أدخل رقم الصفحة');
      return;
    }
    final page = int.tryParse(text);
    if (page == null || page < 1 || page > 604) {
      setState(() => _errorText = 'أدخل رقماً بين 1 و 604');
      return;
    }
    provider.setCurrentPage(page);
    provider.setNavIndex(1); // Go to reader
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final isDark = provider.isDarkMode;
        final bookmarks = provider.memService.bookmarkedPages.toList()..sort();

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
                          'صفحة',
                          style: TextStyle(
                            color: AppColors.accentLight,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Page number input
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TextField(
                                  controller: _pageController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'رقم الصفحة (1-604)',
                                    hintStyle: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.5),
                                      fontSize: 14,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    errorText: _errorText,
                                    errorStyle: const TextStyle(
                                      color: AppColors.accentLight,
                                    ),
                                  ),
                                  onSubmitted: (_) => _goToPage(provider),
                                  onChanged: (_) {
                                    if (_errorText != null) {
                                      setState(() => _errorText = null);
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () => _goToPage(provider),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'انتقال',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Last read page
              _buildInfoCard(
                context,
                provider,
                isDark,
                icon: Icons.history,
                title: 'آخر صفحة تمت قراءتها',
                subtitle: 'صفحة ${provider.memService.lastReadPage}',
                onTap: () {
                  provider.setCurrentPage(provider.memService.lastReadPage);
                  provider.setNavIndex(1);
                },
              ),
              // Stats
              _buildInfoCard(
                context,
                provider,
                isDark,
                icon: Icons.check_circle,
                title: 'الصفحات المحفوظة',
                subtitle: '${provider.memService.memorizedCount} من 604 صفحة',
                onTap: null,
              ),
              // Bookmarks section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    const Icon(Icons.bookmark, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'الفواصل المرجعية',
                      style: TextStyle(
                        color: isDark ? Colors.white : AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: bookmarks.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bookmark_border,
                              size: 48,
                              color: isDark ? Colors.white30 : AppColors.textMuted,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'لا توجد فواصل مرجعية بعد',
                              style: TextStyle(
                                color: isDark ? Colors.white54 : AppColors.textMuted,
                                fontSize: 14,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'اضغط على أيقونة الفاصل أثناء القراءة',
                              style: TextStyle(
                                color: isDark ? Colors.white38 : AppColors.textMuted,
                                fontSize: 12,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: bookmarks.length,
                        itemBuilder: (context, index) {
                          final page = bookmarks[index];
                          final surahName = provider.quranService.getSurahNameForPage(page);
                          final juz = provider.quranService.getJuzForPage(page);
                          return _buildBookmarkTile(
                            context,
                            provider,
                            page,
                            surahName,
                            juz,
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

  Widget _buildInfoCard(
    BuildContext context,
    AppProvider provider,
    bool isDark, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: isDark ? const Color(0xFF1E3A2F) : AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: isDark ? Colors.white : AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: isDark ? Colors.white60 : AppColors.textSecondary,
                          fontSize: 12,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                ),
                if (onTap != null)
                  Icon(
                    Icons.arrow_back_ios,
                    size: 14,
                    color: isDark ? Colors.white30 : AppColors.textMuted,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookmarkTile(
    BuildContext context,
    AppProvider provider,
    int page,
    String surahName,
    int juz,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: isDark ? const Color(0xFF1E3A2F) : AppColors.bgCard,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            provider.setCurrentPage(page);
            provider.setNavIndex(1);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                const Icon(Icons.bookmark, color: AppColors.accent, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '$surahName - صفحة $page',
                    style: TextStyle(
                      color: isDark ? Colors.white : AppColors.textPrimary,
                      fontSize: 14,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                Text(
                  'جزء $juz',
                  style: TextStyle(
                    color: isDark ? Colors.white54 : AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  color: AppColors.error,
                  onPressed: () => provider.toggleBookmark(page),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
