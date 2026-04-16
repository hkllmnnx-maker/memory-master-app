import 'package:shared_preferences/shared_preferences.dart';

class MemorizationService {
  static final MemorizationService _instance = MemorizationService._internal();
  factory MemorizationService() => _instance;
  MemorizationService._internal();

  SharedPreferences? _prefs;
  Set<int> _memorizedPages = {};
  Set<int> _bookmarkedPages = {};
  int _lastReadPage = 1;

  Set<int> get memorizedPages => _memorizedPages;
  Set<int> get bookmarkedPages => _bookmarkedPages;
  int get lastReadPage => _lastReadPage;

  int get memorizedCount => _memorizedPages.length;
  double get memorizedPercentage => (_memorizedPages.length / 604) * 100;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _loadData();
  }

  void _loadData() {
    final memorizedList = _prefs?.getStringList('memorized_pages') ?? [];
    _memorizedPages = memorizedList.map((e) => int.parse(e)).toSet();

    final bookmarkedList = _prefs?.getStringList('bookmarked_pages') ?? [];
    _bookmarkedPages = bookmarkedList.map((e) => int.parse(e)).toSet();

    _lastReadPage = _prefs?.getInt('last_read_page') ?? 1;
  }

  Future<void> _saveData() async {
    await _prefs?.setStringList(
      'memorized_pages',
      _memorizedPages.map((e) => e.toString()).toList(),
    );
    await _prefs?.setStringList(
      'bookmarked_pages',
      _bookmarkedPages.map((e) => e.toString()).toList(),
    );
    await _prefs?.setInt('last_read_page', _lastReadPage);
  }

  Future<void> toggleMemorized(int page) async {
    if (_memorizedPages.contains(page)) {
      _memorizedPages.remove(page);
    } else {
      _memorizedPages.add(page);
    }
    await _saveData();
  }

  Future<void> toggleBookmark(int page) async {
    if (_bookmarkedPages.contains(page)) {
      _bookmarkedPages.remove(page);
    } else {
      _bookmarkedPages.add(page);
    }
    await _saveData();
  }

  bool isMemorized(int page) => _memorizedPages.contains(page);
  bool isBookmarked(int page) => _bookmarkedPages.contains(page);

  Future<void> setLastReadPage(int page) async {
    _lastReadPage = page;
    await _prefs?.setInt('last_read_page', page);
  }

  // Get memorization stats per juz
  Map<int, double> getJuzProgress(Map<int, dynamic> juzs) {
    final Map<int, double> progress = {};
    for (final entry in juzs.entries) {
      final juz = entry.value;
      final startPage = juz.startPage as int;
      final endPage = juz.endPage as int;
      final totalPages = endPage - startPage + 1;
      int memorized = 0;
      for (int p = startPage; p <= endPage; p++) {
        if (_memorizedPages.contains(p)) memorized++;
      }
      progress[entry.key] = totalPages > 0 ? memorized / totalPages : 0;
    }
    return progress;
  }
}
