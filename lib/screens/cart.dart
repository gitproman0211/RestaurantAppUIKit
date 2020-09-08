import 'package:flutter/material.dart';
import 'package:restaurant_ui_kit/screens/checkout.dart';
import 'package:restaurant_ui_kit/util/foods.dart';
import 'package:restaurant_ui_kit/widgets/cart_item.dart';
import 'package:restaurant_ui_kit/util/foodsInCart.dart';

class CartScreen extends StatefulWidget {
  // final Map foodItem;
  final List<FoodInCart> cart;

  CartScreen({Key key, @required this.cart}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with AutomaticKeepAliveClientMixin<CartScreen> {
  List<FoodInCart> myList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myList=widget.cart;
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
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
              child: ListView.builder(
                itemCount: widget.cart == null ? 0 : widget.cart.length,
                itemBuilder: (BuildContext context, int index) {
                  FoodInCart F = widget.cart[index];
                  Map food = F.food;
                  return CartItem(
                    F: F,
                    foodItem: food,
                    cart: widget.cart,
                    img: food['image'],
                    isFav: false,
                    name: food['name'],
                    price: food['price'].toString(),
                    updateState: updateState,
                  );
                },
              ),
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
                    return Checkout();
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
