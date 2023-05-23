import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seekfighter/Models/option.dart';
import 'package:seekfighter/Screens/splash/splash_screen.dart';
import 'package:seekfighter/constants/constants.dart';
import 'package:seekfighter/constants/keyboard.dart';
import 'package:seekfighter/constants/size_config.dart';
import 'package:seekfighter/services/firebase_auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSetting extends StatelessWidget {

  static String routeName = "/ProfileSetting";

  bool save=false;

  @override
  Widget build(BuildContext context) {
    return Settings();
  }


}
class Settings extends StatefulWidget {


  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // ignore: deprecated_member_use
  List<Optionn> options=List<Optionn>();
  final FirebaseAuthService _Auth = FirebaseAuthService();
  String option;

  SharedPreferences prefs;
  TextEditingController _distance=TextEditingController();

  int distance=4000;
  @override
  void initState() {
    super.initState();
    getdata();
  }
  getdata()async{
    prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.setInt( 'distance',4000 );
      if(prefs.getDouble('distance')!=null) {
        _distance.text = prefs.getInt( 'distance' ).toString( ) ?? '4000';
        distance = prefs.getInt( 'distance' );
        option=prefs.getString('searchfor');
      }
    });

    options.add(new Optionn("Player", 'https://www.nicepng.com/png/full/110-1109561_boxing-vector-player-rocky-mobile-game.png', option=="Player"?true: false));
    options.add(new Optionn("Trainer", 'https://cdn2.vectorstock.com/i/thumb-large/39/66/professional-fitness-coach-or-instructor-vector-18353966.jpg', option=="Trainer"?true: false));
    options.add(new Optionn("Arbitre", 'https://image.shutterstock.com/image-vector/boxing-match-referee-flat-vector-600w-1477393502.jpg',option=="Arbitre"?true: false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(backgroundColor: Colors.white,elevation: 0,centerTitle: true,
          title: Text('Settings',style:TextStyle(color: Colors.black,
              fontWeight: FontWeight.w500,fontSize: getProportionateScreenWidth(25))),

          actions: [InkWell(
            onTap:()async{

              KeyboardUtil.hideKeyboard(context);
    prefs.setString('searchfor', option);
    prefs.setInt('distance', distance);
    String uid=prefs.getString('uid');
    await Firestore.instance.collection( 'users' )
        .where( 'uid', isEqualTo: uid )
        .getDocuments()
        .then( (doc) =>
    Firestore.instance.document( '/users/$uid' )
        .updateData( {
    'searchfor': option,

    } )
        .then( (val) {

    print( 'update' );

    } )
        .catchError( (e) => print( e ) ));
    Navigator.pop(context);

    },
        child: Center(
          child: Text('Finish',style: TextStyle(
              color: kPrimaryColor,
              fontSize: getProportionateScreenWidth(25)
          ),),
        ))],
        ),
        body:SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: getProportionateScreenWidth(350),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
                    child: Column(
                      children: [
                        SizedBox(height: getProportionateScreenWidth(15), ),
                        Option(),
                        SizedBox(height: getProportionateScreenWidth(30), ),
                        SizedBox(height: getProportionateScreenHeight(20)),

                        Divider(height: 2,color: Colors.grey.shade400,),
                        ListTile(
                            onTap: (){
                              _Auth.signOut().then((_){prefs.setString('uid', '');Navigator.pushNamed(context,SplashScreen.routeName);});
                            },
                            leading: Icon(Icons.logout,color: Colors.redAccent
                              ,),
                            title: Text('Log out',style:TextStyle(color: Colors.redAccent,
                                fontWeight: FontWeight.w700,fontSize: getProportionateScreenWidth(30)))
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

    );

  }
  Option() {
    return Column(
      children: [

        buildDistanceFormField(),
        SizedBox(height: getProportionateScreenWidth(30), ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("I search for",style: TextStyle(color:kTextColor,fontSize: getProportionateScreenWidth(20)),),
        ),
        Container(
          height: getProportionateScreenWidth(150),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (context, index) {
                return InkWell(
                  splashColor: kPrimaryColor,
                  onTap: () {

                    setState(() {
                      options.forEach((gender){
                        gender.isSelected = false;
                      }
                      );

                      option=options[index].name;
                      options[index].isSelected = true;
                    });

                  },
                  child: CustomRadio(options[index]),
                );
              }),
        ),
      ],
    );
  }
  TextFormField buildDistanceFormField() {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          distance = int.parse(value);
        });

      },
      controller: _distance,
      maxLines: 1,
      keyboardType: TextInputType.numberWithOptions(
          decimal: true,
          signed: false),

      decoration: InputDecoration(
        labelText: "Distance",
        hintText: "Enter your search Distance",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
  CustomRadio(Optionn option) {

    return Card(
        color: option.isSelected ? kPrimaryColor: Colors.white,
        child: Container(
          height: getProportionateScreenWidth(80),
          width: getProportionateScreenWidth(80),
          alignment: Alignment.center,
          margin: new EdgeInsets.all(5.0),
          child: FittedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.network(
                  option.icon,fit: BoxFit.cover,

                ),
                SizedBox(height: getProportionateScreenWidth(10)),
                Text(
                  option.name,
                  style: TextStyle(
                      color: option.isSelected ? Colors.white :Colors.black,fontWeight:FontWeight.bold,fontSize: getProportionateScreenWidth(25)),
                )
              ],
            ),
          ),
        ));
  }
}
