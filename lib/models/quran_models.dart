class SurahInfo {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final int ayahCount;
  final int startPage;
  final int endPage;

  SurahInfo({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.ayahCount,
    required this.startPage,
    required this.endPage,
  });

  factory SurahInfo.fromJson(Map<String, dynamic> json) {
    return SurahInfo(
      number: json['number'] as int,
      name: json['name'] as String,
      englishName: json['englishName'] as String,
      englishNameTranslation: json['englishNameTranslation'] as String,
      revelationType: json['revelationType'] as String,
      ayahCount: json['ayahCount'] as int,
      startPage: json['startPage'] as int,
      endPage: json['endPage'] as int,
    );
  }

  String get localizedRevelationType =>
      revelationType == 'Meccan' ? 'مكية' : 'مدنية';
}

class AyahInfo {
  final int numberInSurah;
  final String text;
  final int surahNumber;
  final String surahName;
  final int juz;

  AyahInfo({
    required this.numberInSurah,
    required this.text,
    required this.surahNumber,
    required this.surahName,
    required this.juz,
  });

  factory AyahInfo.fromJson(Map<String, dynamic> json) {
    return AyahInfo(
      numberInSurah: json['n'] as int,
      text: json['t'] as String,
      surahNumber: json['s'] as int,
      surahName: json['sn'] as String,
      juz: json['j'] as int,
    );
  }
}

class JuzInfo {
  final int number;
  final int startPage;
  final int endPage;
  final List<int> surahNumbers;

  JuzInfo({
    required this.number,
    required this.startPage,
    required this.endPage,
    required this.surahNumbers,
  });

  factory JuzInfo.fromJson(Map<String, dynamic> json) {
    return JuzInfo(
      number: json['number'] as int,
      startPage: json['startPage'] as int,
      endPage: json['endPage'] as int,
      surahNumbers: (json['surahNumbers'] as List).cast<int>(),
    );
  }
}

class PageData {
  final int pageNumber;
  final List<AyahInfo> ayahs;
  final int juz;
  final List<int> surahNumbers;

  PageData({
    required this.pageNumber,
    required this.ayahs,
    required this.juz,
    required this.surahNumbers,
  });
}
