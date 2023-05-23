import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gender_selection/gender_selection.dart';
import 'package:provider/provider.dart';
import 'package:seekfighter/Models/option.dart';
import 'package:seekfighter/Screens/Rooles/rooles_screen.dart';
import 'package:seekfighter/Screens/home/components/HomePage.dart';
import 'package:seekfighter/components/custom_surfix_icon.dart';
import 'package:seekfighter/components/default_button.dart';
import 'package:seekfighter/components/form_error.dart';
import 'package:seekfighter/constants/constants.dart';
import 'package:seekfighter/constants/size_config.dart';
import 'package:seekfighter/services/authentication_service.dart';
import 'package:seekfighter/services/firebase_auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CompleteProfileForm extends StatefulWidget {
  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  String firstName;
  String lastName;
  String phoneNumber;
  String address;
  // ignore: deprecated_member_use
  List<Optionn> options=List<Optionn>();

  int weight;
  MyAppUser user;
  int height;

  int age;


  int genderr;

  String option;

  bool loading=false;

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  void initState() {
    super.initState();
    getuser();
    options.add(new Optionn("Player", 'https://www.nicepng.com/png/full/110-1109561_boxing-vector-player-rocky-mobile-game.png', false));
    options.add(new Optionn("Trainer", 'https://cdn2.vectorstock.com/i/thumb-large/39/66/professional-fitness-coach-or-instructor-vector-18353966.jpg', false));
    options.add(new Optionn("Arbitre", 'https://image.shutterstock.com/image-vector/boxing-match-referee-flat-vector-600w-1477393502.jpg',false));
  }

getuser()async{
  final FirebaseAuthService _Auth = FirebaseAuthService();


    user =await _Auth.currentUser();

}

  @override
  Widget build(BuildContext context) {

    return loading!=false?Center(child: SpinKitRing(
      color: kPrimaryColor,
      size: 30,
      lineWidth: 4,
    ),): Form(
      key: _formKey,
      child: Column(
        children: [
          buildFirstNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildLastNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),

          buildAgeFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildWeightFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildHeightFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Gender(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Option(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "continue",
            press: ()async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
               setState(() {
                 loading=true;
               });
                final prefs = await SharedPreferences.getInstance();
                prefs.setString('uid', user.uid);

                Firestore.instance.document('users/${user.uid}' ).updateData({
                  'firstName': firstName,
                  'lastName': lastName,
                  'height': height,
                  'age': age,
                  'weight': weight,
                  'gender': genderr==0?'Male':'Female',
                  'searchfor': option,
                  'matches': [],
                  'match': [],
                  'notmatches': [],
                  'chattingWith': [],
                });
                Navigator.push( context,MaterialPageRoute(builder: (context)=>RoolessScreen()) );

              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
      onSaved: (newValue) => address = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAddressNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kAddressNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Address",
        hintText: "Enter your phone address",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }
  TextFormField buildLastNameFormField() {
    return TextFormField(
      onSaved: (newValue) => lastName = newValue,
      decoration: InputDecoration(
        labelText: "Last Name",
        hintText: "Enter your last name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
  TextFormField buildFirstNameFormField() {
    return TextFormField(
      onSaved: (newValue) => firstName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "First Name",
        hintText: "Enter your first name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
  TextFormField buildHeightFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => height = int.parse(newValue),
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Enter your height");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Enter your height");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Height",
        hintText: "Enter your height",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
  TextFormField buildWeightFormField() {
    return TextFormField(
      onSaved: (newValue) => weight = int.parse(newValue),
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Enter your weight");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Enter your weight");
          return "";
        }
        return null;
      },
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: "Weight",
        hintText: "Enter your weight",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
  TextFormField buildAgeFormField() {
    return TextFormField(
      onSaved: (newValue) => age = int.parse(newValue),
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Enter your age");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Enter your age");
          return "";
        }
        return null;
      },
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: "Age",
        hintText: "Enter your age",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Gender() {
    return GenderSelection(
      selectedGenderIconBackgroundColor: kPrimaryColor, // default red
      checkIconAlignment: Alignment.centerRight,   // default bottomRight
      selectedGenderCheckIcon: null,selectedGenderIconColor: kPrimaryColor, // default Icons.check
      onChanged: (gender)async {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('gender', gender.index==0?'Male':'Female');
        print(gender);
        setState(() {
          genderr=gender.index;
        });

      },
      equallyAligned: true,
      animationDuration: Duration(milliseconds: 400),
      isCircular: true, // default : true,
      isSelectedGenderIconCircular: true,
      opacityOfGradient: 0.6,
      padding: const EdgeInsets.all(3),
      size: getProportionateScreenWidth(120), //default : 120

    );
  }
  // ignore: non_constant_identifier_names
  Option() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("I'm a",style: TextStyle(color:kTextColor,fontSize: getProportionateScreenWidth(20)),),
        ),
        Container(
          height: 200,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (context, index) {
                return InkWell(
                  splashColor: kPrimaryColor,
                  onTap: ()async {
                    final prefs = await SharedPreferences.getInstance();
                    setState(() {
                      options.forEach((gender){
                        gender.isSelected = false;
                      }
                      );
                      prefs.setString('searchfor', options[index].name);
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

  // ignore: non_constant_identifier_names
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
