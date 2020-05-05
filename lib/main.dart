import 'package:flutter/material.dart';
import 'splashScreen.dart';
import 'firetester.dart'; //Pour tester la liaison avec Firebase

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new Splash(), //We run the SplashScreen
  ));
}
