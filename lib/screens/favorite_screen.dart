import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:restaurant_ui_kit/widgets/grid_product.dart';

class FavoriteScreen extends StatefulWidget {
  FavoriteScreen({Key key}) : super(key: key);
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> with AutomaticKeepAliveClientMixin<FavoriteScreen>{
  List<String>favorites=[];
  List<Map>menu=[];
  List<Map> favoriteFoods=[];
  final firestoreInstance = FirebaseFirestore.instance;
  User user = FirebaseAuth.instance.currentUser;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     getFavoriteFoodsFromOrders();
     getMenu();

  }
  getMenu() {
    menu=[];
    firestoreInstance.collection("menu").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        menu.add(result.data());
      }
      );
      for(int i=0;i<menu.length;i++){
        if(favorites.contains(menu[i]["name"])){
          favoriteFoods.add(menu[i]);
        }
      }
      print("printing favorite foods Map");
      print(favoriteFoods.length);
      print(favoriteFoods);
      isLoading=false;
      setState(() {

      });
    }
    );

  }
  getFavoriteFoodsFromOrders() async{
    isLoading=true;
    var ordersRef = FirebaseFirestore.instance.collection("orders");
    var query = await ordersRef.where("userId", isEqualTo: user.uid).get();
    var orderSnapShotList = query.docs;
    print("order snapshotlist");
    print(orderSnapShotList);
    for (int i = 0; i < orderSnapShotList.length; i++) {
      Map temp = orderSnapShotList[i].data();
      for(int i=0;i<temp["order"].length;i++){
        favorites.add(temp["order"][i]["name"]);
      }
    }
    favorites=favorites.toSet().toList();
    print("Printing Favorite Strings");
    print(favorites);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body:isLoading
          ? Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.cyan,
          strokeWidth: 5,
        ),
      )
          :  Padding(
        padding: EdgeInsets.fromLTRB(10.0,0,10.0,0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            Text(
              "Mis artículos favoritos",//My Favorite Items
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 10.0),

            favorites.length==0? Text(
              "No hay favoritos todavía !!",//No Favourites Yet!!
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                fontWeight: FontWeight.w800,
              ),
            ):GridView.builder(
              shrinkWrap: true,
              primary: false,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1.25),
              ),
              itemCount: favoriteFoods.length == 0 ? 0 :favoriteFoods.length,
              itemBuilder: (BuildContext context, int index) {
                Map food = favoriteFoods[index];
                return GridProduct(
                  food: food,
                  img: food['image'],
                  // isFav: true,
                  name: food['name'],
                  // rating: 5.0,
                  // raters: 23,
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
