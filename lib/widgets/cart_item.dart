import 'package:flutter/material.dart';
import 'package:restaurant_ui_kit/screens/details.dart';
import 'package:restaurant_ui_kit/util/cartModel.dart';
import 'package:restaurant_ui_kit/util/const.dart';
import 'package:restaurant_ui_kit/widgets/smooth_star_rating.dart';
import 'package:restaurant_ui_kit/widgets/badge.dart';
import 'package:restaurant_ui_kit/util/foodsInCart.dart';
import 'dart:convert';

class CartItem extends StatefulWidget {
  final FoodInCart F;
  final String name;
  final String img;
  final bool isFav;
  final String price;
  final Map foodItem;
  final CartModel cart;
  final Function updateState;
  CartItem({
    Key key,
    @required this.F,
    @required this.name,
    @required this.img,
    @required this.isFav,
    @required this.price,
    @required this.foodItem,
    @required this.cart,
     @required this.updateState})
      :super(key: key);
  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
      child: InkWell(
        onTap: (){
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context){
                return ProductDetails(foodItem: widget.foodItem,cart: widget.cart.cart,);
              },
            ),
          );
        },
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 0.0, right: 10.0),
              child: Container(
                height: MediaQuery.of(context).size.width/3.5,
                width: MediaQuery.of(context).size.width/3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    widget.img,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  widget.name,
                  style: TextStyle(
//                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 10.0),
                Row(
                  children: <Widget>[
                    SmoothStarRating(
                      starCount: 1,
                      color: Constants.ratingBG,
                      allowHalfRating: true,
                      rating: 5.0,
                      size: 12.0,
                    ),
                    SizedBox(width: 6.0),
                    Text(
                      "5.0 (23 Reviews)",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  children: <Widget>[
                    Text(
                      "Price : \$",
                      style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      "${widget.foodItem["price"]*widget.F.quantity}",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).accentColor,
                      ),
                    ),

                  ],
                ),

                Row(
                  children: <Widget>[
                    Text(
                      "Quantity: ",
                      style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        if(widget.F.quantity!=1){
                          widget.cart.decrementQuantity(widget.F);
                        }

                        setState(() {

                        });
                        widget.updateState();
                      },
                    ),
                    Text(
                      "${widget.F.quantity}",
                      style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        widget.cart.incrementQuantity(widget.F);
                        setState(() {

                        });
                        widget.updateState();
                      },
                    ),
                  ],
                )

              ],
            ),
          ],
        ),
      ),
    );;
  }
}

// class CartItem extends StatelessWidget {
//   final String name;
//   final String img;
//   final bool isFav;
//   final double rating;
//   final int raters;
//   final String price;
//   final Map foodItem;
//   final List<Map> cart;
//   CartItem({
//     Key key,
//     @required this.name,
//     @required this.img,
//     @required this.isFav,
//     @required this.rating,
//     @required this.raters,
//     @required this.price,
//     @required this.foodItem,
//     @required this.cart})
//       :super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
//       child: InkWell(
//         onTap: (){
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (BuildContext context){
//                 return ProductDetails(foodItem: foodItem,cart: cart,);
//               },
//             ),
//           );
//         },
//         child: Row(
//           children: <Widget>[
//             Padding(
//               padding: EdgeInsets.only(left: 0.0, right: 10.0),
//               child: Container(
//                 height: MediaQuery.of(context).size.width/3.5,
//                 width: MediaQuery.of(context).size.width/3,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8.0),
//                   child: Image.network(
//                     "$img",
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Text(
//                   "$name",
//                   style: TextStyle(
// //                    fontSize: 15,
//                     fontWeight: FontWeight.w900,
//                   ),
//                 ),
//                 SizedBox(height: 10.0),
//                 Row(
//                   children: <Widget>[
//                     SmoothStarRating(
//                       starCount: 1,
//                       color: Constants.ratingBG,
//                       allowHalfRating: true,
//                       rating: 5.0,
//                       size: 12.0,
//                     ),
//                     SizedBox(width: 6.0),
//                     Text(
//                       "5.0 (23 Reviews)",
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w300,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10.0),
//                 Row(
//                   children: <Widget>[
//                    Text(
//                       price,
//                       style: TextStyle(
//                         fontSize: 14.0,
//                         fontWeight: FontWeight.w900,
//                         color: Theme.of(context).accentColor,
//                       ),
//                     ),
//
//                   ],
//                 ),
//                 SizedBox(height: 10.0),
//                 Row(
//                   children: <Widget>[
//                     Text(
//                       "Quantity: ",
//                       style: TextStyle(
//                         fontSize: 11.0,
//                         fontWeight: FontWeight.w300,
//                       ),
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.remove),
//                       onPressed: () {
//                         },
//                     ),
//                     Text(
//                       "1",
//                       style: TextStyle(
//                         fontSize: 11.0,
//                         fontWeight: FontWeight.w300,
//                       ),
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.add),
//                       onPressed: () {
//                       },
//                     ),
//                   ],
//                 )
//
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
