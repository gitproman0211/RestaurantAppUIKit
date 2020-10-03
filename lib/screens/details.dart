import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_ui_kit/screens/cart.dart';
import 'package:restaurant_ui_kit/screens/notifications.dart';
import 'package:restaurant_ui_kit/util/cartModel.dart';
import 'package:restaurant_ui_kit/util/const.dart';
import 'package:restaurant_ui_kit/util/foodsInCart.dart';
import 'package:restaurant_ui_kit/widgets/badge.dart';
import 'package:restaurant_ui_kit/widgets/smooth_star_rating.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductDetails extends StatefulWidget {
  final Map foodItem;
  ProductDetails({Key key, @required this.foodItem}) : super(key: key);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  // PageController _pageController;
  // int _page = 0;
  // bool isFav = false;
  @override
  Widget build(BuildContext context) {
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
          "detalles del artículo",//Item Details
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
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0,0,10.0,0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 3.2,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      widget.foodItem['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.0),

            Text(
              widget.foodItem["name"],
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
                    "₲ "+widget.foodItem["price"].toString(),
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).accentColor,
                    ),
                  ),

                ],
              ),
            ),


            SizedBox(height: 20.0),

            Text(
              "Descripción del producto",//Product Description
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
            ),

            SizedBox(height: 10.0),

            Text(
              widget.foodItem["description"],
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50.0,
        child: Consumer<CartModel>(
          builder:(context,cartModel,child){
            return RaisedButton(
              child: Text(
                "AÑADIR AL CARRITO",//ADD TO CART
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Theme.of(context).accentColor,
              onPressed: (){
                if(cartModel.cart.contains(FoodInCart(widget.foodItem))){
                  Fluttertoast.showToast(msg: "El artículo ya está presente en el carrito");//Item Already Present In Cart
                }
                else{

                  cartModel.addToCart(FoodInCart(widget.foodItem));
                  Fluttertoast.showToast(msg: "Artículo agregado al carrito");//Item Added To Cart
                }
                setState(() {

                });
              },
            );
          },

        ),
      ),
    );
  }
}
