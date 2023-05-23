import 'package:flutter/material.dart';
import 'package:seekfighter/constants/constants.dart';
import 'package:seekfighter/constants/size_config.dart';
import 'components/body.dart';

class SignInScreen extends StatelessWidget {
  static String routeName = "/sign_in";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text("Sign In",style: TextStyle(fontSize: getProportionateScreenWidth(25),fontWeight: FontWeight.w500),),centerTitle:true,backgroundColor: Colors.white,

        leading: SizedBox(),
      ),
      body: Body(),
    );
  }
}
