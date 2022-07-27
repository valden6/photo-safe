import 'package:custom_top_navigator/custom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:photo_safe/screens/home_screen.dart';
import 'package:photo_safe/screens/note_screen.dart';

class App extends StatefulWidget {

  final bool fake;

  const App({Key? key, required this.fake}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState(){
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override 
  void didChangeDependencies(){
    super.didChangeDependencies();
  }

  void _onBarItemTap(int index) {
    navigatorKey.currentState!.maybePop();
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index, duration: const Duration(milliseconds: 250), curve: Curves.fastOutSlowIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: CustomTopNavigator(
        navigatorKey: navigatorKey,
        pageRoute: PageRoutes.materialPageRoute,
        home: PageView(
          controller: _pageController,
            onPageChanged: (index) {
              setState(() => _selectedIndex = index);
            },
            children: <Widget> [
              HomeScreen(fake: widget.fake),
              NoteScreen(fake: widget.fake)
            ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        backgroundColor: Theme.of(context).primaryColor,
        fixedColor: Theme.of(context).colorScheme.secondary, 
        unselectedItemColor: Theme.of(context).colorScheme.tertiary,
        selectedFontSize: 16,
        unselectedFontSize: 13,
        onTap: _onBarItemTap,
        currentIndex: _selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: "Photos",
            icon: Icon(Ionicons.image_outline),
          ),
          BottomNavigationBarItem(
            label: "Notes",
            icon: Icon(Ionicons.file_tray_full_outline,size: 28),
          ),
        ],
      ),
    );
  }

}
