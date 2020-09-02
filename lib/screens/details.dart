import 'package:flutter/material.dart';
import 'package:restaurant_ui_kit/screens/notifications.dart';
import 'package:restaurant_ui_kit/util/comments.dart';
import 'package:restaurant_ui_kit/util/const.dart';
import 'package:restaurant_ui_kit/util/foods.dart';
import 'package:restaurant_ui_kit/widgets/badge.dart';
import 'package:restaurant_ui_kit/widgets/smooth_star_rating.dart';

class ProductDetails extends StatefulWidget {
  final Map foodItem;
  ProductDetails({Key key, @required this.foodItem}) : super(key: key);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool isFav = false;
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
          "Item Details",
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: IconBadge(
              icon: Icons.notifications,
              size: 22.0,
            ),
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context){
                    return Notifications();
                  },
                ),
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

                Positioned(
                  right: -10.0,
                  bottom: 3.0,
                  child: RawMaterialButton(
                    onPressed: (){},
                    fillColor: Colors.white,
                    shape: CircleBorder(),
                    elevation: 4.0,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        isFav
                            ?Icons.favorite
                            :Icons.favorite_border,
                        color: Colors.red,
                        size: 17,
                      ),
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
                  SmoothStarRating(
                    starCount: 5,
                    color: Constants.ratingBG,
                    allowHalfRating: true,
                    rating: 5.0,
                    size: 10.0,
                  ),
                  SizedBox(width: 10.0),

                  Text(
                    "5.0 (23 Reviews)",
                    style: TextStyle(
                      fontSize: 11.0,
                    ),
                  ),

                ],
              ),
            ),


            Padding(
              padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
              child: Row(
                children: <Widget>[
//                  Text(
//                    "20 Pieces",
//                    style: TextStyle(
//                      fontSize: 11.0,
//                      fontWeight: FontWeight.w300,
//                    ),
//                  ),
//                  SizedBox(width: 10.0),

                  Text(
                    "\$ "+widget.foodItem["price"].toString(),
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
              "Product Description",
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

//Reviews Section commented for deciding later
//            SizedBox(height: 20.0),
//
//            Text(
//              "Reviews",
//              style: TextStyle(
//                fontSize: 18,
//                fontWeight: FontWeight.w800,
//              ),
//              maxLines: 2,
//            ),
//            SizedBox(height: 20.0),
//
//            ListView.builder(
//              shrinkWrap: true,
//              primary: false,
//              physics: NeverScrollableScrollPhysics(),
//              itemCount: comments == null?0:comments.length,
//              itemBuilder: (BuildContext context, int index) {
//                Map comment = comments[index];
//                return ListTile(
//                    leading: CircleAvatar(
//                      radius: 25.0,
//                      backgroundImage: AssetImage(
//                        "${comment['img']}",
//                      ),
//                    ),
//
//                    title: Text("${comment['name']}"),
//                    subtitle: Column(
//                      children: <Widget>[
//                        Row(
//                          children: <Widget>[
//                            SmoothStarRating(
//                              starCount: 5,
//                              color: Constants.ratingBG,
//                              allowHalfRating: true,
//                              rating: 5.0,
//                              size: 12.0,
//                            ),
//                            SizedBox(width: 6.0),
//                            Text(
//                              "February 14, 2020",
//                              style: TextStyle(
//                                fontSize: 12,
//                                fontWeight: FontWeight.w300,
//                              ),
//                            ),
//                          ],
//                        ),
//
//                        SizedBox(height: 7.0),
//                        Text(
//                          "${comment["comment"]}",
//                        ),
//                      ],
//                    ),
//                );
//              },
//            ),
//
//            SizedBox(height: 10.0),
          ],
        ),
      ),



      bottomNavigationBar: Container(
        height: 50.0,
        child: RaisedButton(
          child: Text(
            "ADD TO CART",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          color: Theme.of(context).accentColor,
          onPressed: (){},
        ),
      ),
    );
  }
}
