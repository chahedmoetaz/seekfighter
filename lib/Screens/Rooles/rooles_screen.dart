import 'package:flutter/material.dart';
import 'package:seekfighter/constants/constants.dart';
import 'package:seekfighter/constants/size_config.dart';

import 'components/body.dart';

class RoolessScreen extends StatelessWidget {
  static String routeName = "/rooles";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        leading: SizedBox(),
        title: Text("Rolles",style: TextStyle(fontSize: getProportionateScreenWidth(25),fontWeight: FontWeight.w500),),centerTitle:true,
      ),
      body: Body(),
    );
  }
}
