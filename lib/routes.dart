import 'package:flutter/widgets.dart';
import 'Screens/Rooles/rooles_screen.dart';
import 'Screens/complete_profile/complete_profile_screen.dart';
import 'Screens/detail_profile/detail_profile_screen.dart';
import 'Screens/forgot_password/forgot_password_screen.dart';
import 'Screens/home/components/HomePage.dart';
import 'Screens/profile/components/profile_setting.dart';
import 'Screens/sign_in/sign_in_screen.dart';
import 'Screens/splash/splash_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  HomePage.routeName:(context)=>HomePage(),
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  DetailProfileScreen.routeName: (context) => DetailProfileScreen(),
  CheckYourInternetConnection.routeName: (context) => CheckYourInternetConnection(),
  ProfileSetting.routeName: (context) => ProfileSetting(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  RoolessScreen.routeName: (context) => RoolessScreen(),

};



class  CheckYourInternetConnection extends StatelessWidget {
  static String routeName='';

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

