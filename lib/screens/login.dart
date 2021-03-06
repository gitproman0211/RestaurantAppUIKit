
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restaurant_ui_kit/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'social_login.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';





class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController _emailController = new TextEditingController();
//  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  String firstName="";
  dynamic data;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String tokenId="";


  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token){
      print("printing token");
      print(token);
      tokenId=token;


    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }

  void googleLogIn(String tokenId) {
    signInWithGoogle(tokenId).then((result) {
      if (result != null) {
        print("google sign in details");
        print(result);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return MainScreen();
            },
          ),
        );
      }
    });
  }
  @override
  void initState() {
    super.initState();
    firebaseCloudMessaging_Listeners();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0,0,20,0),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              top: 25.0,
            ),
            child: Text(
              "iniciar sesión en tu cuenta",//Log in to your account
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),

          SizedBox(height: 30.0),
          Card(
            elevation: 3.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: TextField(
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: Colors.white,),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white,),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "Email",
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                  prefixIcon: Icon(
                    Icons.perm_identity,
                    color: Colors.black,
                  ),
                ),
                maxLines: 1,
                controller: _emailController,
              ),
            ),
          ),

          SizedBox(height: 10.0),

          Card(
            elevation: 3.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: TextField(
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: Colors.white,),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white,),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "contraseña",//"""Password",
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
                obscureText: true,
                maxLines: 1,
                controller: _passwordController,
              ),
            ),
          ),

          SizedBox(height: 10.0),

          Container(
            alignment: Alignment.centerRight,
            child: FlatButton(
              child: Text(
                "¿Olvidó contraseña?",
                // "Forgot Password?",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).accentColor,
                ),
              ),
              onPressed: (){
                alertDialogForgotPassword(context);
              },
            ),
          ),

          SizedBox(height: 30.0),

          Container(
            height: 50.0,
            child: RaisedButton(
              child: Text(
                "LOGIN".toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: ()
                async {
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                    );
                    FirebaseAuth.instance
                        .authStateChanges()
                        .listen((User user) {
                      if (user == null) {

                         print('User is currently signed out!');
                      }
                      if (!user.emailVerified) {
                        alertDialogCheckEmail(context);
                      }else {

                         print('User is signed in!');

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context){
                              return MainScreen();
                            },
                          ),
                        );
                      }
                    });
                } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                      alertDialogUserDoesNotExist(context);
                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
                      alertDialogWrongPassword(context);
                    }
                  }
                  },
              color: Theme.of(context).accentColor,
            ),
          ),
          SizedBox(height: 30.0),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width/2,
              child: Row(
                children: <Widget>[
                  RawMaterialButton(
                    onPressed: (){
                      signInWithFacebook(tokenId);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context){
                            return MainScreen();
                          },
                        ),
                      );
                    },
                    fillColor: Colors.blue[800],
                    shape: CircleBorder(),
                    elevation: 4.0,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Icon(
                        FontAwesomeIcons.facebookF,
                        color: Colors.white,
//              size: 24.0,
                      ),
                    ),
                  ),

                  RawMaterialButton(
                    onPressed: (){
                      googleLogIn(tokenId);
                    },
                    fillColor: Colors.white,
                    shape: CircleBorder(),
                    elevation: 4.0,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Icon(
                        FontAwesomeIcons.google,
                        color: Colors.blue[800],
//              size: 24.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
alertDialogUserDoesNotExist(BuildContext context) {
  // This is the ok button
  Widget ok = FlatButton(
    child: Text("reintentar"),//Retry
    onPressed: () {
      Navigator.of(context).pop();
      },
  );
  // show the alert dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Error"),
        content: Text("Inicio de sesión no válido Por favor regístrese!!"),//Invalid login please register
        actions: [
          ok,
        ],
        elevation: 5,
      );
    },
  );
}
alertDialogWrongPassword(BuildContext context) {
  // This is the ok button
  Widget ok = FlatButton(
    child: Text("reintentar"),//Retry
    onPressed: () {
      Navigator.of(context).pop();
      },
  );
  // show the alert dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Error"),
        content: Text("contraseña incorrecta"),//Incorrect Password
        actions: [
          ok,
        ],
        elevation: 5,
      );
    },
  );
}

alertDialogForgotPassword(BuildContext context) async {
  TextEditingController _textFieldController = TextEditingController();
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('¿Cuál es tu email?'),//What is your email?
          content: TextField(
            controller: _textFieldController,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: "email"),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('cancelar'),//Cancel
              onPressed: () async{
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text('presentarse'),//Submit
              onPressed: () async{
                await FirebaseAuth.instance.sendPasswordResetEmail(email: _textFieldController.text);
                Navigator.of(context).pop();
              },
            ),

          ],
        );
      });
}