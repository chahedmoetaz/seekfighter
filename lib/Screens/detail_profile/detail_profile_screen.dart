
import 'package:flutter/material.dart';
import 'package:seekfighter/constants/constants.dart';
import 'package:seekfighter/constants/size_config.dart';
import 'components/body.dart';

class DetailProfileScreen extends StatelessWidget {
  static String routeName = "/DetailProfileScreen";
  String uid;
  int difference;
  DetailProfileScreen({this.uid,this.difference});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(backgroundColor: Colors.white,elevation: 0,centerTitle: true,
        title: Text('Details Profile',style:TextStyle(color: Colors.black,
                fontWeight: FontWeight.w500,fontSize: getProportionateScreenWidth(20))),
        leading: IconButton(onPressed:()=>Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios,size: 25,color: kPrimaryColor)),
      ),
      body: Body(uid,difference),

    );
  }




}
