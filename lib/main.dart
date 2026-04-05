import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/app_provider.dart';
import 'theme/app_theme.dart';
import 'screens/surah_list_screen.dart';
import 'screens/quran_page_screen.dart';
import 'screens/juz_list_screen.dart';
import 'screens/page_jump_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MemoryMasterApp());
}

class MemoryMasterApp extends StatelessWidget {
  const MemoryMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider()..initialize(),
      child: Consumer<AppProvider>(
        builder: (context, provider, _) {
          return MaterialApp(
            title: 'ذاكرة الحفظ',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            locale: const Locale('ar', 'SA'),
            builder: (context, child) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: child!,
              );
            },
            home: provider.isLoading
                ? const _SplashScreen()
                : const _HomeScreen(),
          );
        },
      ),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.headerGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: AppColors.accentLight,
                  size: 56,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'ذاكرة الحفظ',
                style: TextStyle(
                  color: AppColors.accentLight,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'القرآن الكريم',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              const SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentLight),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'جاري التحميل...',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final isDark = provider.isDarkMode;

        final screens = [
          const SurahListScreen(),
          const QuranPageScreen(),
          const JuzListScreen(),
          const PageJumpScreen(),
        ];

        return Scaffold(
          body: IndexedStack(
            index: provider.currentNavIndex,
            children: screens,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0D1F17) : AppColors.bgDark,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      context,
                      provider,
                      icon: Icons.list_alt_rounded,
                      label: 'السور',
                      index: 0,
                    ),
                    _buildNavItem(
                      context,
                      provider,
                      icon: Icons.auto_stories_rounded,
                      label: 'القراءة',
                      index: 1,
                    ),
                    _buildNavItem(
                      context,
                      provider,
                      icon: Icons.grid_view_rounded,
                      label: 'الأجزاء',
                      index: 2,
                    ),
                    _buildNavItem(
                      context,
                      provider,
                      icon: Icons.pin_rounded,
                      label: 'صفحة',
                      index: 3,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    AppProvider provider, {
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = provider.currentNavIndex == index;

    return GestureDetector(
      onTap: () => provider.setNavIndex(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.accentLight : Colors.white54,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.accentLight : Colors.white54,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
