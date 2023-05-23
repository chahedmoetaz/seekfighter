import 'package:flutter/material.dart';
import 'package:seekfighter/constants/constants.dart';
import 'package:seekfighter/constants/size_config.dart';
import 'components/body.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text("Sign Up",style: TextStyle(fontSize: getProportionateScreenWidth(25),fontWeight: FontWeight.w500),),centerTitle:true,
        backgroundColor: Colors.white,
      ),
      body: Body(),
    );
  }
}
