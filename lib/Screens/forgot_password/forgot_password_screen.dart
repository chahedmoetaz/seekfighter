import 'package:flutter/material.dart';
import 'package:seekfighter/constants/constants.dart';

import 'components/body.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static String routeName = "/forgot_password";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text("Forgot Password"),centerTitle: true,backgroundColor: Colors.white,
      ),
      body: Body(),
    );
  }
}
