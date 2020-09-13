import 'package:flutter/material.dart';
import 'package:restaurant_ui_kit/screens/details.dart';
import 'package:restaurant_ui_kit/util/const.dart';
import 'package:restaurant_ui_kit/util/foodsInCart.dart';
import 'package:restaurant_ui_kit/widgets/smooth_star_rating.dart';

class GridProduct extends StatelessWidget {
  final Map food;
  final String name;
  final String img;
  final bool isFav;
  final double rating;
  final int raters;
  // final List<FoodInCart> cart;


  GridProduct({
    Key key,
    @required this.food,
    @required this.name,
    @required this.img,
    @required this.isFav,
    @required this.rating,
    @required this.raters,
    })
      :super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListView(
        shrinkWrap: true,
        primary: false,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 3.6,
                width: MediaQuery.of(context).size.width / 2.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    "$img",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 2.0, top: 8.0),
            child: Text(
              "$name",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w900,
              ),
              maxLines: 2,
            ),
          ),
        ],
      ),
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context){
              return ProductDetails(foodItem: food);
            },
          ),
        );
      },
    );
  }
}
