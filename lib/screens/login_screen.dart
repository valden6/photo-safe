import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:ionicons/ionicons.dart';
import 'package:local_auth/local_auth.dart';
import 'package:photo_safe/animations/fade_route.dart';
import 'package:photo_safe/app.dart';
import 'package:photo_safe/services/credential_storage_service.dart';

class LoginScreen extends StatefulWidget {

  final String? settings;

  const LoginScreen({Key? key, this.settings}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController pwdController = TextEditingController();
  String firstSavePwd = "";

  @override
  void initState() {
    pwdController.addListener(_onPwdChanged);
    super.initState();
  }

  @override 
  void didChangeDependencies(){
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    pwdController.removeListener(_onPwdChanged);
    pwdController.dispose();
    super.dispose();
  }

  Future<void> _onPwdChanged() async {
    if(pwdController.text.length >= 4){
      if(widget.settings == null){

        //DEBUG ONLY
        // const int valid = 1;

        final int valid = await credentialStorageService.checkPwd(pwdController.text);

        if(valid == 1){
          if(mounted){
            Navigator.pushReplacement(context, FadeRoute(page: const App(fake: false)));
          }
        } else if(valid == 2){
          if(mounted){
            Navigator.pushReplacement(context, FadeRoute(page: const App(fake: true)));
          }
        } else {
          HapticFeedback.heavyImpact();
          pwdController.text = "";
        }
      } else {
        if(firstSavePwd.isEmpty){
          setState(() {
            firstSavePwd = pwdController.text;
            pwdController.text = "";
          });
        } else if(firstSavePwd != pwdController.text){
          setState(() {
            firstSavePwd = "";
            pwdController.text = "";
          });
        } else {
          if(widget.settings == "fake"){
            credentialStorageService.setFakePwd(firstSavePwd);
          } else {
            credentialStorageService.setPwd(firstSavePwd);
          }
          Navigator.pop(context);
        }
      } 
    }
  }

  String showTitleText(){
    String titleText = "";

    if(widget.settings != null){
      if(widget.settings! == "fake"){
        titleText = "Nouveau faux code d'accès";
      } else {
        titleText = "Nouveau code d'accès";
      }
    } else {
      titleText = "Code d'accès";
    }

    return titleText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: widget.settings != null ? AppBar(
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
              child: Icon(Ionicons.chevron_back,color: Theme.of(context).colorScheme.secondary,size: 24),
            ),
          ),
        )
      ) : null,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Text(showTitleText(),style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 26,fontWeight: FontWeight.bold)), 
              Padding(
                padding: const EdgeInsets.only(top: 40,bottom: 40),
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.asset("assets/folder.png"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: TextField(
                    readOnly: true,
                    textAlign: TextAlign.center,
                    cursorColor: Theme.of(context).colorScheme.primary,
                    controller: pwdController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(fontSize: 40,color: Theme.of(context).colorScheme.primary),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        if(pwdController.text.length < 4){
                          pwdController.text = pwdController.text + 1.toString();
                        }                     
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.circular(18)
                        ),
                        child: Center(child: Text("1",style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 26,fontWeight: FontWeight.bold))),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        if(pwdController.text.length < 4){
                          pwdController.text = pwdController.text + 2.toString();
                        }                      
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.circular(18)
                        ),
                        child: Center(child: Text("2",style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 26,fontWeight: FontWeight.bold))),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        if(pwdController.text.length < 4){
                          pwdController.text = pwdController.text + 3.toString();
                        }
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.circular(18)
                        ),
                        child: Center(child: Text("3",style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 26,fontWeight: FontWeight.bold))),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        if(pwdController.text.length < 4){
                          pwdController.text = pwdController.text + 4.toString();
                        }                     
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.circular(18)
                        ),
                        child: Center(child: Text("4",style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 26,fontWeight: FontWeight.bold))),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        if(pwdController.text.length < 4){
                          pwdController.text = pwdController.text + 5.toString();
                        }                      
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.circular(18)
                        ),
                        child: Center(child: Text("5",style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 26,fontWeight: FontWeight.bold))),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        if(pwdController.text.length < 4){
                          pwdController.text = pwdController.text + 6.toString();
                        }
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.circular(18)
                        ),
                        child: Center(child: Text("6",style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 26,fontWeight: FontWeight.bold))),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        if(pwdController.text.length < 4){
                          pwdController.text = pwdController.text + 7.toString();
                        }                     
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.circular(18)
                        ),
                        child: Center(child: Text("7",style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 26,fontWeight: FontWeight.bold))),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        if(pwdController.text.length < 4){
                          pwdController.text = pwdController.text + 8.toString();
                        }                      
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.circular(18)
                        ),
                        child: Center(child: Text("8",style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 26,fontWeight: FontWeight.bold))),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        if(pwdController.text.length < 4){
                          pwdController.text = pwdController.text + 9.toString();
                        }
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.circular(18)
                        ),
                        child: Center(child: Text("9",style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 26,fontWeight: FontWeight.bold))),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,top: 30,bottom: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if(widget.settings != null)
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(18)
                        ),
                      ),
                    if(widget.settings == null)
                      GestureDetector(
                        onTap: () async {
                          HapticFeedback.lightImpact();
                          final LocalAuthentication auth = LocalAuthentication();
                          final bool valid = await auth.authenticate(
                          localizedReason: "Identifiez-vous pour acceder à l'application",
                          options: const AuthenticationOptions(
                            useErrorDialogs: false,
                            biometricOnly: true
                          ));
                          if(valid){
                            if(mounted){
                              Navigator.pushReplacement(context, FadeRoute(page: const App(fake: false)));
                            }
                          }
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight,
                            borderRadius: BorderRadius.circular(18)
                          ),
                          child: Center(child: Icon(IconlyLight.scan,color: Theme.of(context).colorScheme.primary,size: 26)),
                        ),
                      ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        if(pwdController.text.length < 4){
                          pwdController.text = pwdController.text + 0.toString();
                        }                      
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.circular(18)
                        ),
                        child: Center(child: Text("0",style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 26,fontWeight: FontWeight.bold))),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        if(pwdController.text.isNotEmpty){
                          pwdController.text = pwdController.text.substring(0, pwdController.text.length - 1);
                        }
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.circular(18)
                        ),
                        child: Center(child: Icon(Ionicons.arrow_back,color: Theme.of(context).colorScheme.primary,size: 26)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}