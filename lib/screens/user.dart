import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String prenom, nom, mdp, tel, id;
  //var data;

  User(prenom, nom, tel, mdp){
    this.prenom = prenom;
    this.nom = nom;
    this.mdp = mdp;
    this.tel = tel;
  }
  bool exist = false;
  toJson() {
    return {
      "prenom": prenom,
      "nom": nom,
      "mdp": mdp,
      "tel": tel,
    };
  }
  addNewUser() {
    Firestore.instance.collection("User").add(this.toJson());
  }
  
}