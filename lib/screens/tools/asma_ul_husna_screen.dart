import 'package:flutter/material.dart';
import '../../data/asma_ul_husna_data.dart';
import '../../theme/app_theme.dart';

class AsmaUlHusnaScreen extends StatefulWidget {
  const AsmaUlHusnaScreen({super.key});

  @override
  State<AsmaUlHusnaScreen> createState() => _AsmaUlHusnaScreenState();
}

class _AsmaUlHusnaScreenState extends State<AsmaUlHusnaScreen> {
  String _query = '';
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<DivineName> get _filtered {
    if (_query.isEmpty) return AsmaUlHusnaData.names;
    return AsmaUlHusnaData.names
        .where((n) =>
            n.name.contains(_query) ||
            n.transliteration
                .toLowerCase()
                .contains(_query.toLowerCase()) ||
            n.meaning.contains(_query) ||
            n.number.toString() == _query)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final list = _filtered;

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
                      padding:
                          const EdgeInsets.fromLTRB(20, 56, 20, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: (b) => const LinearGradient(
                              colors: [
                                AppTheme.primaryGold,
                                AppTheme.lightGold
                              ],
                            ).createShader(b),
                            child: const Text(
                              'الأسماء الحسنى',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '«وَلِلَّهِ الْأَسْمَاءُ الْحُسْنَىٰ فَادْعُوهُ بِهَا»',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.75),
                              fontFamily: 'Amiri',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    Colors.white.withValues(alpha: 0.12),
                              ),
                            ),
                            child: TextField(
                              controller: _controller,
                              style: const TextStyle(color: Colors.white),
                              onChanged: (v) => setState(() => _query = v),
                              decoration: InputDecoration(
                                hintText: 'ابحث في الأسماء...',
                                hintStyle: TextStyle(
                                    color: Colors.white
                                        .withValues(alpha: 0.5)),
                                prefixIcon: Icon(Icons.search_rounded,
                                    color: Colors.white
                                        .withValues(alpha: 0.6)),
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                filled: false,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 40),
              sliver: SliverGrid.builder(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.85,
                ),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final n = list[index];
                  final colorIndex = n.number % AppTheme.categoryColors.length;
                  final color = AppTheme.categoryColors[colorIndex];
                  return _NameCard(
                    name: n,
                    color: color,
                    isDark: isDark,
                    onTap: () => _showDetails(context, n, color, isDark),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, DivineName n, Color color, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkCardBg : Colors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkDivider : AppTheme.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${n.number} من 99',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ShaderMask(
                shaderCallback: (b) => LinearGradient(
                  colors: [color, color.withValues(alpha: 0.7)],
                ).createShader(b),
                child: Text(
                  n.name,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Amiri',
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                n.transliteration,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? AppTheme.darkTextSecondary
                      : AppTheme.textGrey,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: color.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  n.meaning,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.8,
                    color: isDark
                        ? AppTheme.darkTextPrimary
                        : AppTheme.textDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NameCard extends StatelessWidget {
  final DivineName name;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _NameCard({
    required this.name,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkCardBg : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withValues(alpha: 0.25),
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.7)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '${name.number}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Center(
                  child: Text(
                    name.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppTheme.darkTextPrimary
                          : AppTheme.textDark,
                      fontFamily: 'Amiri',
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                name.transliteration,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark
                      ? AppTheme.darkTextMuted
                      : AppTheme.textGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
