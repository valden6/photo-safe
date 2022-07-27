import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:ionicons/ionicons.dart';
import 'package:photo_safe/animations/slide_left_route.dart';
import 'package:photo_safe/animations/slide_top_route.dart';
import 'package:photo_safe/models/folder.dart';
import 'package:photo_safe/screens/folder_screen.dart';
import 'package:photo_safe/screens/setting_screen.dart';
import 'package:photo_safe/services/image_storage_service.dart';
import 'package:photo_safe/widgets/create_folder_dialog.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {

  final bool fake;
  
  const HomeScreen({Key? key, required this.fake}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  GlobalKey<NavigatorState>? mainNavigatorKey;
  final List<Folder> folders = [];
  bool deletingState = false;

  @override
  void initState() {
    super.initState();
    getAllFolders();
  }

  @override 
  void didChangeDependencies(){
    super.didChangeDependencies();
    mainNavigatorKey = Provider.of<GlobalKey<NavigatorState>>(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getAllFolders() async {
    if(!widget.fake){
      folders.clear();
      final List<Folder> allFolders = await imageStorageService.getAllFoldersInStorage();

      setState(() {
        folders.addAll(allFolders);
      });
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(!widget.fake)
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        mainNavigatorKey!.currentState!.push(SlideTopRoute(page: const SettingScreen()));
                      },
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(IconlyLight.setting, color: Theme.of(context).colorScheme.secondary,size: 24),
                        ),
                      ),
                    ),
                  ),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    HapticFeedback.lightImpact();
                    setState(() {
                      deletingState = !deletingState;
                    });
                  },
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
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () async {
                      HapticFeedback.lightImpact();
                      await CreateFolderDialog().showcreateFolderDialog(context,widget.fake);
                      getAllFolders();
                    },
                    child: Card(
                      elevation: 0,
                      color: Theme.of(context).primaryColorLight,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(Ionicons.add, color: Theme.of(context).colorScheme.secondary,size: 24),
                      ),
                    ),
                  ),
                )
              ],
            ),
            if(folders.isEmpty)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 200),
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: Image.asset("assets/folder.png"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text("Aucun dossier...  pour le moment!",style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 18,fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text("Appuie sur + pour créer un dossier.",style: TextStyle(color: Theme.of(context).colorScheme.tertiary,fontSize: 15)),
                  )
                ],
              ),
            if(folders.isNotEmpty)
              Flexible(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: folders.length,
                  itemBuilder: (context, index) {
                    
                    final Folder folder = folders[index];
                    File? firstImageInFolder;
                    ImageProvider imageProvider = const AssetImage("assets/image.png");

                    if(folder.imagesPath.isNotEmpty){
                      firstImageInFolder = File(folder.imagesPath.first);
                      imageProvider = FileImage(firstImageInFolder);
                    }
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                      child: GestureDetector(
                        onTap: () async {
                          HapticFeedback.lightImpact();
                          if(!deletingState){
                            await Navigator.push(context, SlideLeftRoute(page: FolderScreen(folder: folder)));
                            getAllFolders();
                          }
                        },
                        child: Card(
                          elevation: 0,
                          color: Theme.of(context).primaryColorLight,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(23),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: imageProvider
                                        )
                                      )
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10,right: 10),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(folder.name,style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold,fontSize: 14),textAlign: TextAlign.start)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: GestureDetector(
                                    onTap: () async {
                                      HapticFeedback.lightImpact();
                                      if(deletingState){
                                        imageStorageService.deleteFolderInStorage(folder);
                                        await getAllFolders();
                                        if(folders.isEmpty){
                                          setState(() {
                                            deletingState = false;
                                          });
                                        }
                                      }
                                    },
                                    child: Icon(deletingState ? IconlyBold.delete : Ionicons.chevron_forward,color: deletingState ? Theme.of(context).errorColor : Theme.of(context).colorScheme.secondary,size: 22)
                                  ),
                                )
                              ],
                            )
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      )
    );
  }
}