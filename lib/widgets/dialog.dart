import 'package:flutter/material.dart';

class Dialog extends StatelessWidget{
  Dialog({this.title, this.content});

  final String title;
  final String content;
  @override
  Widget build(BuildContext context) {
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
}