import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seekfighter/constants/constants.dart';
import 'package:seekfighter/constants/size_config.dart';
import 'matches.dart';
import 'messages_list.dart';

// ignore: must_be_immutable
class MessagesTab extends StatefulWidget {
  String userId;
  MessagesTab({this.userId});
  @override
  _MessagesTabState createState() => _MessagesTabState();
}

class _MessagesTabState extends State<MessagesTab>  with SingleTickerProviderStateMixin {

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  TabController _tabcontroller;

  @override
  void initState() {
    _tabcontroller = new TabController(length: 2, vsync: this);
    _tabcontroller.index=0;
    _tabcontroller.addListener(() {
      setState(() {});
    });
    super.initState();
    registerNotification();
    configLocalNotification();
  }
  void configLocalNotification() {
    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      Platform.isAndroid ? showNotification(message['notification']) : showNotification(message['aps']['alert']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      FlutterAppBadger.removeBadge();
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      FlutterAppBadger.removeBadge();
      return;
    });
    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      Firestore.instance.collection('users').document(widget.userId).updateData({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: new AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: new TabBar(
            indicatorColor: kBackgroundColor,
            controller: _tabcontroller,
            tabs: [
              new SafeArea(
                child: new Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                  child: Center(
                    child: new Text(
                      'Match',
                      style: TextStyle(color: _tabcontroller.index == 0
                          ? kPrimaryColor
                          : Colors.grey,

                    ),)
                  ),
                ),
              ),
              //Container(height: 2,color: Colors.grey,),

              new SafeArea(
                child: new Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                  child: Center(
                    child: new Text(
                      'Chat',
                      style: TextStyle(
                      color: _tabcontroller.index == 1
                          ? kPrimaryColor
                          : Colors.grey,)

                    ),
                  ),
                ),
              ),
            ]),
      ),
      body:TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabcontroller,
        children: [

          Matches(),
          Messages(widget.userId),
        ],
      ),
    );
  }


  void showNotification(message) async {

String title;
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? 'com.domain.seekfighter' : 'com.domain.seekfighter',
      'SeekFighter',
      'SeekFighter',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics =
    new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    setState((){
      title=  "title" ;
    });

    print(message);
    FlutterAppBadger.updateBadgeCount(1);
    await flutterLocalNotificationsPlugin.show(
        0, '$title ${message['title'].toString()}', message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));



  }
}
