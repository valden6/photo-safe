import 'package:flutter/material.dart';

class SlideLeftRoute extends PageRouteBuilder {

  final Widget page;

  SlideLeftRoute({required this.page})
  : super(
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) =>
          page,
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) =>
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
            child: child,
          ),
    );
}
