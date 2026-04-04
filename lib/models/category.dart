import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 1)
class Category extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String icon; // اسم الأيقونة

  @HiveField(3)
  int colorIndex;

  @HiveField(4)
  DateTime createdAt;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorIndex,
    required this.createdAt,
  });
}
