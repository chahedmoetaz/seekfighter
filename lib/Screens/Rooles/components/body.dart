import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:seekfighter/Screens/home/components/HomePage.dart';
import 'package:seekfighter/components/default_button.dart';
import 'package:seekfighter/constants/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenWidth(20)),
          Container(
            height: SizeConfig.screenHeight * 0.6,
            child: ListView(

              children:[
                Item('Two fighters will meet with a user holding a verified referee account pertaining to the martial art of the match.'),
                Item('The fighters have an option of fighting within their weight division and/or open weight.'),
                Item('The referee judges who takes the victory and inputs the point for the victor, which will then be displayed as a win on the victor’s profile page and a loss for the losers profile page.'),
                Item('No shows and disqualifications will be marked as a victory and a loss.'),
                Item('Draws are draws and will be marked as no contests.'),
                Item('For any questions please notify straycatninja@gmail.com'),
              ]
            ),
          ),
          SizedBox(height: getProportionateScreenWidth(20)),
          Text(
            "Agree all rolles",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(20),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Spacer(),
          SizedBox(
            width: SizeConfig.screenWidth * 0.6,
            child: DefaultButton(
              text: "Back to home",
              press: ()async  {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('rolles','done');
                Navigator.pushNamed(context, HomePage.routeName);
              },
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Item(String text) {
    return ListTile(
      leading: Icon(Icons.check_circle),
      title: Text(text),
    );
  }
}
