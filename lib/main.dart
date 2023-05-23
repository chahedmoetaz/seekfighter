import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:seekfighter/services/authentication_service.dart';
import 'Screens/splash/splash_screen.dart';
import 'constants/theme.dart';
import 'routes.dart';

void main() => runApp(MyAppp());

class MyAppp extends StatefulWidget {
  @override
  MyApppState createState() => MyApppState();
}

class MyApppState extends State<MyAppp> with WidgetsBindingObserver {
  static MyAppUser currentUser;
  StreamSubscription tokenStream;



  // Define an async function to initialize FlutterFire

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        theme: theme(),
        debugShowCheckedModeBanner: false,
       routes: routes,
       initialRoute:SplashScreen.routeName,
       // home:SplashScreen(),

    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (auth.FirebaseAuth.instance.currentUser != null && currentUser != null) {
      if (state == AppLifecycleState.paused) {
        //user offline
        tokenStream.pause();

      } else if (state == AppLifecycleState.resumed) {
        //user online
        tokenStream.resume();

      }
    }
  }
}



