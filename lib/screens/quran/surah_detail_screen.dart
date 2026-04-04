import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/quran_data.dart';
import '../../theme/app_theme.dart';
import '../../providers/memory_provider.dart';
import '../hifz/hifz_session_screen.dart';

class SurahDetailScreen extends StatefulWidget {
  final QuranSurah surah;

  const SurahDetailScreen({super.key, required this.surah});

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  int _selectedStartVerse = 1;
  int _selectedEndVerse = 1;
  bool _showVerseSelector = false;

  @override
  void initState() {
    super.initState();
    _selectedEndVerse = widget.surah.versesCount > 5 ? 5 : widget.surah.versesCount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildHeader(),
          SliverToBoxAdapter(child: _buildSurahInfo()),
          SliverToBoxAdapter(child: _buildActionButtons()),
          if (_showVerseSelector) SliverToBoxAdapter(child: _buildVerseSelector()),
          SliverToBoxAdapter(child: _buildVersesGrid()),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppTheme.deepNavy,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.quranHeaderGradient,
          ),
          child: Stack(
            children: [
              // Decorative pattern
              Positioned(
                right: -30,
                top: -30,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primaryGold.withValues(alpha: 0.08),
                      width: 1,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primaryGold.withValues(alpha: 0.05),
                      width: 1,
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Surah number badge
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.primaryGold.withValues(alpha: 0.5),
                            width: 2,
                          ),
                          color: AppTheme.primaryGold.withValues(alpha: 0.1),
                        ),
                        child: Center(
                          child: Text(
                            '${widget.surah.number}',
                            style: const TextStyle(
                              color: AppTheme.primaryGold,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [AppTheme.primaryGold, AppTheme.lightGold],
                        ).createShader(bounds),
                        child: Text(
                          'سورة ${widget.surah.name}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.surah.englishName,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSurahInfo() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem('عدد الآيات', '${widget.surah.versesCount}', Icons.format_list_numbered),
          _buildInfoDivider(),
          _buildInfoItem('نوع السورة', widget.surah.revelationType, Icons.location_on_outlined),
          _buildInfoDivider(),
          _buildInfoItem('رقم الصفحة', '${widget.surah.page}', Icons.menu_book_outlined),
          _buildInfoDivider(),
          _buildInfoItem('الجزء', '${widget.surah.juz}', Icons.bookmark_outline),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.deepTeal, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppTheme.textGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoDivider() {
    return Container(
      height: 40,
      width: 1,
      color: AppTheme.divider,
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              'ابدأ الحفظ',
              Icons.school_rounded,
              AppTheme.deepTeal,
              () {
                setState(() => _showVerseSelector = !_showVerseSelector);
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              'إضافة للمحفوظات',
              Icons.add_circle_outline,
              AppTheme.primaryGold,
              () => _addToMemory(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerseSelector() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.cream,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryGold.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.tune_rounded, color: AppTheme.deepTeal, size: 20),
              SizedBox(width: 8),
              Text(
                'اختر نطاق الآيات للحفظ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('من الآية:', style: TextStyle(fontSize: 12, color: AppTheme.textGrey)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.divider),
                      ),
                      child: DropdownButton<int>(
                        value: _selectedStartVerse,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: List.generate(
                          widget.surah.versesCount,
                          (i) => DropdownMenuItem(value: i + 1, child: Text('${i + 1}')),
                        ),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedStartVerse = val;
                              if (_selectedEndVerse < val) {
                                _selectedEndVerse = val;
                              }
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('إلى الآية:', style: TextStyle(fontSize: 12, color: AppTheme.textGrey)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.divider),
                      ),
                      child: DropdownButton<int>(
                        value: _selectedEndVerse,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: List.generate(
                          widget.surah.versesCount - _selectedStartVerse + 1,
                          (i) => DropdownMenuItem(
                            value: _selectedStartVerse + i,
                            child: Text('${_selectedStartVerse + i}'),
                          ),
                        ),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedEndVerse = val);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HifzSessionScreen(
                      surah: widget.surah,
                      startVerse: _selectedStartVerse,
                      endVerse: _selectedEndVerse,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.play_circle_filled_rounded, size: 22),
              label: Text(
                'ابدأ حفظ الآيات $_selectedStartVerse - $_selectedEndVerse',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.deepTeal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersesGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.grid_view_rounded, size: 18, color: AppTheme.deepTeal),
              const SizedBox(width: 8),
              const Text(
                'الآيات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const Spacer(),
              Text(
                '${widget.surah.versesCount} آية',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: widget.surah.versesCount,
            itemBuilder: (context, index) {
              final verseNum = index + 1;
              final isInRange = verseNum >= _selectedStartVerse && verseNum <= _selectedEndVerse;

              return InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HifzSessionScreen(
                        surah: widget.surah,
                        startVerse: verseNum,
                        endVerse: verseNum,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isInRange
                        ? AppTheme.deepTeal.withValues(alpha: 0.12)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isInRange
                          ? AppTheme.deepTeal.withValues(alpha: 0.4)
                          : AppTheme.divider.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$verseNum',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isInRange ? FontWeight.bold : FontWeight.normal,
                        color: isInRange ? AppTheme.deepTeal : AppTheme.textMedium,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _addToMemory() {
    final provider = context.read<MemoryProvider>();
    provider.addItem(
      title: 'سورة ${widget.surah.name}',
      content: 'حفظ سورة ${widget.surah.name} - ${widget.surah.versesCount} آية - ${widget.surah.revelationType}',
      category: 'quran',
      hints: ['سورة رقم ${widget.surah.number}', '${widget.surah.revelationType}', 'الجزء ${widget.surah.juz}'],
      colorIndex: 1,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Text('تمت إضافة سورة ${widget.surah.name} للمحفوظات'),
          ],
        ),
        backgroundColor: AppTheme.emerald,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
