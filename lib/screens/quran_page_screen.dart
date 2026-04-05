import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';
import '../theme/app_theme.dart';
import '../models/quran_models.dart';

class QuranPageScreen extends StatefulWidget {
  const QuranPageScreen({super.key});

  @override
  State<QuranPageScreen> createState() => _QuranPageScreenState();
}

class _QuranPageScreenState extends State<QuranPageScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<AppProvider>();
    // Reverse page index for RTL (Quran reads right to left)
    _pageController = PageController(
      initialPage: 604 - provider.currentPage,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final surahName = provider.quranService.getSurahNameForPage(provider.currentPage);
        final juz = provider.quranService.getJuzForPage(provider.currentPage);
        final isMemorized = provider.memService.isMemorized(provider.currentPage);
        final isBookmarked = provider.memService.isBookmarked(provider.currentPage);

        return Scaffold(
          body: Column(
            children: [
              // Header
              _buildHeader(context, provider, surahName, juz, isMemorized, isBookmarked),
              // Quran Content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  reverse: true, // RTL page flipping
                  itemCount: 604,
                  onPageChanged: (index) {
                    provider.setCurrentPage(604 - index);
                  },
                  itemBuilder: (context, index) {
                    final pageNum = 604 - index;
                    final data = provider.quranService.getPage(pageNum);
                    return _buildPageContent(context, provider, data);
                  },
                ),
              ),
              // Bottom slider
              _buildBottomSlider(context, provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppProvider provider,
    String surahName,
    int juz,
    bool isMemorized,
    bool isBookmarked,
  ) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              // Dark mode toggle
              IconButton(
                icon: Icon(
                  provider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: AppColors.accentLight,
                  size: 24,
                ),
                onPressed: () => provider.toggleDarkMode(),
              ),
              const Spacer(),
              // Surah name and page info
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    surahName,
                    style: const TextStyle(
                      color: AppColors.accentLight,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'الجزء $juz - صفحة ${provider.currentPage}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Bookmark & memorize actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: isBookmarked ? AppColors.accentLight : Colors.white,
                      size: 22,
                    ),
                    onPressed: () => provider.toggleBookmark(provider.currentPage),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 36),
                  ),
                  IconButton(
                    icon: Icon(
                      isMemorized ? Icons.check_circle : Icons.check_circle_outline,
                      color: isMemorized ? AppColors.accentLight : Colors.white,
                      size: 22,
                    ),
                    onPressed: () => provider.toggleMemorized(provider.currentPage),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 36),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent(BuildContext context, AppProvider provider, PageData data) {
    final isDark = provider.isDarkMode;
    final bgColor = isDark ? const Color(0xFF1A1A2E) : AppColors.bgLight;
    final textColor = isDark ? Colors.white : AppColors.textQuran;

    // Group ayahs by surah to show surah headers
    final Map<int, List<AyahInfo>> surahGroups = {};
    for (final ayah in data.ayahs) {
      surahGroups.putIfAbsent(ayah.surahNumber, () => []).add(ayah);
    }

    return Container(
      color: bgColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            for (final entry in surahGroups.entries) ...[
              // Show surah header if the surah starts on this page
              if (entry.value.first.numberInSurah == 1) ...[
                _buildSurahHeader(entry.value.first.surahName, isDark),
                // Bismillah (except for Al-Fatiha and At-Tawbah)
                if (entry.key != 1 && entry.key != 9)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                      style: TextStyle(
                        fontSize: provider.fontSize - 4,
                        color: textColor,
                        height: 2.0,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
              ],
              // Ayahs as flowing text
              _buildAyahsText(entry.value, provider, textColor),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSurahHeader(String surahName, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        surahName,
        style: const TextStyle(
          color: AppColors.accentLight,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        textDirection: TextDirection.rtl,
      ),
    );
  }

  Widget _buildAyahsText(List<AyahInfo> ayahs, AppProvider provider, Color textColor) {
    // Build a rich text with all ayahs flowing together
    final spans = <InlineSpan>[];
    for (int i = 0; i < ayahs.length; i++) {
      final ayah = ayahs[i];
      // Ayah text
      spans.add(TextSpan(
        text: ayah.text,
        style: TextStyle(
          fontSize: provider.fontSize,
          color: textColor,
          height: 2.2,
          fontFamily: 'serif',
        ),
      ));
      // Ayah number marker
      spans.add(TextSpan(
        text: ' \uFD3F${_toArabicNumber(ayah.numberInSurah)}\uFD3E ',
        style: TextStyle(
          fontSize: provider.fontSize - 6,
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        text: TextSpan(children: spans),
      ),
    );
  }

  String _toArabicNumber(int number) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number.toString().split('').map((d) => arabicDigits[int.parse(d)]).join();
  }

  Widget _buildBottomSlider(BuildContext context, AppProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: provider.isDarkMode ? const Color(0xFF1A1A2E) : AppColors.bgLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Text(
              '${provider.currentPage}',
              style: TextStyle(
                color: provider.isDarkMode ? Colors.white70 : AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: AppColors.gold,
                  inactiveTrackColor: AppColors.gold.withValues(alpha: 0.3),
                  thumbColor: AppColors.gold,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: provider.currentPage.toDouble(),
                  min: 1,
                  max: 604,
                  onChanged: (value) {
                    final newPage = value.round();
                    provider.setCurrentPage(newPage);
                    _pageController.jumpToPage(604 - newPage);
                  },
                ),
              ),
            ),
            Text(
              '604',
              style: TextStyle(
                color: provider.isDarkMode ? Colors.white70 : AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
