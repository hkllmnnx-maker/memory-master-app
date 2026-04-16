import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/azkar_data.dart';
import '../../theme/app_theme.dart';

class AzkarReaderScreen extends StatefulWidget {
  final AzkarCategory category;
  const AzkarReaderScreen({super.key, required this.category});

  @override
  State<AzkarReaderScreen> createState() => _AzkarReaderScreenState();
}

class _AzkarReaderScreenState extends State<AzkarReaderScreen> {
  late List<int> _counters;

  @override
  void initState() {
    super.initState();
    _counters =
        List<int>.filled(widget.category.items.length, 0, growable: false);
  }

  void _tapAzkar(int index) {
    final item = widget.category.items[index];
    if (_counters[index] < item.count) {
      setState(() => _counters[index]++);
      HapticFeedback.lightImpact();
      if (_counters[index] == item.count) {
        HapticFeedback.heavyImpact();
      }
    }
  }

  void _reset() {
    setState(() {
      for (int i = 0; i < _counters.length; i++) {
        _counters[i] = 0;
      }
    });
  }

  double get _totalProgress {
    int total = 0;
    int done = 0;
    for (int i = 0; i < widget.category.items.length; i++) {
      total += widget.category.items[i].count;
      done += _counters[i];
    }
    return total == 0 ? 0 : done / total;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 170,
              backgroundColor: AppTheme.deepTeal,
              iconTheme: const IconThemeData(color: Colors.white),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: AppTheme.quranHeaderGradient,
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) =>
                                const LinearGradient(
                              colors: [
                                AppTheme.primaryGold,
                                AppTheme.lightGold
                              ],
                            ).createShader(bounds),
                            child: Text(
                              widget.category.title,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.category.subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: _totalProgress,
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.1),
                              valueColor: const AlwaysStoppedAnimation(
                                  AppTheme.primaryGold),
                              minHeight: 6,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${(_totalProgress * 100).toInt()}% مكتمل',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  tooltip: 'إعادة تعيين',
                  icon: const Icon(Icons.refresh_rounded),
                  onPressed: _reset,
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.separated(
                itemCount: widget.category.items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _AzkarCard(
                    item: widget.category.items[index],
                    currentCount: _counters[index],
                    index: index + 1,
                    total: widget.category.items.length,
                    isDark: isDark,
                    onTap: () => _tapAzkar(index),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}

class _AzkarCard extends StatelessWidget {
  final AzkarItem item;
  final int currentCount;
  final int index;
  final int total;
  final bool isDark;
  final VoidCallback onTap;

  const _AzkarCard({
    required this.item,
    required this.currentCount,
    required this.index,
    required this.total,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = currentCount >= item.count;
    final progress = item.count == 0 ? 0.0 : currentCount / item.count;

    return Material(
      color: isDark ? AppTheme.darkCardBg : Colors.white,
      borderRadius: BorderRadius.circular(18),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDone
                  ? AppTheme.emerald.withValues(alpha: 0.5)
                  : (isDark
                      ? AppTheme.darkDivider
                      : AppTheme.divider.withValues(alpha: 0.6)),
              width: isDone ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGold.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$index / $total',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkGold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (item.source != null) ...[
                    Icon(Icons.book_outlined,
                        size: 13,
                        color: isDark
                            ? AppTheme.darkTextMuted
                            : AppTheme.textGrey),
                    const SizedBox(width: 4),
                    Text(
                      item.source!,
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark
                            ? AppTheme.darkTextMuted
                            : AppTheme.textGrey,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Text(
                item.text,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 18,
                  height: 2.0,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppTheme.darkTextPrimary
                      : AppTheme.textDark,
                  fontFamily: 'Amiri',
                ),
              ),
              if (item.fadl != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGold.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppTheme.primaryGold.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 16, color: AppTheme.darkGold),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.fadl!,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppTheme.lightGold
                                : AppTheme.darkGold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: isDark
                            ? AppTheme.darkDivider
                            : AppTheme.cream,
                        valueColor: AlwaysStoppedAnimation(
                          isDone ? AppTheme.emerald : AppTheme.deepTeal,
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDone
                            ? [AppTheme.emerald, AppTheme.softEmerald]
                            : [AppTheme.deepTeal, AppTheme.teal],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: (isDone
                                  ? AppTheme.emerald
                                  : AppTheme.deepTeal)
                              .withValues(alpha: 0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isDone ? Icons.check_rounded : Icons.touch_app_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$currentCount / ${item.count}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
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
}
