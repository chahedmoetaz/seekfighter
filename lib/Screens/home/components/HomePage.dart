import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:location/location.dart';
import 'package:seekfighter/Models/user.dart';
import 'package:seekfighter/Screens/profile/profile_screen.dart';
import 'package:seekfighter/constants/constants.dart';
import 'package:seekfighter/constants/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../messages/MessagesTab.dart';
import 'TinderTab.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/HomePage";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabcontroller;
  bool trackLocation = false;
  final CollectionReference userscollection =Firestore.instance.collection('users');
  String uid;

  bool compliteLoading=false;
  LocationData curentlocation;

  String searchfor,gender;
  int distance;
  List<User> list;

  User useer;
  @override
  void initState() {
    super.initState();
    _tabcontroller = new TabController(length: 3, vsync: this);
    _tabcontroller.index=1;
    _tabcontroller.addListener(() {
      setState(() {});
    });
    getuid();
  }

  getuid()async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('distance', 4000);
    setState(() {
      uid=prefs.getString('uid');
      distance=prefs.getInt('distance');
      searchfor=prefs.getString('searchfor');
      gender=prefs.getString('gender');
    });
    //if(distance==null)prefs.setInt('distance', 4000);
    final location=Location.instance;
    bool _service;
    PermissionStatus _permistion;
    _service=await location.serviceEnabled();
    if(!_service){
      _service=await location.requestService();
      if(!_service){
        return;
      }
    }

    _permistion=await location.hasPermission();
    if(_permistion==PermissionStatus.denied){
      _permistion=await location.requestPermission();
      if(_permistion==PermissionStatus.granted){
        return;
      }
    }

    curentlocation=await location.getLocation();
    if(curentlocation!=null){
      setState(() {
        curentlocation=curentlocation;
      });
      updatedata(uid);
    }

  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: new AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: new TabBar(
              indicatorColor: Colors.white,
              controller: _tabcontroller,
              tabs: [
                new SafeArea(
                  child: new Container(
                    padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                    child: Center(
                      child: new Icon(
                        Icons.person,
                        color: _tabcontroller.index == 0
                            ? kPrimaryColor
                            : Colors.grey,
                        size: getProportionateScreenWidth(40),
                      ),
                    ),
                  ),
                ),
                new SafeArea(
                  child: new Container(
                    padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                    child: Center(
                      child: new Icon(
                        EvaIcons.search,
                        color: _tabcontroller.index == 1
                            ? kPrimaryColor
                            : Colors.grey,
                        size: getProportionateScreenWidth(40),
                      ),
                    ),
                  ),
                ),
                new SafeArea(
                  child: new Container(
                    padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                    child: Center(
                      child: new Icon(
                        Icons.chat_bubble,
                        color: _tabcontroller.index == 2
                            ? kPrimaryColor
                            : Colors.grey,
                        size: getProportionateScreenWidth(40),
                      ),
                    ),
                  ),
                ),
              ]),
        ),
        body: new TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabcontroller,
          children: <Widget>[
            uid==null?Center(
              child: SpinKitRing(
                color: kPrimaryColor,
                size: 30,
                lineWidth: 4,
              ),
            ):ProfileScreen(),
            compliteLoading==false?Center(
              child: SpinKitRing(
                color: kPrimaryColor,
                size: 30,
                lineWidth: 4,
              ),
            ):TinderTab(userId: uid,),
             MessagesTab(userId:uid)

          ],
        ));
  }

  void updatedata(String uid) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('lat', curentlocation.latitude);
    prefs.setDouble('lon', curentlocation.longitude);
    await Firestore.instance.document('users/$uid' ).updateData({
      'lat': curentlocation.latitude,
      'lon': curentlocation.longitude,
    }).then((value) => setState((){
      compliteLoading =true;
    }));
  }



}
