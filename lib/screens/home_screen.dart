import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/memory_provider.dart';
import '../theme/app_theme.dart';
import '../utils/icon_helper.dart';
import '../services/spaced_repetition_service.dart';
import '../data/quran_data.dart';
import '../data/daily_wisdom_data.dart';
import 'add_item_screen.dart';
import 'review_screen.dart';
import 'category_items_screen.dart';
import 'quran/surah_detail_screen.dart';
import 'tools/daily_wisdom_screen.dart';
import 'tools/azkar_shortcut.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? AppTheme.darkTextPrimary : AppTheme.textDark;
    return Consumer<MemoryProvider>(
      builder: (context, provider, _) {
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context, provider)),
            SliverToBoxAdapter(child: _buildQuickStats(context, provider)),
            if (provider.dueCount > 0)
              SliverToBoxAdapter(child: _buildReviewBanner(context, provider)),
            SliverToBoxAdapter(child: _buildQuranQuickAccess(context)),
            const SliverToBoxAdapter(child: AzkarShortcutRow()),
            SliverToBoxAdapter(child: _buildDailyWisdomCard(context)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Text(
                  'التصنيفات',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(child: _buildCategoriesGrid(context, provider)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Text(
                  'آخر المحفوظات',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
              ),
            ),
            _buildRecentItems(context, provider),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, MemoryProvider provider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
      decoration: const BoxDecoration(
        gradient: AppTheme.headerGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'السلام عليكم',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [AppTheme.primaryGold, AppTheme.lightGold],
                    ).createShader(bounds),
                    child: const Text(
                      'ذاكرة الحفظ',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.primaryGold.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_fire_department_rounded, color: AppTheme.primaryGold, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      '${provider.streak}',
                      style: const TextStyle(
                        color: AppTheme.primaryGold,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'يوم',
                      style: TextStyle(color: AppTheme.primaryGold.withValues(alpha: 0.7), fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.lightbulb_outline, color: AppTheme.primaryGold, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    SpacedRepetitionService.getMemorizationTip(
                      provider.items.isEmpty ? 0 : provider.items.first.repetitionLevel,
                    ),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, MemoryProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      child: Row(
        children: [
          _buildStatCard('المحفوظات', '${provider.totalItems}', Icons.library_books_rounded, AppTheme.deepTeal),
          const SizedBox(width: 10),
          _buildStatCard('تحتاج مراجعة', '${provider.dueCount}', Icons.alarm_rounded, AppTheme.coral),
          const SizedBox(width: 10),
          _buildStatCard('تم إتقانها', '${provider.masteredCount}', Icons.emoji_events_rounded, AppTheme.primaryGold),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Builder(builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkCardBg : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: isDark ? 0.15 : 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                    fontSize: 10,
                    color: isDark
                        ? AppTheme.darkTextSecondary
                        : AppTheme.textGrey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildReviewBanner(BuildContext context, MemoryProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ReviewScreen(items: provider.dueItems)),
          );
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: AppTheme.tealGradient,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppTheme.deepTeal.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.play_circle_filled_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ابدأ المراجعة الآن',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'لديك ${provider.dueCount} محفوظات تحتاج مراجعة',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailyWisdomCard(BuildContext context) {
    final wisdom = DailyWisdomData.getDailyVerse();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DailyWisdomScreen()),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryGold.withValues(alpha: isDark ? 0.18 : 0.12),
                AppTheme.deepTeal.withValues(alpha: isDark ? 0.22 : 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.primaryGold.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      gradient: AppTheme.goldGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.menu_book_rounded,
                        color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'آية اليوم',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppTheme.lightGold : AppTheme.darkGold,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: isDark
                          ? AppTheme.darkTextMuted
                          : AppTheme.textGrey),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                wisdom.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  height: 2.0,
                  fontFamily: 'Amiri',
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppTheme.darkTextPrimary
                      : AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    wisdom.source,
                    style: TextStyle(
                      fontSize: 11,
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
      ),
    );
  }

  Widget _buildQuranQuickAccess(BuildContext context) {
    final quickSurahs = [
      QuranData.surahs[0],  // الفاتحة
      QuranData.surahs[35], // يس
      QuranData.surahs[54], // الرحمن
      QuranData.surahs[66], // الملك
      QuranData.surahs[17], // الكهف
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Builder(builder: (context) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.menu_book_rounded,
                      size: 16, color: AppTheme.primaryGold),
                ),
                const SizedBox(width: 8),
                Text(
                  'سور مختارة',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppTheme.darkTextPrimary
                          : AppTheme.textDark),
                ),
              ],
            );
          }),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: quickSurahs.length,
              itemBuilder: (context, index) {
                final surah = quickSurahs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SurahDetailScreen(surah: surah)),
                    );
                  },
                  child: Container(
                    width: 110,
                    margin: const EdgeInsets.only(left: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.deepNavy.withValues(alpha: 0.9),
                          AppTheme.deepTeal.withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${surah.number}',
                          style: const TextStyle(
                            color: AppTheme.primaryGold,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          surah.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${surah.versesCount} آية',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesGrid(BuildContext context, MemoryProvider provider) {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: provider.categories.length + 1,
        itemBuilder: (context, index) {
          if (index == provider.categories.length) {
            return _buildAddCategoryCard(context);
          }
          final cat = provider.categories[index];
          final count = provider.items.where((i) => i.category == cat.id).length;
          final color = AppTheme.categoryColors[cat.colorIndex % AppTheme.categoryColors.length];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CategoryItemsScreen(category: cat)),
              );
            },
            child: Container(
              width: 105,
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: color.withValues(alpha: 0.15)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(IconHelper.getIcon(cat.icon), color: color, size: 26),
                  const SizedBox(height: 8),
                  Text(
                    cat.name,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$count محفوظ',
                    style: TextStyle(fontSize: 9, color: color.withValues(alpha: 0.6)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddCategoryCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => _showAddCategoryDialog(context),
      child: Container(
        width: 105,
        margin: const EdgeInsets.only(left: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCardBg : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: isDark ? AppTheme.darkDivider : Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline,
                color: isDark ? AppTheme.darkTextMuted : AppTheme.textGrey,
                size: 26),
            const SizedBox(height: 8),
            Text('إضافة فئة',
                style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppTheme.darkTextMuted
                        : AppTheme.textGrey)),
          ],
        ),
      ),
    );
  }

  SliverList _buildRecentItems(BuildContext context, MemoryProvider provider) {
    final recent = provider.items.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final display = recent.take(5).toList();

    if (display.isEmpty) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return SliverList(
        delegate: SliverChildListDelegate([
          Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.darkCardBg : AppTheme.cream,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit_note_rounded,
                      size: 40, color: AppTheme.deepTeal),
                ),
                const SizedBox(height: 16),
                Text(
                  'لا توجد محفوظات بعد',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppTheme.darkTextPrimary
                          : AppTheme.textDark),
                ),
                const SizedBox(height: 8),
                Text(
                  'ابدأ بحفظ القرآن أو أضف محفوظاً جديداً',
                  style: TextStyle(
                      color: isDark
                          ? AppTheme.darkTextSecondary
                          : AppTheme.textGrey,
                      fontSize: 13),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const AddItemScreen()));
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة محفوظ'),
                ),
              ],
            ),
          ),
        ]),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = display[index];
          final color = AppTheme.categoryColors[item.colorIndex % AppTheme.categoryColors.length];
          final cat = provider.categories.where((c) => c.id == item.category).firstOrNull;

          final isDark = Theme.of(context).brightness == Brightness.dark;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkCardBg : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.7)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    item.title.characters.first,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              title: Text(
                item.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isDark ? AppTheme.darkTextPrimary : AppTheme.textDark,
                ),
              ),
              subtitle: Row(
                children: [
                  Text(cat?.name ?? 'عام',
                      style: TextStyle(fontSize: 11, color: color)),
                  const SizedBox(width: 6),
                  Text(
                    item.masteryLevelText,
                    style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? AppTheme.darkTextSecondary
                            : AppTheme.textGrey),
                  ),
                ],
              ),
              trailing: item.isDueForReview
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.coral.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'مراجعة',
                        style: TextStyle(fontSize: 10, color: AppTheme.coral, fontWeight: FontWeight.bold),
                      ),
                    )
                  : Text(
                      SpacedRepetitionService.getNextReviewText(item),
                      style: const TextStyle(fontSize: 10, color: AppTheme.textGrey),
                    ),
            ),
          );
        },
        childCount: display.length,
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final nameController = TextEditingController();
    String selectedIcon = 'lightbulb';
    int selectedColorIndex = 0;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('إضافة تصنيف جديد', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    decoration: const InputDecoration(hintText: 'اسم التصنيف', prefixIcon: Icon(Icons.category)),
                  ),
                  const SizedBox(height: 16),
                  const Align(alignment: Alignment.centerRight, child: Text('اختر أيقونة:', style: TextStyle(fontWeight: FontWeight.bold))),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: IconHelper.availableIcons.map((ic) {
                      final isSelected = selectedIcon == ic['name'];
                      return GestureDetector(
                        onTap: () => setDialogState(() => selectedIcon = ic['name'] as String),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.deepTeal.withValues(alpha: 0.15) : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                            border: isSelected ? Border.all(color: AppTheme.deepTeal, width: 2) : null,
                          ),
                          child: Icon(ic['icon'] as IconData, color: isSelected ? AppTheme.deepTeal : AppTheme.textGrey, size: 24),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Align(alignment: Alignment.centerRight, child: Text('اختر لوناً:', style: TextStyle(fontWeight: FontWeight.bold))),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: List.generate(
                      AppTheme.categoryColors.length,
                      (i) => GestureDetector(
                        onTap: () => setDialogState(() => selectedColorIndex = i),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppTheme.categoryColors[i],
                            shape: BoxShape.circle,
                            border: selectedColorIndex == i ? Border.all(color: Colors.black54, width: 3) : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.trim().isNotEmpty) {
                    context.read<MemoryProvider>().addCategory(
                      name: nameController.text.trim(),
                      icon: selectedIcon,
                      colorIndex: selectedColorIndex,
                    );
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('إضافة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
