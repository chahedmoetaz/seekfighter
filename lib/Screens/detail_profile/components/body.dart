import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:seekfighter/Models/user.dart';
import 'package:seekfighter/components/photo.dart';
import 'package:seekfighter/constants/constants.dart';
import 'package:seekfighter/constants/size_config.dart';

class Body extends StatefulWidget {
  Body(this.uid,this.difference);
  String uid;
  int difference;
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  double distanceInMeters;
  List<String> _listOfImages;
  User user;


  @override
  void initState() {
    super.initState();

    get();
  }
  get()async{
    await getuser().then((value) => setState((){
      user=value;
    }));

  }


  @override
  Widget build(BuildContext context) {
    return user==null?Center(
        child: SpinKitRing(
          color: kPrimaryColor,
          size: 30,
          lineWidth: 4,
        )):SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Images(),
          SizedBox(height: getProportionateScreenWidth(15),),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
            child: Column(
              children: [
                Text('${user.firstName}, ${user.age}',style: TextStyle(
                    fontSize: getProportionateScreenWidth(30),color: Colors.black
                ),),
                SizedBox(height: getProportionateScreenWidth(15),),
                Row(
                  children: [
                    Icon(EvaIcons.person,size: getProportionateScreenWidth(30),),
                    Text('height : ',style: TextStyle(
                        fontSize: getProportionateScreenWidth(23)
                    ),),
                    Text(user.height.toString(),style: TextStyle(
                        fontSize: getProportionateScreenWidth(23)
                    ),),
                  ],
                ),
                SizedBox(height: getProportionateScreenWidth(15),),
                Row(
                  children: [
                    Icon(EvaIcons.person,size: getProportionateScreenWidth(30),),
                    Text('weight : ',style: TextStyle(
                        fontSize: getProportionateScreenWidth(23)
                    ),),
                    Text(user.weight.toString(),style: TextStyle(
                        fontSize: getProportionateScreenWidth(23)
                    ),),
                  ],
                ),
                SizedBox(height: getProportionateScreenWidth(15),),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      color: Colors.black,
                    ),
                    Text(
                      widget.difference != null
                          ? (widget.difference / 1000).floor().toString() +
                          "km away"
                          : "away",
                        style: TextStyle(
                        fontSize: getProportionateScreenWidth(23)
          ),),
                  ],
                ),

              ],
            ),
          ),
          SizedBox(height: getProportionateScreenWidth(15),),
        ],

      ),
    );
  }

  Images(){

    return Container(
      height: getProportionateScreenHeight(300),
      child: Container(
        width: getProportionateScreenWidth(400),
        height: getProportionateScreenHeight(400),
        child: PhotoWidget(
          photoLink: user.profilePictureURL,
        ),
      ),
    );
  }



  Future<User> getuser() async {
    return Firestore.instance.collection('users').document(widget.uid).get().then((doc){
      return User(
        userID: doc.data['uid'],
        email: doc.data['email'],
        age: doc.data['age'],
        weight: doc.data['weight'],
        height: doc.data['height'],
        firstName: doc.data['firstName'],
        gender: doc.data['gender'],
        lastName: doc.data['lastName'],
        searchfor: doc.data['searchfor'],
        profilePictureURL: doc.data['photo'],
      );});

  }

}
