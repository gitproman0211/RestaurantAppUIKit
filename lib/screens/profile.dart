import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_ui_kit/providers/app_provider.dart';
import 'package:restaurant_ui_kit/screens/splash.dart';
import 'package:restaurant_ui_kit/util/const.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String email="";
  String firstName="";
  String lastName="";
  String phoneNumber="";
  String address="";
  User user = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEmail();


  }
  getEmail()async {
    DocumentSnapshot doc= await firestoreInstance.collection("users")
        .doc(user.uid).get();
    email=doc.data()["email"];
    firstName=doc.data()["firstName"];
    lastName=doc.data()["lastName"];
    phoneNumber=doc.data()["phoneNumber"];
    address=doc.data()["address"];
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0,0,10.0,0),

        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Image.asset(
                    "assets/cm4.jpeg",
                    fit: BoxFit.cover,
                    width: 100.0,
                    height: 100.0,
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            firstName+" "+lastName,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 5.0),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            email,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            onTap: (){
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context){
                                    return SplashScreen();
                                  },
                                ),
                              );
                            },
                            child: Text("Logout",
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).accentColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                  flex: 3,
                ),
              ],
            ),

            Divider(),
            Container(height: 15.0),

            Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                "Account Information".toUpperCase(),
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            ListTile(
              title: Text(
                "First Name",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                firstName,
              ),

              trailing: IconButton(
                icon: Icon(
                  Icons.edit,
                  size: 20.0,
                ),
                onPressed: (){
                  alertDialogEditFirstName(context);
//                  setState(() {
//
//                  });
                  },
                tooltip: "Edit",
              ),
            ),
            ListTile(
              title: Text(
                "Last Name",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                lastName,
              ),

              trailing: IconButton(
                icon: Icon(
                  Icons.edit,
                  size: 20.0,
                ),
                onPressed: (){
                  alertDialogEditLastName(context);
                },
                tooltip: "Edit",
              ),
            ),
            ListTile(
              title: Text(
                "Email",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),

              subtitle: Text(
                email,
              ),
            ),

            ListTile(
              title: Text(
                "Phone",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),

              subtitle: Text(
                phoneNumber,
              ),

              trailing: IconButton(
                icon: Icon(
                  Icons.edit,
                  size: 20.0,
                ),
                onPressed: (){
                  alertDialogEditPhoneNumber(context);
                },
                tooltip: "Edit",
              ),
            ),

            ListTile(
              title: Text(
                "Address",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),

              subtitle: Text(
                address,
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.edit,
                  size: 20.0,
                ),
                onPressed: (){
                  alertDialogEditAddress(context);
                },
                tooltip: "Edit",
              ),
            ),

//            ListTile(
//              title: Text(
//                "Gender",
//                style: TextStyle(
//                  fontSize: 17,
//                  fontWeight: FontWeight.w700,
//                ),
//              ),
//
//              subtitle: Text(
//                "Female",
//              ),
//            ),
//
//            ListTile(
//              title: Text(
//                "Date of Birth",
//                style: TextStyle(
//                  fontSize: 17,
//                  fontWeight: FontWeight.w700,
//                ),
//              ),
//
//              subtitle: Text(
//                "April 9, 1995",
//              ),
//            ),

             MediaQuery.of(context).platformBrightness == Brightness.dark
                 ? SizedBox()
                 : ListTile(
              title: Text(
                "Dark Theme",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),

              trailing: Switch(
                value: Provider.of<AppProvider>(context).theme == Constants.lightTheme
                    ? false
                    : true,
                onChanged: (v) async{
                  if (v) {
                    Provider.of<AppProvider>(context, listen: false)
                        .setTheme(Constants.darkTheme, "dark");
                  } else {
                    Provider.of<AppProvider>(context, listen: false)
                        .setTheme(Constants.lightTheme, "light");
                  }
                },
                activeColor: Theme.of(context).accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
alertDialogEditFirstName(BuildContext context) async {
  TextEditingController _textFieldController = TextEditingController();
  User user = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit First Name'),
          content: TextField(
            controller: _textFieldController,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(hintText: "Enter New First Name"),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Submit'),
              onPressed: () {
                firestoreInstance
                    .collection("users")
                    .doc(user.uid)
                    .update({
                  "firstName": _textFieldController.text,
                }).then((value) {
                  print("Success");
                });
                Navigator.of(context).pop();

              },
            )
          ],
        );
      });
}
alertDialogEditLastName(BuildContext context) async {
  TextEditingController _textFieldController = TextEditingController();
  User user = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Last Name'),
          content: TextField(
            controller: _textFieldController,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(hintText: "Enter New Last Name"),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Submit'),
              onPressed: () {
                firestoreInstance
                    .collection("users")
                    .doc(user.uid)
                    .update({
                  "lastName": _textFieldController.text,
                }).then((value) {
                  print("Success");
                });
                Navigator.of(context).pop();

              },
            )
          ],
        );
      });
}
alertDialogEditPhoneNumber(BuildContext context) async {
  TextEditingController _textFieldController = TextEditingController();
  User user = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Phone Number'),
          content: TextField(
            controller: _textFieldController,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.number,

            decoration: InputDecoration(hintText: "Enter New Phone Number"),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Submit'),
              onPressed: () {
                firestoreInstance
                    .collection("users")
                    .doc(user.uid)
                    .update({
                  "phoneNumber": _textFieldController.text,
                }).then((value) {
                  print("Success");
                });
                Navigator.of(context).pop();

              },
            )
          ],
        );
      });
}
alertDialogEditAddress(BuildContext context) async {
  TextEditingController _textFieldController = TextEditingController();
  User user = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Address'),
          content: TextField(
            maxLines: 3,
            controller: _textFieldController,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(hintText: "Enter New Address"),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Submit'),
              onPressed: () {
                firestoreInstance
                    .collection("users")
                    .doc(user.uid)
                    .update({
                  "address": _textFieldController.text,
                }).then((value) {
                  print("Success");
                });
                Navigator.of(context).pop();

              },
            )
          ],
        );
      });
}
