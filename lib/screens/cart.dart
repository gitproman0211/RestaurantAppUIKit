import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_ui_kit/screens/checkout.dart';
import 'package:restaurant_ui_kit/screens/redeemDishes.dart';
import 'package:restaurant_ui_kit/util/cartModel.dart';
import 'package:restaurant_ui_kit/util/foods.dart';
import 'package:restaurant_ui_kit/widgets/cart_item.dart';
import 'package:restaurant_ui_kit/util/foodsInCart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartScreen extends StatefulWidget {
  // final Map foodItem;
  final CartModel cartModel;

  CartScreen({Key key, @required this.cartModel}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with AutomaticKeepAliveClientMixin<CartScreen> {
  List<FoodInCart> myList = [];
   int points=0;
  bool redeemPointsButton=true;
  final firestoreInstance = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myList=widget.cartModel.cart;
     getPoints();
  }
  getPoints(){

    User user = FirebaseAuth.instance.currentUser;
    firestoreInstance.collection("users").doc(user.uid).get().then((value){
      print("Points=");
      print(value.data()["points"]);
      points=value.data()["points"];
      widget.cartModel.updatePoints(points);
      if(points<5){
        redeemPointsButton=false;
      }
      setState(() {

      });
    });

  }
  calculateTotal() {
    int total = 0;
    print("length of list");
    print(myList.length);
    for (int i = 0; i < myList.length; i++) {
      total += myList[i].quantity * myList[i].food["price"];
    }
    return total;
  }

  updateState() {
    // getPoints();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
              child: Consumer<CartModel>(
                builder:(context,cartModel,child){
                  return ListView.builder(
                    itemCount: cartModel.cart == null ? 0 : cartModel.cart.length,
                    itemBuilder: (BuildContext context, int index) {
                      FoodInCart F = cartModel.cart[index];
                      Map food = F.food;
                      return CartItem(
                        F: F,
                        foodItem: food,
                        cart: cartModel,
                        img: food['image'],
                        isFav: false,
                        name: food['name'],
                        price: food['price'].toString(),
                        updateState: updateState,

                      );
                    },
                  );
                }
                ),
            ),
          ),
          RaisedButton(
            onPressed: () {},
            textColor: Colors.white,
            color: Colors.red,
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              "Points= ${widget.cartModel.points}",
            ),
          ),
          RaisedButton(
            onPressed: () {
              if(redeemPointsButton){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return RedeemMenuScreen(cartModel: widget.cartModel);
                    },
                  ),
                );
              }
              },
            textColor: Colors.white,
            color: redeemPointsButton?Colors.red:Colors.grey,
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              "REDEEM POINTS",
            ),
          ),
          RaisedButton(
            onPressed: () {},
            textColor: Colors.white,
            color: Colors.red,
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              "GRAND TOTAL= \$ ${calculateTotal()}",
            ),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return Checkout(cartModel: widget.cartModel,total:calculateTotal(),myList: myList);
                  },
                ),
              );
            },
            textColor: Colors.white,
            color: Colors.red,
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              "CHECKOUT",
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
