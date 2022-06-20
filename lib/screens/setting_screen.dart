import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:photo_safe/animations/slide_left_route.dart';
import 'package:photo_safe/screens/login_screen.dart';

class SettingScreen extends StatelessWidget {
  
  const SettingScreen({Key? key}) : super(key: key);

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
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Icon(Ionicons.close,color: Theme.of(context).colorScheme.secondary,size: 24),
            ),
          ),
        ),
        title: Text("Paramètre", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold,fontSize: 20)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.push(context, SlideLeftRoute(page: const LoginScreen(settings: "pin")));
              },
              child: Card(
                elevation: 0,
                color: Theme.of(context).primaryColorLight,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text("Modifier le code pin", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold,fontSize: 16)),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Icon(Ionicons.chevron_forward,color: Theme.of(context).colorScheme.secondary,size: 20),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.push(context, SlideLeftRoute(page: const LoginScreen(settings: "fake")));
              },
              child: Card(
                elevation: 0,
                color: Theme.of(context).primaryColorLight,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text("Modifier le faux code pin", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold,fontSize: 16)),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Icon(Ionicons.chevron_forward,color: Theme.of(context).colorScheme.secondary,size: 20),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Column(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset("assets/company-blue.png"),
                ),
                Text("Version 1.0.0", style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 16))
              ],
            ),
          ),
        ],
      ),
    );
  }
}