import 'package:hive/hive.dart';

part 'study_session.g.dart';

@HiveType(typeId: 2)
class StudySession extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  int totalCards;

  @HiveField(3)
  int correctAnswers;

  @HiveField(4)
  int durationSeconds;

  @HiveField(5)
  String category;

  StudySession({
    required this.id,
    required this.date,
    required this.totalCards,
    required this.correctAnswers,
    required this.durationSeconds,
    required this.category,
  });

  double get accuracy {
    if (totalCards == 0) return 0;
    return (correctAnswers / totalCards * 100);
  }

  String get durationFormatted {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
