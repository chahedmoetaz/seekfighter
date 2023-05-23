import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seekfighter/Screens/Rooles/rooles_screen.dart';
import 'package:seekfighter/Screens/complete_profile/complete_profile_screen.dart';
import 'package:seekfighter/Screens/home/components/HomePage.dart';
import 'package:seekfighter/Screens/sign_in/sign_in_screen.dart';
import 'package:seekfighter/constants/constants.dart';
import 'package:seekfighter/constants/size_config.dart';
import 'package:seekfighter/services/authentication_service.dart';
import 'package:seekfighter/services/firebase_auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreenn extends StatefulWidget {
  @override
  State createState() {
    return SplashScreennState();
  }
}

class SplashScreennState extends State<SplashScreenn> {
  Future hasFinishedOnBoarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String finishedOnBoarding = prefs.getString('uid');
    String rooles = prefs.getString('rolles');
    final FirebaseAuthService _Auth = FirebaseAuthService();
    MyAppUser user =await _Auth.currentUser();
    if (finishedOnBoarding!='') {
      if (finishedOnBoarding==null) {
        Navigator.pushNamed(context, SignInScreen.routeName);

      } else {
        _Auth.checkUserExist(finishedOnBoarding).then((value)async{

          if(value==false){
            prefs.setString('uid', user.uid);
            await  Firestore.instance.collection( 'users' )
                .document( "$finishedOnBoarding" )
                .setData( {
              'uid': user.uid,
              'email': user.email,
              'photo': user.photoUrl??'',
              'firstName': user.displayName??''
            } );

            Navigator.pushNamed(
                context, CompleteProfileScreen.routeName );
          }

          else {
            Firestore.instance.collection( 'users' )
                .document( "$finishedOnBoarding" ).get().then((value){
              if (value.data['height']==null)
                Navigator.pushNamed(
                    context, CompleteProfileScreen.routeName );
              else  if(rooles==null)
                Navigator.pushNamed( context, RoolessScreen.routeName);
              else  Navigator.push( context,MaterialPageRoute(builder: (context)=>HomePage()) );
            });


          }
        });


      }

    }else  Navigator.pushNamed(context, SignInScreen.routeName);
  }

  @override
  void initState() {
    super.initState();
    hasFinishedOnBoarding();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: kBackgroundColor,
        ),
      ),
    );
  }
}
