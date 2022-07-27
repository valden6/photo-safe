import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:photo_safe/models/note.dart';
import 'package:photo_safe/services/note_storage_service.dart';
import 'package:share_plus/share_plus.dart';

class NoteDetailScreen extends StatefulWidget {

  Note note;

  NoteDetailScreen({super.key, required this.note});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {

  final FocusNode focusNodeBody = FocusNode();
  final TextEditingController bodyController = TextEditingController();
  final FocusNode focusNodeTitle = FocusNode();
  final TextEditingController titleController = TextEditingController();
  bool colorSelectionState = false;
  final List<Color> backgroundColors = [
    Colors.white,
    const Color(0xFFFEDFE5),
    const Color(0xFFFEBCFF),
    const Color(0xFFB8F9FE),
    const Color(0xFFFEEFAA),
    const Color(0xFFBEB9E5),
    const Color(0xFFFED4A4),
    const Color(0xFFFEB19F),
    const Color(0xFFC2C3C5),
    const Color(0xFFC7F0E0),
    const Color(0xFFCFE8D1),
  ];
  Color? colorSelected;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.note.title;
    bodyController.text = widget.note.body;
    colorSelected = Color(widget.note.color);
  }

  @override
  void dispose() {
    focusNodeBody.dispose();
    focusNodeTitle.dispose();
    bodyController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10,top: 5,bottom: 5),
          child: GestureDetector(
            onTap: () async {
              HapticFeedback.lightImpact();
              if(colorSelected != null){
                widget.note.color = colorSelected!.value;
              } else {
                widget.note.color = 0xFFFFFFFF;
              }
              widget.note.title = titleController.text;
              widget.note.body = bodyController.text;
              await noteStorageService.updateNoteInStorage(widget.note);
              if(mounted){
                Navigator.pop(context);
              }
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
        title: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            focusNodeBody.unfocus();
          },
          child: Text(titleController.text.isNotEmpty ? titleController.text : "Aucun titre" , style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold,fontSize: 20)),
        ),
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  HapticFeedback.lightImpact();
                  setState(() {
                    colorSelectionState = !colorSelectionState;
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
                      child: Icon(colorSelectionState ? Ionicons.color_palette : Ionicons.color_palette_outline, color: Theme.of(context).colorScheme.secondary,size: 24),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  HapticFeedback.lightImpact();
                  final String noteShared = "${titleController.text}\n\n${bodyController.text}";
                  Share.share(noteShared);
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 10,top: 5,bottom: 3),
                  child: Card(
                    elevation: 0,
                    color: Theme.of(context).primaryColorLight,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(Ionicons.share_outline, color: Theme.of(context).colorScheme.secondary,size: 24),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if(colorSelectionState)
              Padding(
                padding: const EdgeInsets.only(left: 15,top: 10),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Couleur du fond" , style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold,fontSize: 14))),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: backgroundColors.length,
                            itemBuilder: (context, index) {

                              final Color color = backgroundColors[index];

                              return Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    setState(() {
                                      colorSelected = color;
                                    });
                                  },
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: color,
                                    child: color == colorSelected ? Icon(Ionicons.checkmark,color: Theme.of(context).colorScheme.primary,size: 25) : Container()
                                  ),
                                ),
                              );
                            }
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                color: colorSelected,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 0,
                child: TextField(
                  onChanged: (value) {
                    setState(() {});
                  },
                  textAlignVertical: TextAlignVertical.top,
                  cursorColor: Theme.of(context).colorScheme.secondary,
                  focusNode: focusNodeTitle,
                  controller: titleController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(fontSize: 17,color: Theme.of(context).colorScheme.primary,fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    hintText: "Titre de la note",
                    hintStyle: TextStyle(fontSize: 17,color: Theme.of(context).colorScheme.primary,fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ), 
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
              child: SizedBox(
                height: 554,
                child: Card(
                  color: colorSelected,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  elevation: 0,
                  child: TextField(
                    textAlignVertical: TextAlignVertical.top,
                    expands: true,
                    maxLines: null,
                    cursorColor: Theme.of(context).colorScheme.secondary,
                    focusNode: focusNodeBody,
                    controller: bodyController,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(fontSize: 17,color: Theme.of(context).colorScheme.primary),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      hintText: "Ecrire...",
                      hintStyle: TextStyle(fontSize: 17,color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}