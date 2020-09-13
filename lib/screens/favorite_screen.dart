import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_ui_kit/util/foods.dart';
import 'package:restaurant_ui_kit/widgets/grid_product.dart';

class FavoriteScreen extends StatefulWidget {

  FavoriteScreen({Key key}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> with AutomaticKeepAliveClientMixin<FavoriteScreen>{
  List<dynamic> order=[];
  List<Map>favorites=[];
  final List<Map> foods=[];
  final firestoreInstance = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFavouritesFromFirebase();

  }

  getFavouritesFromFirebase()async{
    firestoreInstance.collection("menu").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data());
        foods.add(result.data());
      }
      );
    }
    );
    User user = FirebaseAuth.instance.currentUser;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('orders').get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i].get("order");
      // print(a);
      order.add(a);
    }
    // print("Printing order");
    // print(order);
    // print("order length=${order.length}");
    List<dynamic>pastOrders=[];
    for(var i=0;i<order.length;i++){
      // print("order[i] length=${order[i].length}");
      for(var j=0;j<order[i].length;j++){
        if(!pastOrders.contains(order[i][j])){
          pastOrders.add(order[i][j]);
        }

      }
    }
    print("Printing past orders");
    print(pastOrders);
    for(var i=0;i<pastOrders.length;i++){
      for(var j=0;j<foods.length;j++){
        if(foods[j]["name"]==pastOrders[i]){
          favorites.add(foods[j]);
        }
      }
    }
    // print("Printing Favorites");
    // print(favorites.length);
    // print(favorites);
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0,0,10.0,0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            Text(
              "My Favorite Items",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 10.0),

            GridView.builder(
              shrinkWrap: true,
              primary: false,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1.25),
              ),
              itemCount: favorites == null ? 0 :favorites.length,
              itemBuilder: (BuildContext context, int index) {
                Map food = favorites[index];
                return GridProduct(
                  food: food,
                  img: food['image'],
                  isFav: true,
                  name: food['name'],
                  rating: 5.0,
                  raters: 23,
                );
              },
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
