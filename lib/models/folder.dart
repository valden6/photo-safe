import 'package:hive/hive.dart';

part 'folder.g.dart';

@HiveType(typeId: 0)
class Folder {

  @HiveField(0)
  final String name;
  @HiveField(1)
  List<String> imagesPath;

  Folder(this.name, this.imagesPath);
  
}