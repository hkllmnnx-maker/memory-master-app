import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/memory_provider.dart';
import '../../services/backup_service.dart';
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

                // Backup
                _sectionTitle('النسخ الاحتياطي', Icons.backup_rounded, isDark),
                const SizedBox(height: 10),
                _tile(
                  context: context,
                  isDark: isDark,
                  icon: Icons.file_upload_rounded,
                  color: AppTheme.emerald,
                  title: 'تصدير البيانات',
                  subtitle: 'حفظ نسخة من محفوظاتك',
                  onTap: () => _exportData(context),
                ),
                const SizedBox(height: 10),
                _tile(
                  context: context,
                  isDark: isDark,
                  icon: Icons.file_download_rounded,
                  color: AppTheme.skyBlue,
                  title: 'استيراد البيانات',
                  subtitle: 'استعادة بيانات من نسخة سابقة',
                  onTap: () => _importData(context),
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

  Future<void> _exportData(BuildContext context) async {
    final data = BackupService.exportData();
    if (!context.mounted) return;
    await showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('تصدير البيانات',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.emerald.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: AppTheme.emerald),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'تم تجهيز بيانات بحجم ${(data.length / 1024).toStringAsFixed(1)} كيلوبايت',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'انسخ البيانات التالية واحفظها في مكان آمن',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 10),
              Container(
                constraints: const BoxConstraints(maxHeight: 150),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppTheme.darkBg
                      : AppTheme.cream,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    data.length > 500
                        ? '${data.substring(0, 500)}...\n\n[${data.length - 500} حرف إضافي]'
                        : data,
                    style: const TextStyle(
                        fontSize: 10, fontFamily: 'monospace'),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إغلاق'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: data));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم نسخ البيانات إلى الحافظة'),
                    backgroundColor: AppTheme.emerald,
                  ),
                );
                Navigator.pop(context);
              },
              icon: const Icon(Icons.copy_rounded),
              label: const Text('نسخ'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _importData(BuildContext context) async {
    final controller = TextEditingController();
    if (!context.mounted) return;
    await showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('استيراد البيانات',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.warmOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning_rounded, color: AppTheme.warmOrange),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'الاستيراد سيضيف البيانات إلى ما هو موجود حالياً',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: controller,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: 'ألصق بيانات التصدير هنا...',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(
                    fontSize: 12, fontFamily: 'monospace'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (controller.text.trim().isEmpty) return;
                Navigator.pop(ctx);
                final result =
                    await BackupService.importData(controller.text);
                if (!context.mounted) return;
                if (result.success) {
                  context.read<MemoryProvider>().loadData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'تم استيراد ${result.itemsCount} محفوظ و ${result.categoriesCount} تصنيف'),
                      backgroundColor: AppTheme.emerald,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result.error ?? 'فشل استيراد البيانات'),
                      backgroundColor: AppTheme.coral,
                    ),
                  );
                }
              },
              child: const Text('استيراد'),
            ),
          ],
        ),
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
