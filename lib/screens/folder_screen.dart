import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:ionicons/ionicons.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:photo_safe/animations/swipe_back.dart';
import 'package:photo_safe/models/folder.dart';
import 'package:photo_safe/screens/image_full_screen.dart';
import 'package:photo_safe/services/storage_service.dart';

class FolderScreen extends StatefulWidget {

  final Folder folder;

  const FolderScreen({Key? key, required this.folder}) : super(key: key);

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {

  final List<File> images = [];
  final List<bool> selectedImages = [];
  final List<String> selectedImagesPath = [];
  bool deletingState = false;
  bool selectAllState = false;
  bool loadingPhotos = false;
  double percentageProgression = 0.0;

  @override
  void initState() {
    super.initState();
    getAllImages();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getAllImages() async {

    images.clear();
    selectedImages.clear();
    final List<String> allImages = await storageService.getAllImagesInFolderInStorage(widget.folder);
    final List<File> imagesFile = [];
    for (final String image in allImages) {
      imagesFile.add(File(image));
      selectedImages.add(false);
    }

    setState(() {
      images.addAll(imagesFile);
    });
  }

  Future<void> importImages() async {

    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true,type: FileType.media);

    if(result != null){
      List<File> imagesFile = result.paths.map((path) => File(path!)).toList();
      final String pathDirectory = (await getApplicationDocumentsDirectory()).path;
      final List<String> imagesPath = [];
      final List<String> nativeImagesPath = [];
      final int totalImagesNumber = imagesFile.length;
      int imagesCopiedNumber = 0;
      for(final File imageFile in imagesFile) {
        final String filename = basename(imageFile.path);
        final File localImage = await imageFile.copy('$pathDirectory/$filename');
        imagesPath.add(localImage.path);
        nativeImagesPath.add(imageFile.path);
        imagesCopiedNumber += 1;
        double finalPercentageProgression = (imagesCopiedNumber)/totalImagesNumber; 
        setState(() {
          percentageProgression = finalPercentageProgression;
          log("Importation: ${(percentageProgression*100).toInt()}%");
        });
      } 
      log("Adding image reference to folder local storage...");
      await storageService.saveImagesInFolderInStorage(widget.folder, imagesPath);
      log("All images added !");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (DragUpdateDetails details) => SwipeBack().onHorizontalDragLeft(context, details),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10,top: 5,bottom: 5),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              },
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: Icon(Ionicons.chevron_back,color: Theme.of(context).colorScheme.secondary,size: 24),
                ),
              ),
            ),
          ),
          title: Text(widget.folder.name, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold,fontSize: 20)),
          actions: [
            Row(
              children: [
                if(deletingState)
                  GestureDetector(
                    onTap: () async {
                      HapticFeedback.lightImpact();
                      final List<bool> imagesPath = [];
                      for (int i = 0; i < images.length; i++) {
                        if(!selectAllState){
                          imagesPath.add(true);
                          selectedImagesPath.add(images[i].path);
                        } else {
                          imagesPath.add(false);
                          selectedImagesPath.clear();
                        }
                      }
                      if(!selectAllState){                        
                        selectedImages.clear();
                        selectedImages.addAll(imagesPath);
                      } else {
                        selectedImages.clear();
                        selectedImages.addAll(imagesPath);
                      }
                      setState(() {
                        selectAllState = !selectAllState;
                        selectedImages.addAll(imagesPath);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5,bottom: 3),
                      child: Card(
                        elevation: 0,
                        color: Theme.of(context).primaryColorLight,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Icon(selectAllState ? Ionicons.grid : Ionicons.grid_outline, color: Theme.of(context).colorScheme.secondary,size: 24),
                        ),
                      ),
                    ),
                  ),
                GestureDetector(
                  onTap: () async {
                    HapticFeedback.lightImpact();
                    setState(() {
                      deletingState = !deletingState;
                      selectAllState = false;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10,top: 5,bottom: 3),
                    child: Card(
                      elevation: 0,
                      color: Theme.of(context).primaryColorLight,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(deletingState ? IconlyBold.delete : IconlyLight.delete, color: Theme.of(context).errorColor,size: 24),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: widget.folder.imagesPath.isEmpty ?
          Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Image.asset("assets/image.png"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text("Aucune image...  pour le moment!",style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 18,fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text("Appuie sur + pour importer des images.",style: TextStyle(color: Theme.of(context).colorScheme.tertiary,fontSize: 15)),
                )
              ],
            ),
          ) 
        : Column(
          children: [
            if(percentageProgression >= 0.00001)
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    percentageProgression = 0.0;
                  });
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      child: LinearPercentIndicator(
                        lineHeight: 10.0,
                        percent: percentageProgression,
                        progressColor: Theme.of(context).colorScheme.secondary,
                        backgroundColor: Theme.of(context).primaryColorLight,
                        barRadius: const Radius.circular(4),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Text("Importation des images en cours...",style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 15,fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                physics: const BouncingScrollPhysics(),
                itemCount: images.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
              
                  File image = images[index];
                  bool selectedImage = selectedImages[index];
                      
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      if(deletingState){
                        setState(() {
                          if(!selectedImage){
                            selectedImagesPath.add(image.path);
                          } else {
                            selectedImagesPath.remove(image.path);
                          }
                          selectedImages[index] = !selectedImages[index];
                        });
                      } else {
                        Navigator.push(context,
                          PageRouteBuilder<void>(
                            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                              return AnimatedBuilder(
                                animation: animation,
                                builder: (BuildContext buildContext, Widget? child) {
                                  return Opacity(
                                    opacity: animation.value,
                                    child: ImageFullScreen(imagesFile: images,imageSelected: index),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      }
                    },
                    child: Stack(
                      children: [
                        Hero(
                          tag: image.path,
                          child: Container(
                            margin: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(23),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(image)
                              )
                            )
                          ),
                        ),
                        if(deletingState)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: selectedImage ? Theme.of(context).errorColor : Theme.of(context).primaryColorLight,
                                borderRadius: BorderRadius.circular(23),
                              ),
                              child: Icon(Ionicons.close,color: selectedImage ? Theme.of(context).primaryColorLight : Theme.of(context).errorColor,size: 20),
                            ),
                          )
                      ],
                    ),
                  );
                }
              ),
            ),
          ],
        ),
        floatingActionButton: GestureDetector(
          onTap: () async {
            HapticFeedback.lightImpact();
            if(!deletingState){
              await importImages();
              getAllImages();
            } else {
              if(selectedImagesPath.isNotEmpty){
                await storageService.deleteSelectedFolderImageInStorage(widget.folder,selectedImagesPath);
                await getAllImages();
                if(images.isEmpty){
                  setState(() {
                    deletingState = false;
                  });
                }
              }
            }
          },
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            color: deletingState ? Theme.of(context).errorColor : Theme.of(context).primaryColorLight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(deletingState ? Ionicons.checkmark : Ionicons.add,color: deletingState ? Theme.of(context).primaryColorLight : Theme.of(context).colorScheme.secondary,size: 40),
            ),
          ),
        ),
      ),
    );
  }
}