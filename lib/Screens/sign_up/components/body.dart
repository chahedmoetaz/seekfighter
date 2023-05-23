import 'package:flutter/material.dart';
import 'package:seekfighter/Screens/splash/splash_screen.dart';
import 'package:seekfighter/components/socal_card.dart';
import 'package:seekfighter/constants/constants.dart';
import 'package:seekfighter/constants/size_config.dart';
import 'package:seekfighter/services/firebase_auth_service.dart';
import 'sign_up_form.dart';

class Body extends StatelessWidget {
  final FirebaseAuthService _Auth = FirebaseAuthService();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04), // 4%
                Text("Register Account", style: headingStyle),
                Text(
                  "Complete your details or continue \nwith social media",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: getProportionateScreenWidth(20)),
                SignUpForm(),
                SizedBox(height: getProportionateScreenWidth(20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocalCard(
                      icon: "assets/icons/google-icon.svg",
                      press: () {
                        _Auth.signInWithGoogle().then((value){if( value.uid!=null)  Navigator.pushNamed(context,SplashScreen.routeName);});
                      },
                    ),
                    SizedBox(width: getProportionateScreenWidth(15),),
                    SocalCard(
                      icon: "assets/icons/facebook-2.svg",
                      press: () {
                        _Auth.signInWithFacebook().then((value){if( value.uid!=null) Navigator.pushNamed(context,SplashScreen.routeName);});
                      },
                    ),

                  ],
                ),
                SizedBox(height: getProportionateScreenWidth(15)),
                Text(
                  'By continuing your confirm that you agree \nwith our Term and Condition',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
