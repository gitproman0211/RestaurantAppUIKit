import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_ui_kit/providers/app_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_ui_kit/screens/join.dart';
import 'package:restaurant_ui_kit/screens/login.dart';
import 'package:restaurant_ui_kit/screens/social_login.dart';
import 'package:restaurant_ui_kit/screens/splash.dart';
import 'package:restaurant_ui_kit/util/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

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
  String points="";
  User user = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage _storage =
  FirebaseStorage(storageBucket: 'gs://restaurantapp-65d0e.appspot.com');
  StorageUploadTask _uploadTask;

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
    points=doc.data()["points"].toString();
    setState(() {

    });
  }
  signOut() async {
    await auth.signOut();
    await signOutGoogle();
    await facebookLogOut();
  }
  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );
    String fileName = DateTime.now().toString();
    fileName = fileName.trim();
    _uploadTask = _storage.ref().child(fileName).putFile(image);
    String docUrl = await (await _uploadTask.onComplete).ref.getDownloadURL();
    firestoreInstance
        .collection("users")
        .doc(user.uid)
        .update({
      "profilePicture": docUrl,
    }).then((value) {
      print("Successfully uploaded profile picture to Firebase");
      getProfile();
      setState(() {

      });
    });
  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );
    String fileName = DateTime.now().toString();
    fileName = fileName.trim();
    _uploadTask = _storage.ref().child(fileName).putFile(image);
    String docUrl = await (await _uploadTask.onComplete).ref.getDownloadURL();
    firestoreInstance
        .collection("users")
        .doc(user.uid)
        .update({
      "profilePicture": docUrl,
    }).then((value) {
      print("Successfully uploaded profile picture to Firebase");
      getProfile();
      setState(() {

     });
    });
  }
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Librería fotográfica'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Cámara'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0,0,10.0,0),

        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child:GestureDetector(
                    onTap: () {
                       _showPicker(context);
                    },
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Color(0xffFDCF09),
                      child: profilePicture!=""
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          profilePicture,
                          fit: BoxFit.cover,
                        ),
                      )
                          : Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(50)),
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  )
                   ),
                FlatButton.icon(
                  color: Colors.red,
                  label: Text('Cerrar sesión'),//Logout
                  icon: Icon(Icons.power_settings_new),
                  onPressed: (){
                        signOut();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context){
                              return JoinApp();
                            },
                          ),
                        );
                  },
                ),
              ],
            ),

            Divider(),
            Container(height: 15.0),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                "Información de la cuenta".toUpperCase(),//Account Information
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              title: Text(
                "Nombre de pila",//First Name
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
                "Apellido",//Last Name
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
                onPressed: ()async{
                 await alertDialogEditLastName(context);

                  setState(() {

                  });
                },
                tooltip: "Edit",
              ),
            ),
            Container(
              decoration: new BoxDecoration (
                  color: Colors.red[300]
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
            Container(
              decoration: new BoxDecoration (
                  color: Colors.red[300]
              ),

              child: ListTile(
                title: Text(
                  "Points",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                subtitle: Text(
                  points,
                ),
              ),
            ),
            ListTile(
              title: Text(
                "teléfono",
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
                onPressed: ()async{
                 await alertDialogEditPhoneNumber(context);

                  setState(() {

                  });
                  },
                tooltip: "Edit",
              ),
            ),

            ListTile(
              title: Text(
                "la dirección",
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
                onPressed: ()async{
                 await alertDialogEditAddress(context);

                  setState(() {

                  });
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
            title: Text('Editar nombre'),// Edit First Name
            content: TextField(
              controller: _textFieldController,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(hintText: "Ingrese nuevo nombre"),//Enter New First Name
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancelar'),//Cancel
                onPressed: () {
                  Navigator.of(context).pop();
                  },
              ),
              new FlatButton(
                child: new Text('Enviar'),//Submit
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
            title: Text('Editar apellido'),//Edit Last Name
            content: TextField(
              controller: _textFieldController,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(hintText: "Ingrese nuevo apellido"),//Enter New Last Name
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancelar'),//Cancel
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Enviar'),//Submit
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
            title: Text('Editar número de teléfono'),//Edit Phone Number
            content: TextField(
              controller: _textFieldController,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.number,

              decoration: InputDecoration(hintText: "Ingrese nuevo número de teléfono"),//Enter New Phone Number
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Enviar'),
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
            title: Text('Editar dirección'),//Edit Address
            content: TextField(
              maxLines: 3,
              controller: _textFieldController,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(hintText: "Ingrese nueva dirección"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Enviar'),
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


