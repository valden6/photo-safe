import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:photo_safe/models/folder.dart';
import 'package:photo_safe/screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); 
  Hive.registerAdapter(FolderAdapter());
  runApp(const PhotoSafeApp());
}

class PhotoSafeApp extends StatelessWidget {
  const PhotoSafeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = ThemeData(fontFamily: GoogleFonts.montserrat().fontFamily);

    return MaterialApp(
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
    );
  }
}
