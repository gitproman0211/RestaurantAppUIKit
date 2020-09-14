import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restaurant_ui_kit/screens/home.dart';
import 'package:restaurant_ui_kit/screens/main_screen.dart';
import 'package:restaurant_ui_kit/util/cartModel.dart';

import 'package:restaurant_ui_kit/util/foodsInCart.dart';
import 'package:restaurant_ui_kit/widgets/cart_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class Checkout extends StatefulWidget {
  final int total;
  final List<FoodInCart> myList;
  final CartModel cartModel;
  Checkout({Key key, @required this.total,@required this.myList,@required this.cartModel}) : super(key: key);
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  String firstName="";
  String lastName="";
  String address="";
  User user = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  final TextEditingController _couponlControl = new TextEditingController();
  int _radioValue = 0;
  String paymentMode="CARD";
  // int points=0;


  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
      switch (_radioValue) {
        case 0:
          paymentMode="CARD";
          break;
        case 1:
          paymentMode="CASH";
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getNameAddress();
  }
  getNameAddress()async {
    DocumentSnapshot doc= await firestoreInstance.collection("users")
        .doc(user.uid).get();
    firstName=doc.data()["firstName"];
    lastName=doc.data()["lastName"];
    address=doc.data()["address"];
    setState(() {

    });
  }
  uploadOrderToDatabase(myList){
    List<String> order=[];
    for(int i=0;i<myList.length;i++){
      order.add(myList[i].food["name"]);
    }
   print(order);
    User user = FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseFirestore.instance;
    databaseReference.collection('users').doc(user.uid).collection('orders').doc().set({
      "order": order,
      "paymentMode": paymentMode.toString(),
      "total": widget.total,
    }).then((value) {
      print("Order uploaded to firebase");
    });
  }
  updatePointsToFirebase(){
    User user = FirebaseAuth.instance.currentUser;
    firestoreInstance.collection("users").doc(user.uid).update({"points":widget.cartModel.points+widget.total~/10});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Checkout",
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w800,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            tooltip: "Back",
            icon: Icon(
              Icons.clear,
              color: Theme.of(context).accentColor,
            ),
            onPressed: ()=>Navigator.pop(context),
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0,0,10.0,130),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                "NAME",
                style: TextStyle(
//                    fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            ListTile(
              title: Text(
                firstName+" "+lastName,
                style: TextStyle(
//                    fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Shipping Address",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                IconButton(
                  onPressed: ()async{
                    await alertDialogEditAddress(context);
                    getNameAddress();
                    setState(() {

                    });
                  },
                  icon: Icon(
                    Icons.edit,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            ListTile(
              title: Text(
                address,
                style: TextStyle(
//                    fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Text(
              "Payment Method",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Radio(
                  value: 0,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange,
                ),
                new Text(
                  'CARD',
                  style: new TextStyle(fontSize: 16.0),
                ),
                new Radio(
                  value: 1,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange,
                ),
                new Text(
                  'CASH',
                  style: new TextStyle(
                    fontSize: 16.0,
                  ),
                ),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                Padding(
                  padding: EdgeInsets.fromLTRB(10,5,5,5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Total",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      Text(
                        "\$"+widget.total.toString(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).accentColor,
                        ),
                      ),

                      Text(
                        "Delivery charges included",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.fromLTRB(5,5,10,5),
                  width: 150.0,
                  height: 50.0,
                  child: FlatButton(
                    color: Theme.of(context).accentColor,
                    child: Text(
                      "Place Order".toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: (){
                        uploadOrderToDatabase(widget.myList);
                        updatePointsToFirebase();
                        alertDialogPlaceOrder(context);
                    },
                  ),
                ),

              ],
            ),
          ],
        ),
      ),

     );
  }
  alertDialogPlaceOrder(BuildContext context) {
    // This is the ok button
    Widget ok = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context){
              return MainScreen();
            },
          ),
        );
      },
    );
    // show the alert dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(

          content: Text("ORDER PLACED SUCCESSFULLY"),
          actions: [
            ok,
          ],
          elevation: 5,
        );
      },
    );
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
