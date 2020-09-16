import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_ui_kit/screens/cart.dart';
import 'package:restaurant_ui_kit/screens/notifications.dart';
import 'package:restaurant_ui_kit/util/cartModel.dart';
import 'package:restaurant_ui_kit/util/foodsInCart.dart';
import 'package:restaurant_ui_kit/widgets/badge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RedeemMenuScreen extends StatefulWidget {
  final CartModel cartModel;
  final Function updateState;
  RedeemMenuScreen({
    Key key,
    @required this.cartModel,
    @required this.updateState
  }) : super(key: key);

  @override
  _RedeemMenuScreenState createState() => _RedeemMenuScreenState();
}

class _RedeemMenuScreenState extends State<RedeemMenuScreen> {
  List<Map> redeemFoods = [];
  bool isLoading = true;
  bool isFav = false;
  int points=0;
  int _page = 0;

  void initState() {
    // TODO: implement initState
    super.initState();
    getRedeemMenu();
    points=widget.cartModel.points;
  }

  getRedeemMenu() {
    final firestoreInstance = FirebaseFirestore.instance;
    firestoreInstance.collection("redeemMenu").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data());
        redeemFoods.add(result.data());
      });
      print(redeemFoods);
      isLoading = false;
      setState(() {});
    });
  }
  decreasePoints(points){
  widget.cartModel.decreasePoints(points);
  widget.updateState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Points Available To Redeem "+widget.cartModel.points.toString(),
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
      body: ListView.builder(
        itemCount: redeemFoods.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(10.0),
                decoration:BoxDecoration(
                  border: Border.all(
                    color: Colors.red, //                   <--- border color
                    width: 5.0,
                  ),
                ),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height / 3.2,
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            redeemFoods[index]['image'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    redeemFoods[index]["name"],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 2,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Points:  "+redeemFoods[index]["points"].toString(),
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).accentColor,
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Product Description",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 2,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    redeemFoods[index]["description"],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Container(
                    height: 50.0,
                    child: Consumer<CartModel>(
                      builder:(context,cartModel,child){
                        return RaisedButton(
                          child: Text(
                            "ADD TO CART",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          color: Theme.of(context).accentColor,
                          onPressed: (){
                            if(cartModel.cart.contains(FoodInCart(redeemFoods[index]))){
                              Fluttertoast.showToast(msg: "Item Already Present In Cart");
                              //points will not decrease
                            }
                            else{

                              cartModel.addToCart(FoodInCart(redeemFoods[index]));
                              Fluttertoast.showToast(msg: "Item Added To Cart");
                              //points will decrease
                              decreasePoints(redeemFoods[index]["points"]);
                            }
                            setState(() {

                            });
                            },
                        );
                      },

                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
