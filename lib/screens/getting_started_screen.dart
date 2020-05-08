import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nice_button/nice_button.dart';

import '../widgets/slide_item.dart';
import '../model/slide.dart';
import '../widgets/slide_dots.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';

var firstColor = Color(0xff5b86e5), secondColor = Color(0xff36d1dc);

class GettingStartedScreen extends StatefulWidget {
  @override
  _GettingStartedScreenState createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    PageView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: slideList.length,
                      itemBuilder: (ctx, i) => SlideItem(i),
                    ),
                    Stack(
                      alignment: AlignmentDirectional.topStart,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(bottom: 35),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              for(int i = 0; i<slideList.length; i++)
                                if( i == _currentPage )
                                  SlideDots(true)
                                else
                                  SlideDots(false)
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[


                  NiceButton(
                    background: firstColor,
                    radius: 40,
                     text: "Commencer",
                    icon: Icons.account_box,
                    gradientColors: [secondColor, firstColor],
                    
                    padding: const EdgeInsets.all(15),
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pushNamed(SignupScreen.routeName);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Vous avez déja un compte?',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      FlatButton(
                        child: Text(
                          'Se Connecter',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed(LoginScreen.routeName);
                        },
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}