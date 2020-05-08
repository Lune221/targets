import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:nice_button/nice_button.dart';
import '../screens/passWord_recovery.dart';
import 'user.dart';
import 'package:flutter_maps/mapper.dart' as map;

var firstColor = Color(0xff5b86e5), secondColor = Color(0xff36d1dc);

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  User user; bool connect = true;
  String _tel, _mdp, _message = "";
  var data;
  
  signIn(tel, mdp) async{
    await Firestore.instance.collection("User")
    .where("tel", isEqualTo:tel)
    .where("mdp", isEqualTo:mdp)
    .getDocuments().then((QuerySnapshot docs){
      if(docs.documents.isNotEmpty){
          data = docs.documents[0].data;
          print(data);
          user.id = docs.documents[0].documentID;
          user.nom = data["nom"];
          user.prenom = data["prenom"];
          Navigator.of(context).pushNamed(map.MyHomePage.routeName);
      }
      else {
        data = null;
        print("There is nothing");
        _showDialog("Utilisateur introuvable.", "Veuillez vérifier vos informations de connexion!");
      }
    });
    return data;
  }

  _checkInternetConnectivity() async{
    var result = await Connectivity().checkConnectivity();
    setState(() {
      connect = (result == ConnectivityResult.none) ? false: true;
    });
  }
  _showDialog(title, content){
    showDialog(
      context:context,
      builder: (context){
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
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
        elevation: 10,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        color: Color(0xff37474f),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              'assets/images/logo.png',
              height: 130,
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              style: TextStyle(fontSize: 18, color: Colors.black54),
              keyboardType: TextInputType.numberWithOptions(
                  signed: false, decimal: false),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Téléphone',
                contentPadding: const EdgeInsets.all(15),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(5),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onChanged: (input) {
                setState(() {
                  _message = input.length != 9
                      ? "Entrer un numéro de Téléphone valide."
                      : "";
                  _tel = input;
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              obscureText: true,
              style: TextStyle(fontSize: 18, color: Colors.black54),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Mot de passe',
                contentPadding: const EdgeInsets.all(15),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(5),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onChanged: (input) {
                setState(() {
                  _mdp = input;
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              _message,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            NiceButton(
              background: secondColor,
              radius: 40,
              padding: const EdgeInsets.all(15),
              text: "Se connecter",
              gradientColors: [secondColor, firstColor],
              onPressed: () {
                _checkInternetConnectivity();
                if (connect){
                  user = new User(null, null,_tel , _mdp);
                  signIn(user.tel, user.mdp);
                  
                }
                else{
                  _showDialog("Probléme de connection.", "Verifier votre connection internet!");
                }
                
              },
            ),
            FlatButton(
              child: Text(
                'Mot de passe oublié?',
                //style: TextStyle(fontSize: 20),
                style: TextStyle(
                  color: Color(0xffff4757).withOpacity(0.6),
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  decoration: TextDecoration.underline,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(ForgetPasswordPage.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}