import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';
import '../theme/app_theme.dart';
import '../models/quran_models.dart';

class SurahListScreen extends StatefulWidget {
  const SurahListScreen({super.key});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final surahs = provider.quranService.searchSurahs(_searchQuery);
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
                          'السور',
                          style: TextStyle(
                            color: AppColors.accentLight,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Search bar
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _searchController,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'ابحث عن سورة...',
                              hintStyle: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() => _searchQuery = value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Surah list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: surahs.length,
                  itemBuilder: (context, index) {
                    return _buildSurahTile(context, surahs[index], provider);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSurahTile(BuildContext context, SurahInfo surah, AppProvider provider) {
    final isDark = provider.isDarkMode;
    final isMemorizedStart = provider.memService.isMemorized(surah.startPage);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: Material(
        color: isDark ? const Color(0xFF1E3A2F) : AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            provider.setCurrentPage(surah.startPage);
            provider.setNavIndex(1); // Switch to page view
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                // Surah number
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: AppColors.headerGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '${surah.number}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Surah info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        surah.name,
                        style: TextStyle(
                          color: isDark ? Colors.white : AppColors.textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${surah.localizedRevelationType} - ${surah.ayahCount} آية',
                        style: TextStyle(
                          color: isDark ? Colors.white60 : AppColors.textSecondary,
                          fontSize: 12,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Page number & memorization status
                Column(
                  children: [
                    Text(
                      'ص ${surah.startPage}',
                      style: TextStyle(
                        color: isDark ? Colors.white54 : AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                    if (isMemorizedStart)
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.primaryLight,
                        size: 16,
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
}
