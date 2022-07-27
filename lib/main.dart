import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:photo_safe/models/folder.dart';
import 'package:photo_safe/models/note.dart';
import 'package:photo_safe/screens/login_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); 
  Hive.registerAdapter(FolderAdapter());
  Hive.registerAdapter(NoteAdapter());
  runApp(const PhotoSafeApp());
}

class PhotoSafeApp extends StatelessWidget {
  
  const PhotoSafeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    GlobalKey<NavigatorState> mainNavigatorKey = GlobalKey<NavigatorState>();
    final ThemeData theme = ThemeData(fontFamily: GoogleFonts.montserrat().fontFamily);

    return Provider.value(
      value: mainNavigatorKey,
      child: MaterialApp(
        navigatorKey: mainNavigatorKey,
        debugShowCheckedModeBanner: false,
        theme: theme.copyWith(
          primaryColor: Colors.grey[200]!,
          primaryColorLight: Colors.white,
          errorColor: Colors.red,
          colorScheme: theme.colorScheme.copyWith(
            primary: Colors.black,
            secondary: const Color.fromARGB(255,255,189,123),
            tertiary: Colors.grey[600]
          ),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
