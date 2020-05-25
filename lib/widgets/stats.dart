import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_functions/cloud_functions.dart';

var date;

Future<Stat> fetchStat() async {
  final response = await http.get('https://corona.lmao.ninja/v2/countries/Senegal?yesterday&strict&query%20');
  final HttpsCallable getDate = CloudFunctions.instance
        .getHttpsCallable(functionName: 'sendRealDate')
          ..timeout = const Duration(seconds: 30);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON. 
    await getDate.call({
      "millisec:" : json.decode(response.body)["updated"]
      }).then((value) { date = value;});
    print("Les donnees sont ::: **** ${json.decode(response.body)}"); 
    return Stat.fromJson(json.decode(response.body));
    
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Stat');
  }
}

class Stat {
  
  final int updated;
  final int cases;
  final int todayCases;
  final int totalCases;
  final int deaths;
  final int todayDeaths;
  final int recovered;
  final int active;
  final int critical;
  final int tests;
  final int population;
  final String flag;

  Stat({this.updated,this.cases,this.todayCases,this.totalCases,this.deaths,this.todayDeaths,this.recovered,this.active,this.critical,this.tests,this.population,this.flag});

  factory Stat.fromJson(Map<String,dynamic> json) {
    return Stat(
      updated: json["updated"],
      cases: json["cases"],
      todayCases: json["todayCases"],
      deaths: json["deaths"],
      todayDeaths: json["todayDeaths"],
      recovered: json["recovered"],
      active: json["active"],
      critical: json["critical"],
      tests: json["tests"],
      population: json["population"],
      flag: json["countryInfo"]["flag"],
    );
  }
}

List<Widget> getStatList(Stat data){
  List<Widget> statsList = [
    Card(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(Icons.today, color: Colors.red,),
            Column(
              children: <Widget>[
                Text("Nombre de cas d'ujourd'hui : ${data.todayCases}",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0)
                ),
              ],
            )
          ],
        ),
      ),
    ),
    Card(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(Icons.sentiment_very_dissatisfied, color: Colors.red,),
            Column(
              children: <Widget>[
                Text("Nombre de décés d'aujourdhui : ${data.todayDeaths}",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0)
                ),
              ],
            )
          ],
        ),
      ),
    ),
    Card(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(Icons.check_circle_outline, color: Colors.red,),
            Column(
              children: <Widget>[
                Text('Total Confirmés : ${data.cases}',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0)
                ),
              ],
            )
          ],
        ),
      ),
    ),
    Card(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(Icons.airline_seat_flat, color: Colors.red,),
            Column(
              children: <Widget>[
                Text('Total décés : ${data.deaths}',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0)
                ),
              ],
            )
          ],
        ),
      ),
    ),
    Card(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(Icons.favorite_border, color: Colors.green,),
            Column(
              children: <Widget>[
                Text('Total sous traitement : ${data.active}',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0)
                ),
              ],
            )
          ],
        ),
      ),
    ),
    Card(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(Icons.favorite, color: Colors.greenAccent,),
            Column(
              children: <Widget>[
                Text('Total Guéris: ${data.recovered}',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0)
                ),
              ],
            )
          ],
        ),
      ),
    ),
    Card(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(Icons.warning, color: Colors.red,),
            Column(
              children: <Widget>[
                Text('Cas critiques: ${data.critical}',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0)
                ),
              ],
            )
          ],
        ),
      ),
    ),
    Card(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(Icons.offline_pin, color: Colors.blueGrey,),
            Column(
              children: <Widget>[
                Text('Nombre de Tests : ${data.tests}',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0)
                ),
              ],
            )
          ],
        ),
      ),
    ),
    Card(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(Icons.date_range, color: Colors.yellow,),
            Column(
              children: <Widget>[
                Text('Dernière mise à jour : $date',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0)
                ),
              ],
            )
          ],
        ),
      ),
    ),
  ];
  return statsList;
}