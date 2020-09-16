import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_ui_kit/screens/checkout.dart';
import 'package:restaurant_ui_kit/screens/redeemDishes.dart';
import 'package:restaurant_ui_kit/util/cartModel.dart';
import 'package:restaurant_ui_kit/widgets/badge.dart';
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
  final ScrollController _scrollController=ScrollController();
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
          ),
          onPressed: ()=>Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "CART",
        ),
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          Text(
            "Number Of Items= ${myList.length}",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
              fontWeight: FontWeight.w800,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
              child: Consumer<CartModel>(
                builder:(context,cartModel,child){
                  return Scrollbar(
                    isAlwaysShown: true,
                    controller: _scrollController,
                    child: ListView.builder(
                      controller: _scrollController,
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
                    ),
                  );
                }
                ),
            ),
          ),
          Text(
            "GRAND TOTAL= \$ ${calculateTotal()}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            "Points Available To Redeem = ${widget.cartModel.points}",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w300,
            ),
          ),
          RaisedButton(
            onPressed: () {
              if(redeemPointsButton){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return RedeemMenuScreen(cartModel: widget.cartModel,updateState: updateState);
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
