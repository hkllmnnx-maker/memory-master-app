/// بيانات القرآن الكريم الأساسية - 114 سورة
class QuranSurah {
  final int number;
  final String name;
  final String englishName;
  final int versesCount;
  final String revelationType; // مكية أو مدنية
  final int page; // رقم الصفحة في مصحف المدينة
  final int juz; // رقم الجزء

  const QuranSurah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.versesCount,
    required this.revelationType,
    required this.page,
    required this.juz,
  });

  bool get isMakki => revelationType == 'مكية';
}

class QuranData {
  static const List<QuranSurah> surahs = [
    QuranSurah(number: 1, name: 'الفاتحة', englishName: 'Al-Fatiha', versesCount: 7, revelationType: 'مكية', page: 1, juz: 1),
    QuranSurah(number: 2, name: 'البقرة', englishName: 'Al-Baqarah', versesCount: 286, revelationType: 'مدنية', page: 2, juz: 1),
    QuranSurah(number: 3, name: 'آل عمران', englishName: 'Aal-Imran', versesCount: 200, revelationType: 'مدنية', page: 50, juz: 3),
    QuranSurah(number: 4, name: 'النساء', englishName: 'An-Nisa', versesCount: 176, revelationType: 'مدنية', page: 77, juz: 4),
    QuranSurah(number: 5, name: 'المائدة', englishName: 'Al-Ma\'idah', versesCount: 120, revelationType: 'مدنية', page: 106, juz: 6),
    QuranSurah(number: 6, name: 'الأنعام', englishName: 'Al-An\'am', versesCount: 165, revelationType: 'مكية', page: 128, juz: 7),
    QuranSurah(number: 7, name: 'الأعراف', englishName: 'Al-A\'raf', versesCount: 206, revelationType: 'مكية', page: 151, juz: 8),
    QuranSurah(number: 8, name: 'الأنفال', englishName: 'Al-Anfal', versesCount: 75, revelationType: 'مدنية', page: 177, juz: 9),
    QuranSurah(number: 9, name: 'التوبة', englishName: 'At-Tawbah', versesCount: 129, revelationType: 'مدنية', page: 187, juz: 10),
    QuranSurah(number: 10, name: 'يونس', englishName: 'Yunus', versesCount: 109, revelationType: 'مكية', page: 208, juz: 11),
    QuranSurah(number: 11, name: 'هود', englishName: 'Hud', versesCount: 123, revelationType: 'مكية', page: 221, juz: 11),
    QuranSurah(number: 12, name: 'يوسف', englishName: 'Yusuf', versesCount: 111, revelationType: 'مكية', page: 235, juz: 12),
    QuranSurah(number: 13, name: 'الرعد', englishName: 'Ar-Ra\'d', versesCount: 43, revelationType: 'مدنية', page: 249, juz: 13),
    QuranSurah(number: 14, name: 'إبراهيم', englishName: 'Ibrahim', versesCount: 52, revelationType: 'مكية', page: 255, juz: 13),
    QuranSurah(number: 15, name: 'الحجر', englishName: 'Al-Hijr', versesCount: 99, revelationType: 'مكية', page: 262, juz: 14),
    QuranSurah(number: 16, name: 'النحل', englishName: 'An-Nahl', versesCount: 128, revelationType: 'مكية', page: 267, juz: 14),
    QuranSurah(number: 17, name: 'الإسراء', englishName: 'Al-Isra', versesCount: 111, revelationType: 'مكية', page: 282, juz: 15),
    QuranSurah(number: 18, name: 'الكهف', englishName: 'Al-Kahf', versesCount: 110, revelationType: 'مكية', page: 293, juz: 15),
    QuranSurah(number: 19, name: 'مريم', englishName: 'Maryam', versesCount: 98, revelationType: 'مكية', page: 305, juz: 16),
    QuranSurah(number: 20, name: 'طه', englishName: 'Ta-Ha', versesCount: 135, revelationType: 'مكية', page: 312, juz: 16),
    QuranSurah(number: 21, name: 'الأنبياء', englishName: 'Al-Anbiya', versesCount: 112, revelationType: 'مكية', page: 322, juz: 17),
    QuranSurah(number: 22, name: 'الحج', englishName: 'Al-Hajj', versesCount: 78, revelationType: 'مدنية', page: 332, juz: 17),
    QuranSurah(number: 23, name: 'المؤمنون', englishName: 'Al-Mu\'minun', versesCount: 118, revelationType: 'مكية', page: 342, juz: 18),
    QuranSurah(number: 24, name: 'النور', englishName: 'An-Nur', versesCount: 64, revelationType: 'مدنية', page: 350, juz: 18),
    QuranSurah(number: 25, name: 'الفرقان', englishName: 'Al-Furqan', versesCount: 77, revelationType: 'مكية', page: 359, juz: 18),
    QuranSurah(number: 26, name: 'الشعراء', englishName: 'Ash-Shu\'ara', versesCount: 227, revelationType: 'مكية', page: 367, juz: 19),
    QuranSurah(number: 27, name: 'النمل', englishName: 'An-Naml', versesCount: 93, revelationType: 'مكية', page: 377, juz: 19),
    QuranSurah(number: 28, name: 'القصص', englishName: 'Al-Qasas', versesCount: 88, revelationType: 'مكية', page: 385, juz: 20),
    QuranSurah(number: 29, name: 'العنكبوت', englishName: 'Al-Ankabut', versesCount: 69, revelationType: 'مكية', page: 396, juz: 20),
    QuranSurah(number: 30, name: 'الروم', englishName: 'Ar-Rum', versesCount: 60, revelationType: 'مكية', page: 404, juz: 21),
    QuranSurah(number: 31, name: 'لقمان', englishName: 'Luqman', versesCount: 34, revelationType: 'مكية', page: 411, juz: 21),
    QuranSurah(number: 32, name: 'السجدة', englishName: 'As-Sajdah', versesCount: 30, revelationType: 'مكية', page: 415, juz: 21),
    QuranSurah(number: 33, name: 'الأحزاب', englishName: 'Al-Ahzab', versesCount: 73, revelationType: 'مدنية', page: 418, juz: 21),
    QuranSurah(number: 34, name: 'سبأ', englishName: 'Saba', versesCount: 54, revelationType: 'مكية', page: 428, juz: 22),
    QuranSurah(number: 35, name: 'فاطر', englishName: 'Fatir', versesCount: 45, revelationType: 'مكية', page: 434, juz: 22),
    QuranSurah(number: 36, name: 'يس', englishName: 'Ya-Sin', versesCount: 83, revelationType: 'مكية', page: 440, juz: 22),
    QuranSurah(number: 37, name: 'الصافات', englishName: 'As-Saffat', versesCount: 182, revelationType: 'مكية', page: 446, juz: 23),
    QuranSurah(number: 38, name: 'ص', englishName: 'Sad', versesCount: 88, revelationType: 'مكية', page: 453, juz: 23),
    QuranSurah(number: 39, name: 'الزمر', englishName: 'Az-Zumar', versesCount: 75, revelationType: 'مكية', page: 458, juz: 23),
    QuranSurah(number: 40, name: 'غافر', englishName: 'Ghafir', versesCount: 85, revelationType: 'مكية', page: 467, juz: 24),
    QuranSurah(number: 41, name: 'فصلت', englishName: 'Fussilat', versesCount: 54, revelationType: 'مكية', page: 477, juz: 24),
    QuranSurah(number: 42, name: 'الشورى', englishName: 'Ash-Shura', versesCount: 53, revelationType: 'مكية', page: 483, juz: 25),
    QuranSurah(number: 43, name: 'الزخرف', englishName: 'Az-Zukhruf', versesCount: 89, revelationType: 'مكية', page: 489, juz: 25),
    QuranSurah(number: 44, name: 'الدخان', englishName: 'Ad-Dukhan', versesCount: 59, revelationType: 'مكية', page: 496, juz: 25),
    QuranSurah(number: 45, name: 'الجاثية', englishName: 'Al-Jathiyah', versesCount: 37, revelationType: 'مكية', page: 499, juz: 25),
    QuranSurah(number: 46, name: 'الأحقاف', englishName: 'Al-Ahqaf', versesCount: 35, revelationType: 'مكية', page: 502, juz: 26),
    QuranSurah(number: 47, name: 'محمد', englishName: 'Muhammad', versesCount: 38, revelationType: 'مدنية', page: 507, juz: 26),
    QuranSurah(number: 48, name: 'الفتح', englishName: 'Al-Fath', versesCount: 29, revelationType: 'مدنية', page: 511, juz: 26),
    QuranSurah(number: 49, name: 'الحجرات', englishName: 'Al-Hujurat', versesCount: 18, revelationType: 'مدنية', page: 515, juz: 26),
    QuranSurah(number: 50, name: 'ق', englishName: 'Qaf', versesCount: 45, revelationType: 'مكية', page: 518, juz: 26),
    QuranSurah(number: 51, name: 'الذاريات', englishName: 'Adh-Dhariyat', versesCount: 60, revelationType: 'مكية', page: 520, juz: 26),
    QuranSurah(number: 52, name: 'الطور', englishName: 'At-Tur', versesCount: 49, revelationType: 'مكية', page: 523, juz: 27),
    QuranSurah(number: 53, name: 'النجم', englishName: 'An-Najm', versesCount: 62, revelationType: 'مكية', page: 526, juz: 27),
    QuranSurah(number: 54, name: 'القمر', englishName: 'Al-Qamar', versesCount: 55, revelationType: 'مكية', page: 528, juz: 27),
    QuranSurah(number: 55, name: 'الرحمن', englishName: 'Ar-Rahman', versesCount: 78, revelationType: 'مدنية', page: 531, juz: 27),
    QuranSurah(number: 56, name: 'الواقعة', englishName: 'Al-Waqi\'ah', versesCount: 96, revelationType: 'مكية', page: 534, juz: 27),
    QuranSurah(number: 57, name: 'الحديد', englishName: 'Al-Hadid', versesCount: 29, revelationType: 'مدنية', page: 537, juz: 27),
    QuranSurah(number: 58, name: 'المجادلة', englishName: 'Al-Mujadilah', versesCount: 22, revelationType: 'مدنية', page: 542, juz: 28),
    QuranSurah(number: 59, name: 'الحشر', englishName: 'Al-Hashr', versesCount: 24, revelationType: 'مدنية', page: 545, juz: 28),
    QuranSurah(number: 60, name: 'الممتحنة', englishName: 'Al-Mumtahanah', versesCount: 13, revelationType: 'مدنية', page: 549, juz: 28),
    QuranSurah(number: 61, name: 'الصف', englishName: 'As-Saff', versesCount: 14, revelationType: 'مدنية', page: 551, juz: 28),
    QuranSurah(number: 62, name: 'الجمعة', englishName: 'Al-Jumu\'ah', versesCount: 11, revelationType: 'مدنية', page: 553, juz: 28),
    QuranSurah(number: 63, name: 'المنافقون', englishName: 'Al-Munafiqun', versesCount: 11, revelationType: 'مدنية', page: 554, juz: 28),
    QuranSurah(number: 64, name: 'التغابن', englishName: 'At-Taghabun', versesCount: 18, revelationType: 'مدنية', page: 556, juz: 28),
    QuranSurah(number: 65, name: 'الطلاق', englishName: 'At-Talaq', versesCount: 12, revelationType: 'مدنية', page: 558, juz: 28),
    QuranSurah(number: 66, name: 'التحريم', englishName: 'At-Tahrim', versesCount: 12, revelationType: 'مدنية', page: 560, juz: 28),
    QuranSurah(number: 67, name: 'الملك', englishName: 'Al-Mulk', versesCount: 30, revelationType: 'مكية', page: 562, juz: 29),
    QuranSurah(number: 68, name: 'القلم', englishName: 'Al-Qalam', versesCount: 52, revelationType: 'مكية', page: 564, juz: 29),
    QuranSurah(number: 69, name: 'الحاقة', englishName: 'Al-Haqqah', versesCount: 52, revelationType: 'مكية', page: 566, juz: 29),
    QuranSurah(number: 70, name: 'المعارج', englishName: 'Al-Ma\'arij', versesCount: 44, revelationType: 'مكية', page: 568, juz: 29),
    QuranSurah(number: 71, name: 'نوح', englishName: 'Nuh', versesCount: 28, revelationType: 'مكية', page: 570, juz: 29),
    QuranSurah(number: 72, name: 'الجن', englishName: 'Al-Jinn', versesCount: 28, revelationType: 'مكية', page: 572, juz: 29),
    QuranSurah(number: 73, name: 'المزمل', englishName: 'Al-Muzzammil', versesCount: 20, revelationType: 'مكية', page: 574, juz: 29),
    QuranSurah(number: 74, name: 'المدثر', englishName: 'Al-Muddathir', versesCount: 56, revelationType: 'مكية', page: 575, juz: 29),
    QuranSurah(number: 75, name: 'القيامة', englishName: 'Al-Qiyamah', versesCount: 40, revelationType: 'مكية', page: 577, juz: 29),
    QuranSurah(number: 76, name: 'الإنسان', englishName: 'Al-Insan', versesCount: 31, revelationType: 'مدنية', page: 578, juz: 29),
    QuranSurah(number: 77, name: 'المرسلات', englishName: 'Al-Mursalat', versesCount: 50, revelationType: 'مكية', page: 580, juz: 29),
    QuranSurah(number: 78, name: 'النبأ', englishName: 'An-Naba', versesCount: 40, revelationType: 'مكية', page: 582, juz: 30),
    QuranSurah(number: 79, name: 'النازعات', englishName: 'An-Nazi\'at', versesCount: 46, revelationType: 'مكية', page: 583, juz: 30),
    QuranSurah(number: 80, name: 'عبس', englishName: 'Abasa', versesCount: 42, revelationType: 'مكية', page: 585, juz: 30),
    QuranSurah(number: 81, name: 'التكوير', englishName: 'At-Takwir', versesCount: 29, revelationType: 'مكية', page: 586, juz: 30),
    QuranSurah(number: 82, name: 'الانفطار', englishName: 'Al-Infitar', versesCount: 19, revelationType: 'مكية', page: 587, juz: 30),
    QuranSurah(number: 83, name: 'المطففين', englishName: 'Al-Mutaffifin', versesCount: 36, revelationType: 'مكية', page: 587, juz: 30),
    QuranSurah(number: 84, name: 'الانشقاق', englishName: 'Al-Inshiqaq', versesCount: 25, revelationType: 'مكية', page: 589, juz: 30),
    QuranSurah(number: 85, name: 'البروج', englishName: 'Al-Buruj', versesCount: 22, revelationType: 'مكية', page: 590, juz: 30),
    QuranSurah(number: 86, name: 'الطارق', englishName: 'At-Tariq', versesCount: 17, revelationType: 'مكية', page: 591, juz: 30),
    QuranSurah(number: 87, name: 'الأعلى', englishName: 'Al-A\'la', versesCount: 19, revelationType: 'مكية', page: 591, juz: 30),
    QuranSurah(number: 88, name: 'الغاشية', englishName: 'Al-Ghashiyah', versesCount: 26, revelationType: 'مكية', page: 592, juz: 30),
    QuranSurah(number: 89, name: 'الفجر', englishName: 'Al-Fajr', versesCount: 30, revelationType: 'مكية', page: 593, juz: 30),
    QuranSurah(number: 90, name: 'البلد', englishName: 'Al-Balad', versesCount: 20, revelationType: 'مكية', page: 594, juz: 30),
    QuranSurah(number: 91, name: 'الشمس', englishName: 'Ash-Shams', versesCount: 15, revelationType: 'مكية', page: 595, juz: 30),
    QuranSurah(number: 92, name: 'الليل', englishName: 'Al-Layl', versesCount: 21, revelationType: 'مكية', page: 595, juz: 30),
    QuranSurah(number: 93, name: 'الضحى', englishName: 'Ad-Duha', versesCount: 11, revelationType: 'مكية', page: 596, juz: 30),
    QuranSurah(number: 94, name: 'الشرح', englishName: 'Ash-Sharh', versesCount: 8, revelationType: 'مكية', page: 596, juz: 30),
    QuranSurah(number: 95, name: 'التين', englishName: 'At-Tin', versesCount: 8, revelationType: 'مكية', page: 597, juz: 30),
    QuranSurah(number: 96, name: 'العلق', englishName: 'Al-Alaq', versesCount: 19, revelationType: 'مكية', page: 597, juz: 30),
    QuranSurah(number: 97, name: 'القدر', englishName: 'Al-Qadr', versesCount: 5, revelationType: 'مكية', page: 598, juz: 30),
    QuranSurah(number: 98, name: 'البينة', englishName: 'Al-Bayyinah', versesCount: 8, revelationType: 'مدنية', page: 598, juz: 30),
    QuranSurah(number: 99, name: 'الزلزلة', englishName: 'Az-Zalzalah', versesCount: 8, revelationType: 'مدنية', page: 599, juz: 30),
    QuranSurah(number: 100, name: 'العاديات', englishName: 'Al-Adiyat', versesCount: 11, revelationType: 'مكية', page: 599, juz: 30),
    QuranSurah(number: 101, name: 'القارعة', englishName: 'Al-Qari\'ah', versesCount: 11, revelationType: 'مكية', page: 600, juz: 30),
    QuranSurah(number: 102, name: 'التكاثر', englishName: 'At-Takathur', versesCount: 8, revelationType: 'مكية', page: 600, juz: 30),
    QuranSurah(number: 103, name: 'العصر', englishName: 'Al-Asr', versesCount: 3, revelationType: 'مكية', page: 601, juz: 30),
    QuranSurah(number: 104, name: 'الهمزة', englishName: 'Al-Humazah', versesCount: 9, revelationType: 'مكية', page: 601, juz: 30),
    QuranSurah(number: 105, name: 'الفيل', englishName: 'Al-Fil', versesCount: 5, revelationType: 'مكية', page: 601, juz: 30),
    QuranSurah(number: 106, name: 'قريش', englishName: 'Quraysh', versesCount: 4, revelationType: 'مكية', page: 602, juz: 30),
    QuranSurah(number: 107, name: 'الماعون', englishName: 'Al-Ma\'un', versesCount: 7, revelationType: 'مكية', page: 602, juz: 30),
    QuranSurah(number: 108, name: 'الكوثر', englishName: 'Al-Kawthar', versesCount: 3, revelationType: 'مكية', page: 602, juz: 30),
    QuranSurah(number: 109, name: 'الكافرون', englishName: 'Al-Kafirun', versesCount: 6, revelationType: 'مكية', page: 603, juz: 30),
    QuranSurah(number: 110, name: 'النصر', englishName: 'An-Nasr', versesCount: 3, revelationType: 'مدنية', page: 603, juz: 30),
    QuranSurah(number: 111, name: 'المسد', englishName: 'Al-Masad', versesCount: 5, revelationType: 'مكية', page: 603, juz: 30),
    QuranSurah(number: 112, name: 'الإخلاص', englishName: 'Al-Ikhlas', versesCount: 4, revelationType: 'مكية', page: 604, juz: 30),
    QuranSurah(number: 113, name: 'الفلق', englishName: 'Al-Falaq', versesCount: 5, revelationType: 'مكية', page: 604, juz: 30),
    QuranSurah(number: 114, name: 'الناس', englishName: 'An-Nas', versesCount: 6, revelationType: 'مكية', page: 604, juz: 30),
  ];

