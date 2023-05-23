import 'package:flutter/material.dart';
import 'package:seekfighter/constants/constants.dart';
import 'package:seekfighter/constants/size_config.dart';

import 'components/body.dart';

class CompleteProfileScreen extends StatelessWidget {
  static String routeName = "/complete_profile";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(backgroundColor: kBackgroundColor,appBar:AppBar(
      title: Text('Complete Profile',style: TextStyle(fontSize: getProportionateScreenWidth(25),fontWeight: FontWeight.w500),),centerTitle:true,

      leading: SizedBox(),
    ),body: Body());
  }
}
