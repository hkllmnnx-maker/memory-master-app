import 'package:flutter/material.dart';

class IconHelper {
  static IconData getIcon(String name) {
    switch (name) {
      case 'menu_book':
        return Icons.menu_book;
      case 'auto_stories':
        return Icons.auto_stories;
      case 'translate':
        return Icons.translate;
      case 'school':
        return Icons.school;
      case 'edit_note':
        return Icons.edit_note;
      case 'lightbulb':
        return Icons.lightbulb;
      case 'science':
        return Icons.science;
      case 'history':
        return Icons.history_edu;
      case 'music':
        return Icons.music_note;
      case 'code':
        return Icons.code;
      case 'health':
        return Icons.health_and_safety;
      case 'sports':
        return Icons.sports;
      case 'work':
        return Icons.work;
      case 'psychology':
        return Icons.psychology;
      case 'mosque':
        return Icons.mosque;
      case 'star':
        return Icons.star;
      default:
        return Icons.bookmark;
    }
  }

  static List<Map<String, dynamic>> get availableIcons => [
    {'name': 'menu_book', 'icon': Icons.menu_book, 'label': 'كتاب'},
    {'name': 'auto_stories', 'icon': Icons.auto_stories, 'label': 'قصص'},
    {'name': 'translate', 'icon': Icons.translate, 'label': 'ترجمة'},
    {'name': 'school', 'icon': Icons.school, 'label': 'دراسة'},
    {'name': 'edit_note', 'icon': Icons.edit_note, 'label': 'كتابة'},
    {'name': 'lightbulb', 'icon': Icons.lightbulb, 'label': 'فكرة'},
    {'name': 'science', 'icon': Icons.science, 'label': 'علوم'},
    {'name': 'history', 'icon': Icons.history_edu, 'label': 'تاريخ'},
    {'name': 'psychology', 'icon': Icons.psychology, 'label': 'عقل'},
    {'name': 'mosque', 'icon': Icons.mosque, 'label': 'مسجد'},
    {'name': 'star', 'icon': Icons.star, 'label': 'نجمة'},
    {'name': 'code', 'icon': Icons.code, 'label': 'برمجة'},
  ];
}
