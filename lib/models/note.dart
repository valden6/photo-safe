import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 1)
class Note {

  @HiveField(0)
  String title;
  @HiveField(1)
  String body;
  @HiveField(2)
  int color;

  Note(this.title, this.body, this.color);
  
}