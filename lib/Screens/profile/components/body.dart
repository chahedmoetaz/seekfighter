import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seekfighter/Models/user.dart';
import 'package:seekfighter/Screens/profile/components/profile_pic.dart';
import 'package:seekfighter/Screens/profile/components/profile_setting.dart';
import 'package:seekfighter/constants/constants.dart';
import 'package:seekfighter/constants/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {


  User user;

  File _imageFile;


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
    return user == null ? Center(
        child: SpinKitRing(
          color: kPrimaryColor,
          size: 30,
          lineWidth: 4,
        ) ) :
    Stack(
      children: <Widget>[
        new Container(
          height: double.infinity,
          width: MediaQuery.of(context).size.width,
          color: Colors.grey.shade100,
        ),
        new ClipPath(
          clipBehavior: Clip.antiAlias,
          clipper: new MyClipper(),
          child: new Container(
            height: MediaQuery.of(context).size.height * 0.725,
            decoration: new BoxDecoration(color: Colors.white, boxShadow: [
              new BoxShadow(
                  color: Colors.grey,
                  offset: new Offset(1.0, 10.0),
                  blurRadius: 10.0)
            ]),
            child: new Column(
              children: <Widget>[
                new Expanded(
                  flex: 8,
                  child: new Container(
                    child: new Column(
                      children: <Widget>[
                        new SizedBox(height: getProportionateScreenWidth(5.0)),
                        new ClipRRect(
                          borderRadius: BorderRadius.circular(500.0),
                          child: new Image(
                              fit: BoxFit.fill,
                              height: getProportionateScreenWidth(150.0),
                              width: getProportionateScreenWidth(150.0),
                              image:_imageFile!=null?Image.file(_imageFile):NetworkImage(
                                  user.profilePictureURL!=''?user.profilePictureURL:
                                  'https://www.nicepng.com/png/full/110-1109561_boxing-vector-player-rocky-mobile-game.png')),
                        ),
                        new SizedBox(height: getProportionateScreenWidth(10.0)),
                        new Text(
                          "${user.firstName}, ${user.age}",
                          style: new TextStyle(
                              letterSpacing: 1.1,
                              fontSize: getProportionateScreenWidth(25),
                              fontWeight: FontWeight.w400),
                        ),
                        new Expanded(
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                InkWell(
                                  onTap: ()=>Navigator.pushNamed(context,ProfileSetting.routeName),
                                  child: new Expanded(
                                    child: new Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        new Container(
                                          width: getProportionateScreenWidth(100.0),
                                          height: getProportionateScreenWidth(100.0),
                                          decoration: new BoxDecoration(
                                              color: Colors.blueGrey.shade50,
                                              borderRadius:
                                              BorderRadius.circular(100.0)),
                                          child: new Icon(
                                            Icons.settings,
                                            size: getProportionateScreenWidth(50),
                                            color: Colors.blueGrey.shade200,
                                          ),
                                        ),
                                        new SizedBox(
                                            height: getProportionateScreenWidth(10.0)),
                                        new Text(
                                          "SETTINGS",
                                          style: new TextStyle(
                                              color: Colors.blueGrey.shade200,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                new FittedBox(
                                    child: new Stack(
                                      children: <Widget>[
                                        new Container(
                                          width: getProportionateScreenWidth(120),
                                          height: getProportionateScreenWidth(150),
                                          color: Colors.white,
                                        ),
                                        new Positioned(
                                          right: 1.0,
                                          bottom: 0.0,
                                          left: 1.0,
                                          child: new Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: <Widget>[
                                              new Container(
                                                width: getProportionateScreenWidth(100),
                                                height: getProportionateScreenWidth(100),
                                                decoration: new BoxDecoration(
                                                    gradient: new LinearGradient(
                                                        colors: [
                                                          Theme.of(context).accentColor,
                                                          Theme.of(context)
                                                              .secondaryHeaderColor,
                                                          Theme.of(context).accentColor,
                                                        ],
                                                        begin: Alignment.topRight,
                                                        end: Alignment.bottomRight,
                                                        stops: [0.0, 0.35, 1.0]),
                                                    color: Colors.green,
                                                    borderRadius:
                                                    BorderRadius.circular(150.0)),
                                                child: new Icon(
                                                  Icons.camera_alt,
                                                  color: Colors.white,
                                                  size: getProportionateScreenWidth(50.0),
                                                ),
                                              ),
                                              new SizedBox(
                                                  height: getProportionateScreenWidth(10.0)),
                                              new Text(
                                                "ADD MEDIA",
                                                style: new TextStyle(
                                                    color: Colors.blueGrey.shade200,
                                                    fontWeight: FontWeight.w600),
                                              )
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: ()=>addpicture(context),
                                          child: new Positioned(
                                            right: SizeConfig.screenWidth*0.80,
                                            bottom:SizeConfig.screenWidth* 0.62,
                                            child: new Container(
                                              width: getProportionateScreenWidth(50),
                                              height: getProportionateScreenWidth(50),
                                              decoration: new BoxDecoration(
                                                  boxShadow: [
                                                    new BoxShadow(
                                                      color: Colors.grey,
                                                      offset: new Offset(2.0, 3.0),
                                                      blurRadius: 5.0,
                                                    )
                                                  ],
                                                  color: Colors.white,
                                                  borderRadius:
                                                  new BorderRadius.circular(25)),
                                              child: Center(
                                                child: new Icon(
                                                  Icons.add,
                                                  color: Theme.of(context).accentColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                                InkWell(
                                  onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePic(user))).then((value) => get()),
                                  child: new Expanded(
                                    child: new Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        new Container(
                                          width: getProportionateScreenWidth(100.0),
                                          height: getProportionateScreenWidth(100.0),
                                          decoration: new BoxDecoration(
                                              color: Colors.blueGrey.shade50,
                                              borderRadius:
                                              BorderRadius.circular(100.0)),
                                          child: new Icon(
                                            Icons.edit,
                                            size: getProportionateScreenWidth(50),
                                            color: Colors.blueGrey.shade200,
                                          ),
                                        ),
                                        new SizedBox(
                                            height: getProportionateScreenWidth(10.0)),
                                        new Text(
                                          "EDIT INFO",
                                          style: new TextStyle(
                                              color: Colors.blueGrey.shade200,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
                new Expanded(flex: 3, child: new Container())
              ],
            ),
          ),
        ),

      ],
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

        update(image);

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
        .where( 'uid', isEqualTo: user.userID )
        .getDocuments()
        .then( (doc) =>
        Firestore.instance.document( '/users/${user.userID}' )
            .updateData( {
          'photo': picUrl,

        } )
            .then( (val) {

          print( 'update' );

        } )
            .catchError( (e) => print( e ) ));


  }

  Future<User> getuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid=prefs.getString('uid');
    return Firestore.instance.collection('users').document(uid).get().then((doc){
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

final Shader linearGradient = new LinearGradient(
    colors: [Colors.amber.shade800, Colors.amber.shade600],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [0.0, 1.0])
    .createShader(Rect.fromLTWH(
    0.0, 0.0, SizeConfig.screenWidth*0.3, SizeConfig.screenHeight *0.2));

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = new Path();
    p.lineTo(0, size.height - SizeConfig.screenHeight *0.2);
    Offset controlPoint = new Offset(size.width / 2, size.height);
    p.quadraticBezierTo(controlPoint.dx, controlPoint.dy, size.width,
        size.height - SizeConfig.screenHeight *0.2);
    //p.lineTo(size.width,size.height - getProportionateScreenWidth(200) );
    p.lineTo(size.width, 0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

