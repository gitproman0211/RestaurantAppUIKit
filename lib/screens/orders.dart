import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {

  Orders({Key key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  User user = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  List<Map> restaurants=[];
  List<Map> orders = [];
  Map restaurantMap=new Map();
  bool isLoading;

  fetchOrders() async {
    var ordersRef = FirebaseFirestore.instance.collection("orders");
    var query = await ordersRef.where("userId", isEqualTo: user.uid).get();
    var orderSnapShotList = query.docs;
    print("order snapshotlist");
    print(orderSnapShotList);
    for (int i = 0; i < orderSnapShotList.length; i++) {
      Map temp = orderSnapShotList[i].data();
      String timeStamp=temp["timestamp"];
      String formattedTimestamp="";
      for(int i=0;i<timeStamp.length;i++){
        if(i<10)
          formattedTimestamp+=timeStamp[i];
        if(i==10)
          formattedTimestamp+=" ";
        if(i>10 && i<16)
          formattedTimestamp+=timeStamp[i];
        if(i==16){
          formattedTimestamp+=" Hrs";
          break;
        }
      }
      temp["timestamp"]=formattedTimestamp;
      orders.add(temp);
    }
    print(orders);
    isLoading=false;
    setState(() {

    });
  }
  fetchRestaurantNames()async{
    var restaurantsRef = FirebaseFirestore.instance.collection("restaurants");
    var query = await restaurantsRef.get();
    var restaurantsSnapShotList = query.docs;
    print("Restaurant snapshotlist");
    print(restaurantsSnapShotList);
    for (int i = 0; i < restaurantsSnapShotList.length; i++) {
      Map temp = restaurantsSnapShotList[i].data();
      restaurants.add(temp);
    }
    print(restaurants);
    for(int i=0;i<restaurants.length;i++){
      restaurantMap[restaurants[i]["id"]]=restaurants[i]["name"];
    }
    print(restaurantMap);
    isLoading=false;
  }
  @override
  void initState() {
    // TODO: implement initState
    isLoading=true;
    super.initState();
    fetchRestaurantNames();
    fetchOrders();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.keyboard_backspace,
        //   ),
        //   onPressed: ()=>Navigator.pop(context),
        // ),
        centerTitle: true,
        title: Text(
          "HISTORIAL DE PEDIDOS",//ORDER HISTORY
        ),
        elevation: 0.0,
        actions: <Widget>[

        ],
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.cyan,
          strokeWidth: 5,
        ),
      )
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.blue[100],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text("Nombre del restaurante",
                          style: TextStyle(color: Colors.red)),
                      Text(restaurantMap[orders[index]["restaurantId"]],
                          style: TextStyle(color: Colors.green)),
                      Column(
                        children: List.generate(orders[index]["order"].length, (i) {
                          return Container(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Nombre :"+orders[index]["order"][i]["name"],
                                        style: TextStyle(color: Colors.black)),
                                    Text("Cantidad :"+orders[index]["order"][i]["quantity"].toString(),
                                        style: TextStyle(color: Colors.black)),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                        ),
                      ),
                      Text("Tiempo de la orden:"+orders[index]["timestamp"].toString(),//Time
                          style: TextStyle(color: Colors.red,)),
                      Text("Modo de pago:"+orders[index]["paymentMode"],//Payment Mode
                          style: TextStyle(color: Colors.green)),
                      Text("Total:"+orders[index]["total"].toString(),
                          style: TextStyle(color: Colors.black)),
                      Text("Estado:"+orders[index]["status"],
                          style: TextStyle(color: Colors.black)),

                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
