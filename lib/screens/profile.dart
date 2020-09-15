import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_ui_kit/providers/app_provider.dart';
import 'package:restaurant_ui_kit/screens/image_capture.dart';
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
  String profilePicture="";
  User user = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
  }
  getProfile()async {
    DocumentSnapshot doc= await firestoreInstance.collection("users")
        .doc(user.uid).get();
    email=doc.data()["email"];
    firstName=doc.data()["firstName"];
    lastName=doc.data()["lastName"];
    phoneNumber=doc.data()["phoneNumber"];
    address=doc.data()["address"];
    profilePicture=doc.data()["profilePicture"];
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
                  child:  CircularProfileAvatar(
                    profilePicture, //sets image path, it should be a URL string. default value is empty string, if path is empty it will display only initials
                    radius: 50, // sets radius, default 50.0
                    backgroundColor: Colors.transparent, // sets background color, default Colors.white
                    borderWidth: 10,  // sets border, default 0.0
                    initialsText: Text(
                      "",
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),  // sets initials text, set your own style, default Text('')
                    borderColor: Colors.brown, // sets border color, default Colors.white
                    elevation: 5.0, // sets elevation (shadow of the profile picture), default value is 0.0
                    foregroundColor: Colors.brown.withOpacity(0.5), //sets foreground colour, it works if showInitialTextAbovePicture = true , default Colors.transparent
                    cacheImage: true, // allow widget to cache image against provided url
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context){
                            return ImageCapture();
                          },
                        ),
                      );
                    }, // sets on tap
                    showInitialTextAbovePicture: true, // setting it true will show initials text above profile picture, default false
                  )
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
                          FlatButton.icon(
                            color: Colors.red,
                            label: Text('LogOut'),
                            icon: Icon(Icons.power_settings_new),
                            onPressed: (){
                              setState(() {

                              });
                            },
                          ),
                          FlatButton.icon(
                            color: Colors.green,
                            label: Text('Refresh'),
                            icon: Icon(Icons.refresh),
                            onPressed: (){
                             setState(() {

                             });
                            },
                          )
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
                onPressed: ()async {
                  await alertDialogEditFirstName(context);
                  setState(() {

                  });
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
            Container(
              decoration: new BoxDecoration (
                  color: Colors.grey[100]
              ),

              child: ListTile(
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
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                  },
              ),
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
                 firstName=_textFieldController.text;
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
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
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
                  lastName=_textFieldController.text;
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
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
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
                  phoneNumber=_textFieldController.text;
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
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
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
                  address=_textFieldController.text;
                  Navigator.of(context).pop();

                },
              )
            ],
          );
        });
  }
}


