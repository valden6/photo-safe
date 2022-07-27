import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_safe/models/note.dart';
import 'package:photo_safe/services/note_storage_service.dart';

class CreateNoteDialog {
  
  final TextEditingController noteTitleController = TextEditingController();
  final FocusNode noteTitleFocusNode = FocusNode();

  Future<void> _submitNoteTitle(BuildContext context,bool fake) async {
    log("Submitting note title...");
    if(noteTitleController.text != ""){
      if(!fake){
        final Note noteCreated = Note(noteTitleController.text,"",0xFFFFFFFF);
        await noteStorageService.saveNoteInStorage(noteCreated);
      }
      Navigator.pop(context);
    } else {
      log("Note not created !");
    }
  }

  Future<void> showCreateNoteDialog(BuildContext context,bool fake) async {

    noteTitleFocusNode.requestFocus();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).primaryColor,
            ),
            height: 170,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                Text("Créer une note", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold)),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).primaryColorLight,
                    ),
                    child: TextField(
                      controller: noteTitleController,
                      focusNode: noteTitleFocusNode,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                      cursorColor: Theme.of(context).colorScheme.primary,
                      decoration: InputDecoration(
                        hintText: "Titre",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor
                          )
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor
                          )
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _submitNoteTitle(context,fake);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text("Valider", style: TextStyle(color: Theme.of(context).primaryColorLight, fontSize: 16)),
                    )
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
