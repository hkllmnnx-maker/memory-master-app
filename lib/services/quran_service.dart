import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/quran_models.dart';

class QuranService {
  static final QuranService _instance = QuranService._internal();
  factory QuranService() => _instance;
  QuranService._internal();

  List<SurahInfo> _surahs = [];
  Map<int, List<AyahInfo>> _pages = {};
  Map<int, JuzInfo> _juzs = {};
  bool _isLoaded = false;

  List<SurahInfo> get surahs => _surahs;
  Map<int, JuzInfo> get juzs => _juzs;
  bool get isLoaded => _isLoaded;
  int get totalPages => 604;

  Future<void> loadQuranData() async {
    if (_isLoaded) return;

    final String jsonString =
        await rootBundle.loadString('assets/quran_data.json');
    final Map<String, dynamic> data = json.decode(jsonString);

    // Parse surahs
    _surahs = (data['surahs'] as List)
        .map((s) => SurahInfo.fromJson(s as Map<String, dynamic>))
        .toList();

    // Parse pages
    final pagesData = data['pages'] as Map<String, dynamic>;
    _pages = {};
    for (final entry in pagesData.entries) {
      final pageNum = int.parse(entry.key);
      _pages[pageNum] = (entry.value as List)
          .map((a) => AyahInfo.fromJson(a as Map<String, dynamic>))
          .toList();
    }

    // Parse juzs
    final juzsData = data['juzs'] as Map<String, dynamic>;
    _juzs = {};
    for (final entry in juzsData.entries) {
      final juzNum = int.parse(entry.key);
      _juzs[juzNum] = JuzInfo.fromJson(entry.value as Map<String, dynamic>);
    }

    _isLoaded = true;
  }

  PageData getPage(int pageNumber) {
    final ayahs = _pages[pageNumber] ?? [];
    final surahNumbers = ayahs.map((a) => a.surahNumber).toSet().toList();
    final juz = ayahs.isNotEmpty ? ayahs.first.juz : 1;
    return PageData(
      pageNumber: pageNumber,
      ayahs: ayahs,
      juz: juz,
      surahNumbers: surahNumbers,
    );
  }

  SurahInfo? getSurah(int number) {
    if (number < 1 || number > _surahs.length) return null;
    return _surahs[number - 1];
  }

  String getSurahNameForPage(int pageNumber) {
    final ayahs = _pages[pageNumber];
    if (ayahs == null || ayahs.isEmpty) return '';
    // Return the first surah name on this page
    return ayahs.first.surahName;
  }

  int getJuzForPage(int pageNumber) {
    final ayahs = _pages[pageNumber];
    if (ayahs == null || ayahs.isEmpty) return 1;
    return ayahs.first.juz;
  }

  List<SurahInfo> searchSurahs(String query) {
    if (query.isEmpty) return _surahs;
    return _surahs.where((s) {
      return s.name.contains(query) ||
          s.englishName.toLowerCase().contains(query.toLowerCase()) ||
          s.number.toString() == query;
    }).toList();
  }
}
