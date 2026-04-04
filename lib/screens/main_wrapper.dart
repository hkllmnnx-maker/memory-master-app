import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'all_items_screen.dart';
import 'stats_screen.dart';
import 'add_item_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    AllItemsScreen(),
    StatsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, 'الرئيسية'),
                  _buildNavItem(1, Icons.library_books_rounded, Icons.library_books_outlined, 'محفوظاتي'),
                  _buildAddButton(),
                  _buildNavItem(2, Icons.bar_chart_rounded, Icons.bar_chart_outlined, 'إحصائيات'),
                  _buildSettingsButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData icon, String label) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.coral.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppTheme.coral : AppTheme.textLight,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? AppTheme.coral : AppTheme.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddItemScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.coral.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 26,
        ),
      ),
    );
  }

  Widget _buildSettingsButton() {
    return GestureDetector(
      onTap: () => _showSettingsSheet(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.settings_outlined,
            color: AppTheme.textLight,
            size: 24,
          ),
          const SizedBox(height: 2),
          const Text(
            'الإعدادات',
            style: TextStyle(
              fontSize: 10,
              color: AppTheme.textLight,
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'الإعدادات',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildSettingsTile(
                Icons.info_outline,
                'عن التطبيق',
                'ذاكرة الحفظ - نسخة 1.0.0',
                AppTheme.softPurple,
                () {},
              ),
              _buildSettingsTile(
                Icons.science,
                'طريقة الحفظ',
                'نظام التكرار المتباعد SM-2',
                AppTheme.teal,
                () => _showMethodInfo(ctx),
              ),
              _buildSettingsTile(
                Icons.share,
                'مشاركة التطبيق',
                'شارك التطبيق مع أصدقائك',
                AppTheme.coral,
                () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showMethodInfo(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (dialogCtx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text(
            'نظام التكرار المتباعد',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const SingleChildScrollView(
            child: Text(
              'يعتمد التطبيق على خوارزمية SM-2 العلمية التي طورها العالم Piotr Wozniak.\n\n'
              'المبدأ: بدلاً من تكرار المعلومات بشكل عشوائي، يقوم النظام بجدولة المراجعة في أوقات محددة علمياً:\n\n'
              '• المراجعة الأولى: فوري\n'
              '• المراجعة الثانية: بعد يوم\n'
              '• المراجعة الثالثة: بعد 3 أيام\n'
              '• المراجعة الرابعة: بعد أسبوع\n'
              '• المراجعة الخامسة: بعد أسبوعين\n'
              '• المراجعة السادسة: بعد شهر\n'
              '• المراجعة السابعة: بعد شهرين\n'
              '• المراجعة الثامنة: بعد 4 أشهر\n\n'
              'كلما أجبت بشكل صحيح، تزداد الفترة بين المراجعات. وإذا نسيت، يعود النظام لتقصير الفترات.\n\n'
              'هذه الطريقة مثبتة علمياً أنها أفضل طريقة لنقل المعلومات من الذاكرة قصيرة المدى إلى الذاكرة طويلة المدى.',
              textAlign: TextAlign.right,
              style: TextStyle(height: 1.6),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('حسناً'),
            ),
          ],
        ),
      ),
    );
  }
}
