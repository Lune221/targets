import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart' as mainer;
import 'package:cloud_functions/cloud_functions.dart';


class Settings extends StatefulWidget {
  Settings({Key key, this.userId}) : super(key: key);

  final String userId;
  static const routeName = '/settings';
  @override
  _Settings createState() {
    return _Settings(userId: userId);
  }
}

class _Settings extends State<Settings> {
  _Settings({this.userId});

  String prenom;
  String nom;
  String numero;
  final String userId;
  bool autoriser = true;
  bool _connect=false;
  Map<String,String> values;
  @override
  void initState() {
    super.initState();
    _checkInternetConnectivity();
  }

  void changeAuth() async {
    await _checkInternetConnectivity();
    if(_connect){
      final HttpsCallable changeState = CloudFunctions.instance
        .getHttpsCallable(functionName: 'changeStateFromId')
          ..timeout = const Duration(seconds: 30);
      await changeState.call({
        "userId" : userId,
        "etat": true,
      }).then((value) {
        var data = value.data;
        print("Les doonnees recueeees sont ::::::: $data");
        data == true? _showDialog("Succés!", "Les données ont bien été autorisées à la lecture!"):_showDialog("Erreur", "Une erreur est survenue lors de la mise à jour.\Vérifiez votre connexion internet.");
      });
    }
    else{
      _showDialog("Probleme de connexion.", "Veillez vérifier que vous avez bien accés à Internet avant de recommencer!;");
    }
      
    
  }

  _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    _connect = (result == ConnectivityResult.none) ? false : true;
  }

  void _saveData() async {
    await Firestore.instance.collection("User").document(userId).updateData({
      "nom": nom,
      "prenom": prenom,
      "tel": numero,
      //"mdp":
    }).then((_) {
      print("successfully Saved!!!!!!!!!!!! No Problemo!");
      _showDialog("Sauvegarde compléte!", "Vos données ont été mises à jour!\nNouvelles données : \nPrénom : $prenom\nNom : $nom\nNuméro : $numero");
    });
  }

  _logOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
    prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => mainer.MyApp()),
        (Route<dynamic> route) => false);
  }


  _logOutDialog(title, content) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              FlatButton(
                child: Text("NON"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("OUI"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _logOut();
                },
              )
            ],
          );
        });
  }

  _showDialog(title, content) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            'Settings',
          ),
          centerTitle: true,
          elevation: 5.0,
        ),
        body: new Center(
            child: Container(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 30, right: 30),
          child: ListView(
            children: <Widget>[
              
              new Card(
                borderOnForeground: true,
                shadowColor: Colors.blue,
                child: new Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.all(10)),
                    Text("Modifier vos données personnelles.",
                      style: TextStyle(
                        fontSize : 20
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              new Card(
                child: Row(
                  children: <Widget>[
                    Flexible(
                        child: TextFormField(
                      decoration:
                          InputDecoration(hintText: "Modifier votre prenom"),
                      onChanged: (String string) {
                        setState(() {
                          prenom = string;
                        });
                      },
                      initialValue: prenom,
                    )),
                    IconButton(icon: Icon(Icons.create), onPressed: () {})
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
              new Card(
                child: Row(
                  children: <Widget>[
                    Flexible(
                        child: TextFormField(
                      decoration:
                          InputDecoration(hintText: "Modifier votre nom"),
                      onChanged: (String string) {
                        setState(() {
                          nom = string;
                        });
                      },
                      initialValue: nom,
                    )),
                    IconButton(icon: Icon(Icons.create), onPressed: () {})
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
              new Card(
                child: Row(
                  children: <Widget>[
                    Flexible(
                        child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration:
                          InputDecoration(hintText: "Modifier votre numéro"),
                      onChanged: (String string) {
                        setState(() {
                          numero = string;
                        });
                      },
                      initialValue: numero,
                    )),
                    IconButton(icon: Icon(Icons.create), onPressed: () {})
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
              // RaisedButton(
              //   elevation: 5.0,
              //   padding: EdgeInsets.all(10.0),
              //   child: new Text("Enregistrer"),
              //   textColor: Colors.white,
              //   color: Colors.blue,
              //   onPressed: () {
              //     _checkInternetConnectivity();
              //     _connect
              //         ? _saveData()
              //         : _showDialog("Accès Internet",
              //             "Nous ne pouvons pas accéder au serveur. Veuillez vérifier votre connection internet");
              //   },
              // ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                elevation: 5.0,
                padding: EdgeInsets.all(10.0),
                child: new Text("Autoriser l'accès aux données"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  _checkInternetConnectivity();
                  _connect
                      ? changeAuth()
                      : _showDialog("Accès Internet",
                          "Nous ne pouvons pas accéder au serveur. Veuillez vérifier votre connection internet");
                },
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                elevation: 5.0,
                padding: EdgeInsets.all(10.0),
                onPressed: () {
                  _logOutDialog("Confirmation",
                      "Voulez vous vraiment vous déconnecter ?");
                },
                child: new Text("Se Déconnecter."),
                textColor: Colors.white,
                color: Colors.red,
              )
            ],
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.center,
          ),
        )));
  }
}
