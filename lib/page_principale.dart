import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter_maps/persist.dart';
import 'package:image_auto_slider/image_auto_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings.dart';
import 'mapper.dart' as map;


class MyApp extends StatelessWidget {
  static const routeName = '/homePage';
  final String userid;

  MyApp({Key key, @required this.userid}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Target',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Target'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final bodies = [
    Center(
      child: new Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            ImageAutoSlider(
              assetImages: [
                AssetImage('img/img11.png'),
                AssetImage('img/img2.png'),
                AssetImage('img/img3.png'),
                AssetImage('img/img4.png'),
                AssetImage('img/img5.png'),
                AssetImage('img/img6.png'),
              ],
              slideMilliseconds: 700,
              durationSecond: 5,
              boxFit: BoxFit.scaleDown,
            )
          ],
        ),
      ),
    ),
    Center(
      child: Text("Stats"),
    ),
    Center(),
    Center(
      child: Text("Share"),
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          elevation: 8.0,
          primary: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (BuildContext context) {
                    return new Settings();
                  }));
                })
          ],
        ),
        body: bodies[_currentIndex],
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.location_on,
            color: Colors.red,
            size: 40.0,
          ),
          backgroundColor: Colors.white,
          onPressed: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (BuildContext context) {
              return new map.MyHomePage(title: "Carte");
            }));
          },
        ),
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _currentIndex,
          showElevation: true,
          onItemSelected: (index) => setState(() {
            _currentIndex = index;
          }),
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(title: Text('home'), icon: Icon(Icons.home)),
            BottomNavyBarItem(
                title: Text('stats'), icon: Icon(Icons.assessment)),
            BottomNavyBarItem(
                title: Text('profil'), icon: Icon(Icons.account_circle)),
            BottomNavyBarItem(
                title: Text('share'), icon: Icon(Icons.group_add)),
          ],
        ));
  }
}
