/// نصائح وفوائد للحفظ - تظهر بشكل يومي أو عند التنقل
class HifzTip {
  final String title;
  final String description;
  final String icon; // icon name

  const HifzTip({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class HifzTipsData {
  static const List<HifzTip> tips = [
    HifzTip(
      title: 'الإخلاص قبل البداية',
      description:
          'اجعل نيتك خالصة لله تعالى، فالعمل بلا إخلاص كالجسد بلا روح. استحضر قول رسول الله ﷺ: «إنما الأعمال بالنيات».',
      icon: 'favorite',
    ),
    HifzTip(
      title: 'المداومة ولو قلّ',
      description:
          'احفظ كل يوم صفحة أو نصف صفحة، لكن لا تنقطع. قال ﷺ: «أحب الأعمال إلى الله أدومها وإن قلّ».',
      icon: 'trending_up',
    ),
    HifzTip(
      title: 'اختر الوقت الأنسب',
      description:
          'أفضل الأوقات للحفظ هي بعد الفجر وقبيل النوم، حيث يكون الذهن صافياً والجو هادئاً.',
      icon: 'wb_twilight',
    ),
    HifzTip(
      title: 'المراجعة هي الأساس',
      description:
          'القرآن أشد تفلتاً من الإبل في عقلها. خصص وقتاً للمراجعة اليومية للمحفوظ السابق قبل الحفظ الجديد.',
      icon: 'refresh',
    ),
    HifzTip(
      title: 'الحفظ في المكان الهادئ',
      description:
          'اختر مكاناً هادئاً بعيداً عن الضوضاء والمشتتات. المصحف المفتوح أمامك، وقلبك حاضر.',
      icon: 'volume_off',
    ),
    HifzTip(
      title: 'اقرأ قبل أن تحفظ',
      description:
          'اقرأ الآيات عدة مرات بصوت مرتفع قبل أن تبدأ الحفظ، حتى تألف لسانك نطق الكلمات.',
      icon: 'record_voice_over',
    ),
    HifzTip(
      title: 'اربط الحفظ بالتدبر',
      description:
          'لا تحفظ الآيات كمجرد حروف، بل تدبر معانيها واستحضر مقاصدها، فالقرآن أُنزل ليُعمل به.',
      icon: 'psychology',
    ),
    HifzTip(
      title: 'كرر بصوت عالٍ',
      description:
          'الحفظ بصوت مرتفع أقوى من القراءة الصامتة، لأن الأذن تسمع ما ينطقه اللسان فيترسخ الحفظ.',
      icon: 'mic',
    ),
    HifzTip(
      title: 'التسميع للمتقنين',
      description:
          'لا تثق بحفظك حتى تسمعه على شيخ متقن. التسميع يكشف الأخطاء التي لا تراها بنفسك.',
      icon: 'school',
    ),
    HifzTip(
      title: 'الدعاء والاستعانة',
      description:
          'ادعُ الله قبل الحفظ وبعده. قل: «اللهم افتح عليّ من علومك وفضلك وذكّرني منه ما نسيت».',
      icon: 'spa',
    ),
    HifzTip(
      title: 'استخدم مصحفاً واحداً',
      description:
          'التزم بمصحف واحد لا تغيّره، فالعين تألف مواضع الآيات والصفحات، مما يقوي الحفظ البصري.',
      icon: 'menu_book',
    ),
    HifzTip(
      title: 'الحفظ بالمجموعات',
      description:
          'احفظ مع مجموعة أو صديق، فالتنافس في الخير محمود، والتسميع المتبادل يثبت الحفظ.',
      icon: 'groups',
    ),
    HifzTip(
      title: 'الابتعاد عن المعاصي',
      description:
          'قال الشافعي: "شكوتُ إلى وكيعٍ سوءَ حفظي... فأرشدني إلى ترك المعاصي". الطاعة نور للقلب.',
      icon: 'lightbulb',
    ),
    HifzTip(
      title: 'تسلسل المراجعة',
      description:
          'راجع حفظ الأمس قبل حفظ اليوم، ثم راجع حفظ الأسبوع كل جمعة، والشهر كل 30 يوماً.',
      icon: 'view_timeline',
    ),
    HifzTip(
      title: 'ثقتك بنفسك',
      description:
          'ثق بأن الله يعينك. قال تعالى: «ولقد يسّرنا القرآن للذكر فهل من مدّكر». الحفظ ميسور لمن جدّ.',
      icon: 'emoji_emotions',
    ),
  ];

  /// الحصول على نصيحة اليوم
  static HifzTip getTipOfTheDay() {
    final now = DateTime.now();
    final dayOfYear =
        now.difference(DateTime(now.year, 1, 1)).inDays;
    return tips[dayOfYear % tips.length];
  }

  /// الحصول على نصيحة عشوائية
  static HifzTip getRandomTip() {
    final now = DateTime.now();
    final index = now.millisecondsSinceEpoch % tips.length;
    return tips[index];
  }
}
