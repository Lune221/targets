import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'sendLoc.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'widgets/dialog.dart' as dialog;
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.userId}) : super(key: key);
  final String title;
  final String userId;

  static const routeName = '/map';

  @override
  _MyHomePageState createState() => _MyHomePageState(userId: userId);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState({this.userId});
  final String userId;
  Uint8List point;
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  final interval = 4;
  Marker marker;
  Set<Marker> markerSet = Set();
  Circle circle;
  GoogleMapController _controller;
  bool getConfirmed = false; //To make sure that we have taken the datas
  bool connect = false;
  bool getEnable = false; //To make sur that we already have a position
  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    setState(() {
      connect = (result == ConnectivityResult.none) ? false : true;
    });
  }
  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/car_icon.png");
    return byteData.buffer.asUint8List();
  }

  Future<Uint8List> getPoint() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/rsz_small_red.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      getEnable = true;
      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));

      Position current = new Position(latlng, userId);
      createRecord(current);
    });
  }

  void setList(lat, long, interval) async {
    await _checkInternetConnectivity();
    if(connect){
      final HttpsCallable getPos = CloudFunctions.instance
        .getHttpsCallable(functionName: 'sendPos')
          ..timeout = const Duration(seconds: 30);
      await getPos.call(<String, dynamic>{
        "lat": lat,
        "long": long,
        "interval": interval
      }).then((values) {
        var datas = values.data;
        int i = 0;
        for (i = 0; i < datas.length; i++) {
          var pos = datas[i];
          LatLng latlng = LatLng(pos["lat"], pos["long"]);
          Marker mark = new Marker(
              markerId: MarkerId("id$i"),
              position: latlng,
              rotation: null,
              draggable: false,
              zIndex: i.toDouble(),
              flat: true,
              anchor: Offset(0.5, 0.5),
              icon: BitmapDescriptor.fromBytes(point));
          this.setState(() {
            getConfirmed = markerSet.add(mark);
          });
        }
        if(marker!=null){
          setState(() {
            markerSet.add(marker);
          });
        }
        return datas;
      });
    }
    else{
      dialog.Dialog(title: "Probleme de connexion", content: "Veillez vérifier que vous avez bien accés à Internet avant de recommencer!;");
    }
      
    
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      point = await getPoint();
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged().listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192.8334901395799,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                  zoom: 18.00)));
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  Widget _getFAB() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22),
      backgroundColor: Theme.of(context).primaryColor,
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // Button de Localisation
        SpeedDialChild(
            child: Icon(Icons.location_searching),
            backgroundColor: Theme.of(context).primaryColor,
            onTap: () {
              getCurrentLocation();
            },
            label: 'Position',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Theme.of(context).primaryColor),
        // Boutton de recherche et de reception des donneés
            SpeedDialChild(
                child: Icon(Icons.track_changes),
                backgroundColor: Color(0xFF801E48),
                onTap: () {
                  if (getEnable) {//On verifie d'abord si on a la position exacte avant d'afficher le button de recupereration des donnees
                    setList(marker.position.latitude, marker.position.longitude,interval);
                  } 
                  else {
                    _showDialog("Position Introuvable", "Vous devez d'abord vous positionner avant de récupérer les zones contaminées!\nAppuyer su l'icone bleu pour vous positionner!",);
                  }
                  
                },
                label: 'Corona',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor: Color(0xFF801E48))
      ],
    );
  }
  _showDialog(title, content) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.userId),
        ),
        body: GoogleMap(
          mapType: MapType.hybrid,
          initialCameraPosition: initialLocation,
          markers: getConfirmed? markerSet : Set.of((marker != null) ? [marker] : []),
          circles: Set.of((circle != null) ? [circle] : []),
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
          },
        ),
        floatingActionButton: _getFAB());
  }
}