  /// الحصول على أسماء الأجزاء
  static String getJuzName(int juzNumber) {
    const juzNames = [
      'الم', 'سيقول', 'تلك الرسل', 'لن تنالوا', 'والمحصنات',
      'لا يحب الله', 'وإذا سمعوا', 'ولو أننا', 'قال الملأ',
      'واعلموا', 'يعتذرون', 'وما من دابة', 'وما أبرئ',
      'ربما', 'سبحان الذي', 'قال ألم', 'اقترب للناس',
      'قد أفلح', 'وقال الذين', 'أمن خلق', 'اتل ما أوحي',
      'ومن يقنت', 'وما لي', 'فمن أظلم', 'إليه يرد',
      'حم', 'قال فما خطبكم', 'قد سمع الله', 'تبارك الذي',
      'عم يتساءلون',
    ];
    if (juzNumber < 1 || juzNumber > 30) return '';
    return juzNames[juzNumber - 1];
  }

  /// الحصول على السور في جزء معين
  static List<QuranSurah> getSurahsInJuz(int juzNumber) {
    return surahs.where((s) => s.juz == juzNumber).toList();
  }

  /// إجمالي عدد الآيات
  static int get totalVerses {
    return surahs.fold(0, (sum, s) => sum + s.versesCount);
  }

  /// إجمالي عدد الصفحات
  static const int totalPages = 604;
}
