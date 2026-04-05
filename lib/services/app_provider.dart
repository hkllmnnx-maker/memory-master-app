import 'package:flutter/material.dart';
import 'quran_service.dart';
import 'memorization_service.dart';

class AppProvider extends ChangeNotifier {
  final QuranService _quranService = QuranService();
  final MemorizationService _memService = MemorizationService();

  bool _isLoading = true;
  bool _isDarkMode = false;
  int _currentNavIndex = 0;
  int _currentPage = 1;
  double _fontSize = 28.0;

  bool get isLoading => _isLoading;
  bool get isDarkMode => _isDarkMode;
  int get currentNavIndex => _currentNavIndex;
  int get currentPage => _currentPage;
  double get fontSize => _fontSize;
  QuranService get quranService => _quranService;
  MemorizationService get memService => _memService;

  Future<void> initialize() async {
    await _quranService.loadQuranData();
    await _memService.initialize();
    _currentPage = _memService.lastReadPage;
    _isLoading = false;
    notifyListeners();
  }

  void setNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }

  void setCurrentPage(int page) {
    if (page >= 1 && page <= 604) {
      _currentPage = page;
      _memService.setLastReadPage(page);
      notifyListeners();
    }
  }

  void nextPage() {
    if (_currentPage < 604) {
      _currentPage++;
      _memService.setLastReadPage(_currentPage);
      notifyListeners();
    }
  }

  void previousPage() {
    if (_currentPage > 1) {
      _currentPage--;
      _memService.setLastReadPage(_currentPage);
      notifyListeners();
    }
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setFontSize(double size) {
    _fontSize = size;
    notifyListeners();
  }

  Future<void> toggleMemorized(int page) async {
    await _memService.toggleMemorized(page);
    notifyListeners();
  }

  Future<void> toggleBookmark(int page) async {
    await _memService.toggleBookmark(page);
    notifyListeners();
  }
}
