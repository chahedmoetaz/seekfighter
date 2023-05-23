import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'authentication_service.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  MyAppUser _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return MyAppUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
    );
  }

  @override
  Future<MyAppUser> signInAnonymously() async {
     AuthResult userCredential =
        await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(userCredential.user);
  }

  @override
  Future<MyAppUser> signInWithEmailAndPassword(
      String email, String password) async {
    final AuthResult userCredential =
        await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', userCredential.user.uid);
    return _userFromFirebase(userCredential.user);
  }

  @override
  Future<MyAppUser> createUserWithEmailAndPassword(
      String email, String password) async {
    final AuthResult userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', userCredential.user.uid);
    return _userFromFirebase(userCredential.user);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<MyAppUser> signInWithEmailAndLink({String email, String link}) async {
    final AuthResult userCredential =
        await _firebaseAuth.signInWithEmailAndLink(email: email,link: link);
    return _userFromFirebase(userCredential.user);
  }

  @override
  // ignore: missing_return
  bool isSignInWithEmailLink(String link) {
     _firebaseAuth.isSignInWithEmailLink(link).then((value){
       return value;
     });
  }

  @override
  Future<void> sendSignInWithEmailLink({
    @required String email,
    @required String url,
    @required bool handleCodeInApp,
    @required String iOSBundleId,
    @required String androidPackageName,
    @required bool androidInstallApp,
    @required String androidMinimumVersion,
  }) async {
    return await _firebaseAuth.sendSignInWithEmailLink(
      email: email,

        url: url,
        handleCodeInApp: handleCodeInApp,
        iOSBundleID: iOSBundleId,
        androidPackageName: androidPackageName,
        androidInstallIfNotAvailable: androidInstallApp,
        androidMinimumVersion: androidMinimumVersion,

    );
  }

  @override
  Future<MyAppUser> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final AuthResult  userCredential = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('uid', userCredential.user.uid);
        return _userFromFirebase(userCredential.user);
      } else {
        throw PlatformException(
            code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
            message: 'Missing Google Auth Token');
      }
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }
  Future<bool> checkUserExist(String userID) async {
    bool exists = false;
    try {
      await Firestore.instance.document("users/$userID").get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<MyAppUser> signInWithFacebook() async {
    final fb = FacebookLogin();
    final response = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    switch (response.status) {
      case FacebookLoginStatus.success:
        final accessToken = response.accessToken;
        final AuthResult userCredential = await _firebaseAuth.signInWithCredential(
          FacebookAuthProvider.getCredential(accessToken: accessToken.token),
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('uid', userCredential.user.uid);
        return _userFromFirebase(userCredential.user);
      case FacebookLoginStatus.cancel:
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Login cancelado pelo usuário.',
        );
      case FacebookLoginStatus.error:
        throw FirebaseAuthException(
          code: 'ERROR_FACEBOOK_LOGIN_FAILED',
          message: response.error.developerMessage,
        );
      default:
        throw UnimplementedError();
    }
  }


  @override
  Future<MyAppUser> currentUser() async {
    FirebaseUser user =await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  @override
  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final FacebookLogin facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    return _firebaseAuth.signOut();
  }

  @override
  void dispose() {}

  FirebaseAuthException({String code, String message}) {}

  @override

  Stream<MyAppUser> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map((event) => _userFromFirebase(event));
}

