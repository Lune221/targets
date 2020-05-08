import "package:splashscreen/splashscreen.dart";
import 'package:flutter/material.dart';
import 'mapper.dart' as map;
import 'main.dart' as mn;

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      title: new Text(
        'Welcome In SplashScreen',
        style: new TextStyle(fontWeight: FontWeight.bold, 
            fontSize: 20.0),
      ),
      seconds: 6,
      navigateAfterSeconds: mn.MyApp(),
      image: new Image.asset('assets/loading.gif'),
      backgroundColor: Colors.black,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 150.0,
      onClick: () => print("Flutter Egypt"),
      loaderColor: Colors.white,
    );
  }
}
