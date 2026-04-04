import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/memory_provider.dart';
import '../theme/app_theme.dart';
import '../utils/icon_helper.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _hintController = TextEditingController();
  String _selectedCategory = '';
  int _selectedColor = 0;
  final List<String> _hints = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final categories = context.read<MemoryProvider>().categories;
      if (categories.isNotEmpty) {
        setState(() {
          _selectedCategory = categories.first.id;
        });
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _hintController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MemoryProvider>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // الهيدر
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'إضافة محفوظ جديد',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // عنوان المحفوظ
                    _buildSectionTitle('عنوان المحفوظ', Icons.title),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleController,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        hintText: 'مثال: سورة الفاتحة، كلمات إنجليزية...',
                        hintTextDirection: TextDirection.rtl,
                        prefixIcon: const Icon(Icons.bookmark_outline),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'يرجى إدخال عنوان المحفوظ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // المحتوى
                    _buildSectionTitle('المحتوى المراد حفظه', Icons.edit_document),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _contentController,
                      textDirection: TextDirection.rtl,
                      maxLines: 6,
                      decoration: InputDecoration(
                        hintText: 'اكتب النص الذي تريد حفظه هنا...',
                        hintTextDirection: TextDirection.rtl,
                        alignLabelWithHint: true,
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'يرجى إدخال المحتوى';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // التصنيف
                    _buildSectionTitle('التصنيف', Icons.category),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: provider.categories.map((cat) {
                        final isSelected = _selectedCategory == cat.id;
                        final color = AppTheme.categoryColors[
                            cat.colorIndex % AppTheme.categoryColors.length];
                        return GestureDetector(
                          onTap: () => setState(() => _selectedCategory = cat.id),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? color.withValues(alpha: 0.2)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(14),
                              border: isSelected
                                  ? Border.all(color: color, width: 2)
                                  : null,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  IconHelper.getIcon(cat.icon),
                                  color: isSelected ? color : AppTheme.textGrey,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  cat.name,
                                  style: TextStyle(
                                    color: isSelected ? color : AppTheme.textGrey,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // التلميحات
                    _buildSectionTitle('تلميحات للمساعدة (اختياري)', Icons.lightbulb_outline),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _hintController,
                            textDirection: TextDirection.rtl,
                            decoration: InputDecoration(
                              hintText: 'أضف تلميح...',
                              hintTextDirection: TextDirection.rtl,
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filled(
                          onPressed: () {
                            if (_hintController.text.trim().isNotEmpty) {
                              setState(() {
                                _hints.add(_hintController.text.trim());
                                _hintController.clear();
                              });
                            }
                          },
                          icon: const Icon(Icons.add),
                          style: IconButton.styleFrom(
                            backgroundColor: AppTheme.teal,
                          ),
                        ),
                      ],
                    ),
                    if (_hints.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _hints.asMap().entries.map((entry) {
                          return Chip(
                            label: Text(
                              entry.value,
                              style: const TextStyle(fontSize: 12),
                            ),
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () {
                              setState(() => _hints.removeAt(entry.key));
                            },
                            backgroundColor: AppTheme.golden.withValues(alpha: 0.15),
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 24),

                    // لون البطاقة
                    _buildSectionTitle('لون البطاقة', Icons.palette),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      children: List.generate(
                        AppTheme.categoryColors.length,
                        (i) => GestureDetector(
                          onTap: () => setState(() => _selectedColor = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppTheme.categoryColors[i],
                              shape: BoxShape.circle,
                              border: _selectedColor == i
                                  ? Border.all(color: Colors.black54, width: 3)
                                  : null,
                              boxShadow: _selectedColor == i
                                  ? [
                                      BoxShadow(
                                        color: AppTheme.categoryColors[i]
                                            .withValues(alpha: 0.4),
                                        blurRadius: 8,
                                      )
                                    ]
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // زر الحفظ
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _saveItem,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.coral,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 4,
                          shadowColor: AppTheme.coral.withValues(alpha: 0.4),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save_rounded, size: 22),
                            SizedBox(width: 10),
                            Text(
                              'حفظ المحفوظ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.softPurple),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
          ),
        ),
      ],
    );
  }

  void _saveItem() {
    if (_formKey.currentState!.validate() && _selectedCategory.isNotEmpty) {
      context.read<MemoryProvider>().addItem(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        category: _selectedCategory,
        hints: _hints,
        colorIndex: _selectedColor,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text('تم إضافة المحفوظ بنجاح!'),
            ],
          ),
          backgroundColor: AppTheme.mintGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

      Navigator.pop(context);
    }
  }
}
