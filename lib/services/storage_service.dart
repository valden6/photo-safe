import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:photo_safe/models/folder.dart';

class StorageService {

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
      await finalImage.delete();
    }
  }
  

  Future<void> deleteSelectedFolderImageInStorage(Folder folder, List<String> selectedImagesPath) async {
    final List<String> deleteImagesPath = [];
    for(String imagePath in folder.imagesPath) {
      for (String selectedImagePath in selectedImagesPath) {
        if(imagePath == selectedImagePath){
          final File finalImage = File(imagePath);
          deleteImagesPath.add(imagePath);
          await finalImage.delete();

        }
      }
    }
    for (final String deleteImagePath in deleteImagesPath) {
      folder.imagesPath.remove(deleteImagePath);
    }
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

  Future<void> setPwd(String pwd) async {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    await secureStorage.write(key: 'pwd', value: pwd);
  }

  Future<void> setFakePwd(String fakePwd) async {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    await secureStorage.write(key: 'fakePwd', value: fakePwd);
  }

  Future<int> checkPwd(String pwd) async {
    int valid = 0;
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    final String? pwdStorage = await secureStorage.read(key: 'pwd');
    final String? fakePwdStorage = await secureStorage.read(key: 'fakePwd');
    if(pwdStorage == pwd){
      valid = 1;
    } else if(fakePwdStorage == pwd){
      valid = 2;
    }
    return valid;
  }

  static final StorageService _storageService = StorageService._internal();
  factory StorageService() {
    return _storageService;
  }
  StorageService._internal();

}

final StorageService storageService = StorageService();
