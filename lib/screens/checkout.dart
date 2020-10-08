import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restaurant_ui_kit/screens/home.dart';
import 'package:restaurant_ui_kit/screens/main_screen.dart';
import 'package:restaurant_ui_kit/util/cartModel.dart';
import 'package:http/http.dart';
import 'package:restaurant_ui_kit/util/foodsInCart.dart';
import 'package:restaurant_ui_kit/widgets/cart_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class Checkout extends StatefulWidget {
  final int total;
  final List<FoodInCart> myList;
  final CartModel cartModel;
  final Map selectedRestaurant;
  Checkout({Key key, @required this.total,@required this.myList,@required this.cartModel,@required this.selectedRestaurant}) : super(key: key);
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  String firstName="";
  String lastName="";
  String address="";
  String phoneNumber="";
  User user = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  int _radioValue = 0;
  int deliveryCharge=10;
  String paymentMode="CARD";

  String restaurant1="7JqUizFVXo0cfyxORyLr";
  String restaurant2="7KWYsmiTVvme0l5nq535";
  String restaurant3="f64jyVjSUoCFXBj3C7nv";
  String restaurant4= "nyeDOMRL4N9RB9A2teER";
  String restaurant5="zFuvsnmMq0meASJqKqmT";


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
    getUserDetails();

  }

  getUserDetails()async {
    DocumentSnapshot doc= await firestoreInstance.collection("users")
        .doc(user.uid).get();
    firstName=doc.data()["firstName"];
    lastName=doc.data()["lastName"];
    address=doc.data()["address"];
    phoneNumber=doc.data()["phoneNumber"];
    setState(() {

    });
  }
  uploadOrderToDatabase() async{
    List<Map> order=[];
    for(int i=0;i<widget.myList.length;i++){
      order.add({"name":widget.myList[i].food["name"],"quantity":widget.myList[i].quantity});
    }
   print(order);
    User user = FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseFirestore.instance;
    DocumentReference documentReference = FirebaseFirestore.instance.collection('orders').doc();
    await documentReference.set({
      "order": order,
      "paymentMode": paymentMode.toString(),
      "total": widget.total+deliveryCharge,
      "restaurantId":widget.selectedRestaurant["id"],
      "userId":user.uid,
      "status":"placed",
      "orderId":documentReference.id,
      "timestamp":DateTime.now().toIso8601String(),
      "firstName":firstName,
      "lastName":lastName,
      "phoneNumber":phoneNumber,
      "address":address
    });
    String orderId=documentReference.id;
    print("Order $orderId uploaded to firebase");
    print("selected restaruant Id");
    print(widget.selectedRestaurant["id"]);
    widget.cartModel.cart=[];
    alertDialogPlaceOrder(context);
    if(widget.selectedRestaurant["id"]==restaurant1){
      print("sending notifications to restaurant1");
      get("https://us-central1-restaurantapp-65d0e.cloudfunctions.net/sendNotificationR1");// link for restaurant1
    }
    else if(widget.selectedRestaurant["id"]==restaurant3){
      print("sending notifications to restaurant3");
      get("https://us-central1-restaurantapp-65d0e.cloudfunctions.net/sendNotificationR3");// link for restaurant1
    }
    else if(widget.selectedRestaurant["id"]==restaurant4){
      print("sending notifications to restaurant4");
      get("https://us-central1-restaurantapp-65d0e.cloudfunctions.net/sendNotificationR4");// link for restaurant1
    }
   else  if(widget.selectedRestaurant["id"]==restaurant5){
      print("sending notifications to restaurant5");
      get("https://us-central1-restaurantapp-65d0e.cloudfunctions.net/sendNotificationR5");// link for restaurant1
    }
    else{
      print("sending notifications to restaurant2");
      get("https://us-central1-restaurantapp-65d0e.cloudfunctions.net/sendNotificationR2");// link for restaurant1
    }

  }
  updatePointsToFirebase()async{
    User user = FirebaseAuth.instance.currentUser;
    await firestoreInstance.collection("users").doc(user.uid).update({"points":widget.cartModel.points+widget.total~/10000});
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
        padding: EdgeInsets.fromLTRB(10.0,0,10.0,0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                firstName+" "+lastName,
                style: TextStyle(
                    fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),

            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Dirección de entrega",//Delivery Address
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                IconButton(
                  onPressed: ()async{
                    await alertDialogEditAddress(context);
                    getUserDetails();
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
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "teléfono",//Delivery Address
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                IconButton(
                  onPressed: ()async{
                    await alertDialogEditPhoneNumber(context);
                    getUserDetails();
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
                phoneNumber,
                style: TextStyle(
//                    fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),


            SizedBox(height: 10.0),
            Text(
              "Dirección del restaurante",//Restaurant Address
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              widget.selectedRestaurant["name"],
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              widget.selectedRestaurant["address"],
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              "Método de pago",//Payment Method
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
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

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Total= ₲ ${widget.total}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "Los gastos de envío = ₲ "+ widget.selectedRestaurant["deliveryCharge"].toString(),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "CANTIDAD TOTAL DE LA FACTURA = ₲ ${widget.total+widget.selectedRestaurant["deliveryCharge"]}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    FlatButton(

                      color: Theme.of(context).accentColor,
                      child: Text(
                        "Realizar pedido".toUpperCase(),//Place Order
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: ()async{
                        if(address.length!=0 && phoneNumber.length!=0){
                          await uploadOrderToDatabase();
                          await updatePointsToFirebase();
                        }
                        else{
                          alertDialogEnterAddressPhoneNumber(context);
                        }

                      },
                    ),
                  ],
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

          content: Text("PEDIDO REALIZADO CON ÉXITO"),//ORDER PLACED SUCCESSFULLY
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
            title: Text('Editar dirección'),//Edit Address
            content: TextField(
              maxLines: 3,
              controller: _textFieldController,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(hintText: "Ingrese nueva dirección"),//Enter New Address
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
  alertDialogEnterAddressPhoneNumber(BuildContext context) async {
    TextEditingController _textFieldController = TextEditingController();
    User user = FirebaseAuth.instance.currentUser;
    final firestoreInstance = FirebaseFirestore.instance;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('La dirección y el número de teléfono no pueden estar vacíos'),//Shipping Address and phone number cannot be Empty
            actions: <Widget>[
              new FlatButton(
                child: new Text('OK'),//Submit
                onPressed: () {
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
            title: Text('Editar teléfono'),//Edit Address
            content: TextField(
              maxLines: 3,
              controller: _textFieldController,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(hintText: "Ingrese nueva teléfono"),//Enter New Address
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
                  address=_textFieldController.text;
                  Navigator.of(context).pop();

                },
              )
            ],
          );
        });
  }

}
