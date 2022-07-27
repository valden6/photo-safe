import 'dart:developer';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:photo_safe/models/folder.dart';

class ImageStorageService {

  Future<void> saveFolderInStorage(Folder folder) async {
    Box box = await Hive.openBox<Folder>("folders");
    box.add(folder);
  }

  Future<void> deleteFolderInStorage(Folder folder) async {
    final Box<Folder> box = Hive.box<Folder>("folders");
    final List<Folder> boxFolders = box.values.toList();
    for (final Folder folderInBox in boxFolders) {
      if(folderInBox.name == folder.name){
        await deleteAllFolderImageInStorage(folderInBox);
        box.deleteAt(boxFolders.indexOf(folderInBox));
      }
    }
  }

  Future<void> deleteAllFolderImageInStorage(Folder folder) async {
    for(final String imagePath in folder.imagesPath) {
      final File finalImage = File(imagePath);
      try {
        await finalImage.delete();
      } catch (e) {
        log("ERROR: deletion -> $e");
      }
    }
  }
  

  Future<void> deleteSelectedFolderImageInStorage(Folder folder, List<String> selectedImagesPath) async {
    
    Box box = await Hive.openBox<Folder>("folders");
    final List<String> imagesPathWithoutDeletion = [];
    imagesPathWithoutDeletion.addAll(folder.imagesPath);
    
    for (String selectedImagePath in selectedImagesPath) {
      for(String imagePath in folder.imagesPath) {
        if(imagePath == selectedImagePath){
          final File finalImage = File(imagePath);
          imagesPathWithoutDeletion.remove(imagePath);
          try {
            await finalImage.delete();
          } catch (e) {
            log("ERROR: deletion -> $e");
          }
        }
      }
    }
    Folder folderInStorage = Folder("", []);
    int indexFolderInStorage = 0;
    final List<Folder> foldersInStorage = box.values.toList() as List<Folder>;
    for (int i = 0; i < foldersInStorage.length; i++) {
      if(foldersInStorage[i].name == folder.name){
        folderInStorage = foldersInStorage[i];
        indexFolderInStorage = i;
      }
    }
    folderInStorage.imagesPath = imagesPathWithoutDeletion;
    box.putAt(indexFolderInStorage,folderInStorage);
  }

  Future<List<Folder>> getAllFoldersInStorage() async {
    Box<Folder> box = await Hive.openBox<Folder>("folders");
    return box.values.toList();
  }

  Future<List<String>> getAllImagesInFolderInStorage(Folder folder) async {
    Box<Folder> box = await Hive.openBox<Folder>("folders");
    final Folder folderInStorage = box.values.toList().firstWhere((folderInStorage) => folderInStorage.name == folder.name);
    return folderInStorage.imagesPath;
  }

  Future<void> saveImagesInFolderInStorage(Folder folder, List<String> images) async {
    Box box = await Hive.openBox<Folder>("folders");
    Folder folderInStorage = Folder("", []);
    int indexFolderInStorage = 0;
    final List<Folder> foldersInStorage = box.values.toList() as List<Folder>;
    for (int i = 0; i < foldersInStorage.length; i++) {
      if(foldersInStorage[i].name == folder.name){
        folderInStorage = foldersInStorage[i];
        indexFolderInStorage = i;
      }
    }
    folderInStorage.imagesPath.addAll(images);
    box.putAt(indexFolderInStorage,folderInStorage);
  }

  static final ImageStorageService _imageStorageService = ImageStorageService._internal();
  factory ImageStorageService() {
    return _imageStorageService;
  }
  ImageStorageService._internal();

}

final ImageStorageService imageStorageService = ImageStorageService();
