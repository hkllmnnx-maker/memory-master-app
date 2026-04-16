/// بيانات التذكرة اليومية: آيات وأحاديث وحِكَم وأدعية
class WisdomItem {
  final String type; // 'verse' | 'hadith' | 'dua' | 'wisdom'
  final String text;
  final String source;

  const WisdomItem({
    required this.type,
    required this.text,
    required this.source,
  });
}

class DailyWisdomData {
  static const List<WisdomItem> items = [
    // آيات
    WisdomItem(
      type: 'verse',
      text: '«وَمَنْ يَتَّقِ اللَّهَ يَجْعَلْ لَهُ مَخْرَجًا ۝ وَيَرْزُقْهُ مِنْ حَيْثُ لَا يَحْتَسِبُ»',
      source: 'الطلاق: 2-3',
    ),
    WisdomItem(
      type: 'verse',
      text: '«إِنَّ مَعَ الْعُسْرِ يُسْرًا»',
      source: 'الشرح: 6',
    ),
    WisdomItem(
      type: 'verse',
      text: '«وَبَشِّرِ الصَّابِرِينَ ۝ الَّذِينَ إِذَا أَصَابَتْهُمْ مُصِيبَةٌ قَالُوا إِنَّا لِلَّهِ وَإِنَّا إِلَيْهِ رَاجِعُونَ»',
      source: 'البقرة: 155-156',
    ),
    WisdomItem(
      type: 'verse',
      text: '«وَاسْتَعِينُوا بِالصَّبْرِ وَالصَّلَاةِ»',
      source: 'البقرة: 45',
    ),
    WisdomItem(
      type: 'verse',
      text: '«وَمَنْ يَتَوَكَّلْ عَلَى اللَّهِ فَهُوَ حَسْبُهُ»',
      source: 'الطلاق: 3',
    ),
    WisdomItem(
      type: 'verse',
      text: '«أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ»',
      source: 'الرعد: 28',
    ),
    WisdomItem(
      type: 'verse',
      text: '«وَمَا خَلَقْتُ الْجِنَّ وَالْإِنْسَ إِلَّا لِيَعْبُدُونِ»',
      source: 'الذاريات: 56',
    ),
    // أحاديث
    WisdomItem(
      type: 'hadith',
      text: '«أحب الأعمال إلى الله أدومها وإن قلّ»',
      source: 'صحيح البخاري',
    ),
    WisdomItem(
      type: 'hadith',
      text: '«من سلك طريقاً يلتمس فيه علماً سهّل الله له به طريقاً إلى الجنة»',
      source: 'صحيح مسلم',
    ),
    WisdomItem(
      type: 'hadith',
      text: '«خيركم من تعلم القرآن وعلّمه»',
      source: 'صحيح البخاري',
    ),
    WisdomItem(
      type: 'hadith',
      text: '«الماهر بالقرآن مع السفرة الكرام البررة، والذي يقرأ القرآن ويتتعتع فيه وهو عليه شاق له أجران»',
      source: 'متفق عليه',
    ),
    WisdomItem(
      type: 'hadith',
      text: '«من قرأ حرفاً من كتاب الله فله به حسنة، والحسنة بعشر أمثالها»',
      source: 'سنن الترمذي',
    ),
    WisdomItem(
      type: 'hadith',
      text: '«مثل المؤمن الذي يقرأ القرآن كمثل الأترجة طعمها طيب وريحها طيب»',
      source: 'متفق عليه',
    ),
    // حِكم
    WisdomItem(
      type: 'wisdom',
      text: 'من حفظ القرآن فقد جعل النبوة بين جنبيه، إلا أنه لا يوحى إليه',
      source: 'ابن مسعود رضي الله عنه',
    ),
    WisdomItem(
      type: 'wisdom',
      text: 'كل ما في القرآن من ذِكر المؤمنين فلا تظنن بنفسك خيراً ولا شراً حتى تنظر ما الذي ختم له به',
      source: 'ابن القيم',
    ),
    WisdomItem(
      type: 'wisdom',
      text: 'المراجعة هي أم الحفظ، والتدبر هو روحه',
      source: 'حكمة',
    ),
    WisdomItem(
      type: 'wisdom',
      text: 'من أراد أن يحفظ القرآن فعليه بالإخلاص، ثم بالمداومة وإن قلّت',
      source: 'حكمة',
    ),
    // أدعية
    WisdomItem(
      type: 'dua',
      text: 'اللَّهُمَّ ارْحَمْنِي بِالْقُرْآنِ، وَاجْعَلْهُ لِي إِمَامًا وَنُورًا وَهُدًى وَرَحْمَةً',
      source: 'دعاء مأثور',
    ),
    WisdomItem(
      type: 'dua',
      text: 'اللَّهُمَّ ذَكِّرْنِي مِنْهُ مَا نَسِيتُ، وَعَلِّمْنِي مِنْهُ مَا جَهِلْتُ، وَارْزُقْنِي تِلَاوَتَهُ آنَاءَ اللَّيْلِ وَأَطْرَافَ النَّهَارِ',
      source: 'دعاء مأثور',
    ),
    WisdomItem(
      type: 'dua',
      text: 'رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي وَاحْلُلْ عُقْدَةً مِنْ لِسَانِي يَفْقَهُوا قَوْلِي',
      source: 'طه: 25-28',
    ),
    WisdomItem(
      type: 'dua',
      text: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا، وَرِزْقًا طَيِّبًا، وَعَمَلًا مُتَقَبَّلًا',
      source: 'رواه ابن ماجه',
    ),
    WisdomItem(
      type: 'dua',
      text: 'اللَّهُمَّ لَا سَهْلَ إِلَّا مَا جَعَلْتَهُ سَهْلًا، وَأَنْتَ تَجْعَلُ الْحَزْنَ إِذَا شِئْتَ سَهْلًا',
      source: 'صحيح ابن حبان',
    ),
  ];

  /// الحصول على تذكرة اليوم بناءً على التاريخ
  static WisdomItem getDailyWisdom() {
    final now = DateTime.now();
    final dayOfYear = int.parse(
      '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}',
    );
    return items[dayOfYear % items.length];
  }

  /// الحصول على آية اليوم
  static WisdomItem getDailyVerse() {
    final verses = items.where((i) => i.type == 'verse').toList();
    final now = DateTime.now();
    final index = (now.year * 365 + now.month * 31 + now.day) % verses.length;
    return verses[index];
  }

  /// الحصول على حديث اليوم
  static WisdomItem getDailyHadith() {
    final hadiths = items.where((i) => i.type == 'hadith').toList();
    final now = DateTime.now();
    final index = (now.year + now.month * 31 + now.day) % hadiths.length;
    return hadiths[index];
  }

  /// الحصول على دعاء اليوم
  static WisdomItem getDailyDua() {
    final duas = items.where((i) => i.type == 'dua').toList();
    final now = DateTime.now();
    final index = (now.year + now.month + now.day) % duas.length;
    return duas[index];
  }
}
