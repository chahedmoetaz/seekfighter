import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seekfighter/Models/user.dart';
import 'package:seekfighter/components/form_error.dart';
import 'package:seekfighter/constants/constants.dart';
import 'package:seekfighter/constants/keyboard.dart';
import 'package:seekfighter/constants/size_config.dart';

// ignore: must_be_immutable
class ProfilePic extends StatefulWidget {
User user;
  ProfilePic(this.user);
  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  final _formKey = GlobalKey<FormState>();

 File _imageFile;

  int height,weight;
  TextEditingController _firstname=TextEditingController();
  TextEditingController _lastname=TextEditingController();
  TextEditingController _height=TextEditingController();
  TextEditingController _weight=TextEditingController();
  TextEditingController _age=TextEditingController();
  final List<String> errors = [];

  String firstName,lastName;

  int age;

  @override
  void initState() {
    super.initState();
    //images.addAll(widget.user.profilePictureURL);
    height=widget.user.height;
    _height.text=widget.user.height.toString();
    weight=widget.user.weight;
    _weight.text=widget.user.weight.toString();
    age=widget.user.age;
    _age.text=widget.user.age.toString();
    _firstname.text=widget.user.firstName;
    firstName=widget.user.firstName;
    lastName=widget.user.lastName;
    _lastname.text=widget.user.lastName;
  }
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(backgroundColor: Colors.white,elevation: 0,centerTitle: true,
        title: Text('Informations',style:TextStyle(color: Colors.black,
                fontWeight: FontWeight.w700,fontSize: getProportionateScreenWidth(24))),
        actions:[InkWell(onTap:()async{
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            KeyboardUtil.hideKeyboard(context);
            if(_imageFile!=null)
              update(_imageFile);
            await Firestore.instance.document('users/${widget.user.userID}' ).updateData({
              'firstName': firstName,
              'lastName': lastName,
              'height': height,
              'age': age,
              'weight': weight,

            });
            Navigator.pop(context);

          }
        },
            child: Center(
              child: Text('Finish',style: TextStyle(
                color: kPrimaryColor,
                fontSize: getProportionateScreenWidth(20)
              ),),
            )),]
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20),vertical: getProportionateScreenWidth(20 )),
          child: Container(
                width: SizeConfig.screenWidth * 0.85,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                ),
                child:Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Center(
                        child:
                        SizedBox(
                          height: 115,
                          width: 115,
                          child: Stack(
                            clipBehavior: Clip.none, fit: StackFit.expand,
                            children: [
                              CircleAvatar(
                                backgroundImage:_imageFile!=null?Image.file(_imageFile): NetworkImage(
                          widget.user.profilePictureURL!=''?widget.user.profilePictureURL:
                          'https://www.nicepng.com/png/full/110-1109561_boxing-vector-player-rocky-mobile-game.png',),backgroundColor: Colors.grey.shade200,),

                              Positioned(
                                right: -16,
                                bottom: 0,
                                child: SizedBox(
                                  height: 46,
                                  width: 46,
                                  // ignore: deprecated_member_use
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      side: BorderSide(color: Colors.white),
                                    ),
                                    color: Color(0xFFF5F6F9),
                                    onPressed: () {addpicture(context );},
                                    child: Icon(Icons.camera_alt),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )

                      ),
                      SizedBox(height: getProportionateScreenWidth(15),       ),

                      Padding(padding:EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(10),

                      ),
                        child: Column(
                          children: [

                            SizedBox(height: getProportionateScreenHeight(30)),
                            buildFirstNameFormField(),
                            SizedBox(height: getProportionateScreenHeight(30)),
                            buildLastNameFormField(),
                            SizedBox(height: getProportionateScreenHeight(30)),
                            buildAgeFormField(),
                            SizedBox(height: getProportionateScreenHeight(30)),
                            buildHeightFormField(),
                            SizedBox(height: getProportionateScreenHeight(30)),
                            buildWeightFormField(),
                            SizedBox(height: getProportionateScreenHeight(20)),
                            FormError(errors: errors),
                            SizedBox(height: getProportionateScreenHeight(10)),

                        ],)
                      ),
                      SizedBox(height: getProportionateScreenHeight(40)),
                      FormError(errors: errors),
                      SizedBox(height: getProportionateScreenHeight(20)),
                    ],
                  ),
                ),
              ),
        ),
      ),


    );
  }
  TextFormField buildLastNameFormField() {
    return TextFormField(controller:_lastname,
      onSaved: (newValue) => lastName = newValue,
      decoration: InputDecoration(
        labelText: "Last Name",
        hintText: "Enter your last name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,

      ),
    );
  }

  TextFormField buildFirstNameFormField() {
    return TextFormField(controller:_firstname,
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
      ),
    );
  }
  TextFormField buildHeightFormField() {
    return TextFormField(controller:_height,
      keyboardType: TextInputType.numberWithOptions(decimal:true),
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
    return TextFormField(controller:_weight,
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
      keyboardType:TextInputType.numberWithOptions(decimal:true),
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
    return TextFormField(controller:_age,
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
      keyboardType: TextInputType.numberWithOptions(decimal:true),
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

  void addpicture(context) async {
    final imageSource = Platform.isIOS
        ? await showCupertinoDialog<bool>(
        context: context,
        builder: (context) =>
            CupertinoAlertDialog(
              content: Text("source"),
              actions: <Widget>[
                MaterialButton(
                  child: Text("camera"),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: Text("galery"),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            )
    )
        :await showDialog<ImageSource>(
        context: context,
        builder: (context) =>
            AlertDialog(elevation: 24.0,
              title: Text("source"),
              actions: <Widget>[
                // ignore: deprecated_member_use
                FlatButton(
                  child: Text("camera"),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                // ignore: deprecated_member_use
                FlatButton(
                  child: Text("galery"),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            )
    );

    if(imageSource != null) {
      // ignore: deprecated_member_use
      File image =await ImagePicker.pickImage(source: imageSource,imageQuality: 90,maxHeight: 150,maxWidth: 150);
      if(image != null) {

        setState(() {
          _imageFile=image;
        });

        print('--------------Image Path--------------------------------');
        print('Image Path ${image.path}');
        print('Image Path $image');
        print('Image Path ${image.toString()}');
        print('--------------Image Path--------------------------------');
        Navigator.pop(context);
      }
    }

  }

  void update(File image)async {
    String fileName = image.path;
    String imageName = fileName
        .substring(fileName.lastIndexOf("/"), fileName.lastIndexOf("."))
        .replaceAll("/", "");
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('users/$imageName');
    final StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    await updateProfilePic(url).catchError((e)=>print(e));

  }

  Future updateProfilePic(picUrl) async {

    Firestore.instance.collection( 'users' )
        .where( 'uid', isEqualTo: widget.user.userID )
        .getDocuments()
        .then( (doc) =>
        Firestore.instance.document( 'users/${widget.user.userID}' )
            .updateData( {
          'photo': picUrl,

        } )
            .then( (val) {

          print( 'update' );

        } )
            .catchError( (e) => print( e ) ));


  }




}
