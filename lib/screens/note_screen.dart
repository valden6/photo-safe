import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ionicons/ionicons.dart';
import 'package:photo_safe/animations/slide_left_route.dart';
import 'package:photo_safe/animations/slide_top_route.dart';
import 'package:photo_safe/models/note.dart';
import 'package:photo_safe/screens/note_detail_screen.dart';
import 'package:photo_safe/screens/setting_screen.dart';
import 'package:photo_safe/services/note_storage_service.dart';
import 'package:photo_safe/widgets/create_note_dialog.dart';
import 'package:provider/provider.dart';

class NoteScreen extends StatefulWidget {

  final bool fake;
  
  const NoteScreen({Key? key, required this.fake}) : super(key: key);

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {

  GlobalKey<NavigatorState>? mainNavigatorKey;
  final List<Note> notes = [];
  bool deletingState = false;

  @override
  void initState() {
    super.initState();
    getAllNotes();
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

  Future<void> getAllNotes() async {
    if(!widget.fake){
      notes.clear();
      final List<Note> allNotes = await noteStorageService.getAllNotesInStorage();

      setState(() {
        notes.addAll(allNotes);
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
                      await CreateNoteDialog().showCreateNoteDialog(context,widget.fake);
                      getAllNotes();
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
            if(notes.isEmpty)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 200),
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: Image.asset("assets/note.png"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text("Aucune notes...  pour le moment!",style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 18,fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text("Appuie sur + pour créer une note.",style: TextStyle(color: Theme.of(context).colorScheme.tertiary,fontSize: 15)),
                  )
                ],
              ),
            if(notes.isNotEmpty)
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                  child: MasonryGridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
              
                      final Note note = notes[index];
              
                      return GestureDetector(
                        onTap: () async {
                          HapticFeedback.lightImpact();
                          if(!deletingState){
                            await Navigator.push(context, SlideLeftRoute(page: NoteDetailScreen(note: note)));
                            getAllNotes();
                          }
                        },
                        child: Card(
                          elevation: 0,
                          color: Color(note.color),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5,bottom: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(child: Padding(
                                        padding: deletingState ? const EdgeInsets.only(left: 27) : EdgeInsets.zero,
                                        child: Text(note.title,style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold,fontSize: 17),textAlign: TextAlign.center),
                                      )),
                                      if(deletingState)
                                        Padding(
                                          padding: const EdgeInsets.only(right: 5),
                                          child: GestureDetector(
                                            onTap: () async {
                                              HapticFeedback.lightImpact();
                                                noteStorageService.deleteNoteInStorage(note);
                                                await getAllNotes();
                                                if(notes.isEmpty){
                                                  setState(() {
                                                    deletingState = false;
                                                  });
                                                }
                                            },
                                            child: Icon(IconlyBold.delete,color: Theme.of(context).errorColor,size: 22)
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                                Text(note.body.isNotEmpty ? note.body : "Ecrire...",style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500,fontSize: 14),textAlign: TextAlign.center),
                              ],
                            )
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
          ],
        ),
      )
    );
  }
}