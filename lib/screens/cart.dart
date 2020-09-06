import 'package:flutter/material.dart';
import 'package:restaurant_ui_kit/screens/checkout.dart';
import 'package:restaurant_ui_kit/util/foods.dart';
import 'package:restaurant_ui_kit/widgets/cart_item.dart';


class CartScreen extends StatefulWidget {
  final Map foodItem;
  final List<Map> cart;
  CartScreen({Key key, @required this.foodItem,@required this.cart}) : super(key: key);
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with AutomaticKeepAliveClientMixin<CartScreen >{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0,0,10.0,0),
        child: ListView.builder(
          itemCount: widget.cart == null ? 0 :widget.cart.length,
          itemBuilder: (BuildContext context, int index) {
            Map food = widget.cart[index];
            return CartItem(
              foodItem:food,
              cart:widget.cart,
              img: food['image'],
              isFav: false,
              name: food['name'],
              rating: 5.0,
              raters: 23,
              price:food['price'].toString()
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        tooltip: "Checkout",
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context){
                return Checkout();
              },
            ),
          );
        },
        child: Icon(
          Icons.arrow_forward,
        ),
        heroTag: Object(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
