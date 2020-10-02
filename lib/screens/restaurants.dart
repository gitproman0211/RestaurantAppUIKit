import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_ui_kit/screens/cart.dart';
import 'package:restaurant_ui_kit/screens/checkout.dart';
import 'package:restaurant_ui_kit/screens/notifications.dart';
import 'package:restaurant_ui_kit/util/cartModel.dart';
import 'package:restaurant_ui_kit/util/foodsInCart.dart';
import 'package:restaurant_ui_kit/widgets/badge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Restaurants extends StatefulWidget {
  final int total;
  final List<FoodInCart> myList;
  final CartModel cartModel;

  Restaurants({Key key, @required this.total,@required this.myList,@required this.cartModel}) : super(key: key);
  @override
  _RestaurantsState createState() => _RestaurantsState();

}

class _RestaurantsState extends State<Restaurants> {
  List<Map> restaurantsList=[];
  List<bool> selected=[];
  int _page=0;
  User user = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
   Map selectedRestaurant=new Map();
  void initState() {
    // TODO: implement initState
    super.initState();
    getRestaurantList();
  }
  getRestaurantList(){
    firestoreInstance.collection("restaurants").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data());
        restaurantsList.add(result.data());
      }
      );
      print("length of restaurant list");
      print(restaurantsList.length);
      for(int i=0;i<restaurantsList.length;i++){
        selected.add(false);
      }
      print(selected.length);
      setState(() {});
    }
    );

  }
  alertDialogRestaurantNotSelected(BuildContext context) {
    // This is the ok button
    Widget ok = FlatButton(
      child: Text("Rever"),//Rever
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
          content: Text("Restaurante no seleccionado"),// Restaurant Not Selected
          actions: [
            ok,
          ],
          elevation: 5,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Lista de restaurantes",// Restaurants List
        ),
        elevation: 0.0,
        actions: <Widget>[
          Consumer<CartModel>(
            builder: (context,cartModel,child){
              return IconButton(
                icon: IconBadge(
                  icon:Icons.shopping_cart,
                  size: 24.0,
                  count: cartModel.quantity,
                ),
                color: _page == 3
                    ? Theme.of(context).accentColor
                    : Theme
                    .of(context)
                    .textTheme.caption.color,
                onPressed: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return CartScreen(cartModel: cartModel);
                        // return DishesScreen(foods: foods,cart: widget.cart,);
                      },
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Card(
            color: Colors.red,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "pulsación larga para seleccionar restaurante",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 2,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: restaurantsList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () {
                    setState(() {
                      for(int i=0;i<selected.length;i++){
                        selected[i]=false;
                      }
                      selected[index]= !selected[index];
                      selectedRestaurant=restaurantsList[index];
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: selected[index]? Colors.red[500] : Colors.white,
                      margin: const EdgeInsets.all(10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              restaurantsList[index]["name"],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                              maxLines: 2,
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              "Dirección de restaurantes",//Restaurant Address
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                              ),
                              maxLines: 2,
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              restaurantsList[index]["address"],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              restaurantsList[index]["phoneNumber"],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(5,5,10,5),
            width: 150.0,
            height: 50.0,
            child: FlatButton(
              color: Theme.of(context).accentColor,
              child: Text(
                "Continuar".toUpperCase(),//Proceed
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: (){
                if(selectedRestaurant.isEmpty){
                  alertDialogRestaurantNotSelected(context);
                }
                else{
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return Checkout(cartModel: widget.cartModel,total:widget.total,myList: widget.myList,selectedRestaurant:selectedRestaurant);
                      },
                    ),
                  );
                }

              },
            ),
          ),
        ],
      ),

    );
  }
}
