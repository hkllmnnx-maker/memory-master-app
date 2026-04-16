import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الإعدادات',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: Consumer<SettingsProvider>(
          builder: (context, settings, _) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Appearance
                _sectionTitle('المظهر', Icons.palette_rounded, isDark),
                const SizedBox(height: 10),
                _tile(
                  context: context,
                  isDark: isDark,
                  icon: settings.isDarkMode
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  color: AppTheme.softPurple,
                  title: 'الوضع الليلي',
                  subtitle: settings.isDarkMode ? 'مفعّل' : 'غير مفعّل',
                  trailing: Switch(
                    value: settings.isDarkMode,
                    onChanged: (_) => settings.toggleDarkMode(),
                  ),
                ),
                const SizedBox(height: 10),
                _tile(
                  context: context,
                  isDark: isDark,
                  icon: Icons.color_lens_rounded,
                  color: SettingsProvider.availablePrimaryColors[
                      settings.primaryColorIndex]['color'] as Color,
                  title: 'اللون الرئيسي',
                  subtitle: SettingsProvider.availablePrimaryColors[
                      settings.primaryColorIndex]['name'] as String,
                  onTap: () => _showColorPicker(context, settings),
                ),
                const SizedBox(height: 10),
                _buildFontScaleTile(context, settings, isDark),
                const SizedBox(height: 24),

                // Study
                _sectionTitle('الحفظ والدراسة', Icons.school_rounded, isDark),
                const SizedBox(height: 10),
                _buildDailyGoalTile(context, settings, isDark),
                const SizedBox(height: 10),
                _tile(
                  context: context,
                  isDark: isDark,
                  icon: Icons.notifications_active_rounded,
                  color: AppTheme.warmOrange,
                  title: 'التذكيرات اليومية',
                  subtitle:
                      settings.notificationsEnabled ? 'مفعّلة' : 'متوقفة',
                  trailing: Switch(
                    value: settings.notificationsEnabled,
                    onChanged: settings.setNotificationsEnabled,
                  ),
                ),
                const SizedBox(height: 10),
                _tile(
                  context: context,
                  isDark: isDark,
                  icon: Icons.volume_up_rounded,
                  color: AppTheme.skyBlue,
                  title: 'الأصوات والاهتزاز',
                  subtitle: settings.soundEnabled ? 'مفعّل' : 'متوقف',
                  trailing: Switch(
                    value: settings.soundEnabled,
                    onChanged: settings.setSoundEnabled,
                  ),
                ),
                const SizedBox(height: 24),

                // About
                _sectionTitle('عن التطبيق', Icons.info_rounded, isDark),
                const SizedBox(height: 10),
                _tile(
                  context: context,
                  isDark: isDark,
                  icon: Icons.star_rounded,
                  color: AppTheme.primaryGold,
                  title: 'ذاكرة الحفظ',
                  subtitle: 'الإصدار 1.1.0',
                  onTap: () => showAboutDialog(
                    context: context,
                    applicationName: 'ذاكرة الحفظ',
                    applicationVersion: '1.1.0',
                    applicationIcon: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: AppTheme.goldGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.menu_book_rounded,
                          color: Colors.white, size: 30),
                    ),
                    children: const [
                      SizedBox(height: 10),
                      Text(
                        'تطبيق احترافي لحفظ القرآن الكريم والأدعية والمحفوظات العلمية باستخدام تقنية التكرار المتباعد.',
                        style: TextStyle(height: 1.6),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _tile(
                  context: context,
                  isDark: isDark,
                  icon: Icons.favorite_rounded,
                  color: AppTheme.coral,
                  title: 'تقييم التطبيق',
                  subtitle: 'ساعدنا في تحسين التطبيق',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('شكراً لاهتمامك! سيتم إضافة هذه الميزة قريباً'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(right: 4, bottom: 4),
      child: Row(
        children: [
          Icon(icon,
              color: isDark ? AppTheme.primaryGold : AppTheme.deepTeal,
              size: 18),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? AppTheme.darkTextPrimary : AppTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: isDark ? AppTheme.darkCardBg : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark
                  ? AppTheme.darkDivider
                  : AppTheme.divider.withValues(alpha: 0.6),
            ),
          ),
          child: Row(
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
              if (trailing != null)
                trailing
              else if (onTap != null)
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 13,
                    color: isDark
                        ? AppTheme.darkTextMuted
                        : AppTheme.textLight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFontScaleTile(
      BuildContext context, SettingsProvider settings, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCardBg : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? AppTheme.darkDivider
              : AppTheme.divider.withValues(alpha: 0.6),
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
                  color: AppTheme.teal.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.text_fields_rounded,
                    color: AppTheme.teal, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'حجم الخط',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppTheme.darkTextPrimary
                            : AppTheme.textDark,
                      ),
                    ),
                    Text(
                      '${(settings.fontScale * 100).toInt()}%',
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
            ],
          ),
          Slider(
            value: settings.fontScale,
            min: 0.8,
            max: 1.6,
            divisions: 8,
            label: '${(settings.fontScale * 100).toInt()}%',
            onChanged: (v) => settings.setFontScale(v),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyGoalTile(
      BuildContext context, SettingsProvider settings, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCardBg : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? AppTheme.darkDivider
              : AppTheme.divider.withValues(alpha: 0.6),
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
                  color: AppTheme.emerald.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.flag_rounded,
                    color: AppTheme.emerald, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الهدف اليومي',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppTheme.darkTextPrimary
                            : AppTheme.textDark,
                      ),
                    ),
                    Text(
                      '${settings.dailyGoal} محفوظ يومياً',
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
            ],
          ),
          Slider(
            value: settings.dailyGoal.toDouble(),
            min: 5,
            max: 100,
            divisions: 19,
            label: '${settings.dailyGoal}',
            activeColor: AppTheme.emerald,
            onChanged: (v) => settings.setDailyGoal(v.toInt()),
          ),
        ],
      ),
    );
  }

  void _showColorPicker(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('اختر اللون الرئيسي',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: 300,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: SettingsProvider.availablePrimaryColors.length,
              itemBuilder: (context, index) {
                final colorData =
                    SettingsProvider.availablePrimaryColors[index];
                final color = colorData['color'] as Color;
                final isSelected = settings.primaryColorIndex == index;
                return GestureDetector(
                  onTap: () {
                    settings.setPrimaryColorIndex(index);
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color, color.withValues(alpha: 0.7)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: isSelected
                        ? const Center(
                            child: Icon(Icons.check_rounded,
                                color: Colors.white, size: 32),
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
