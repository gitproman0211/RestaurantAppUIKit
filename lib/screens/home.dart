import 'package:flutter/material.dart';
import 'package:restaurant_ui_kit/screens/details.dart';
import 'package:restaurant_ui_kit/screens/dishes.dart';
import 'package:restaurant_ui_kit/util/cartModel.dart';
import 'package:restaurant_ui_kit/util/foodsInCart.dart';
import 'package:restaurant_ui_kit/widgets/grid_product.dart';
import 'package:restaurant_ui_kit/widgets/home_category.dart';
import 'package:restaurant_ui_kit/widgets/slider_item.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:restaurant_ui_kit/util/categories.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Home extends StatefulWidget {
  // List<FoodInCart> cart;
  Home({
    Key key,
    // @required this.cart,

  })
      : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  final firestoreInstance = FirebaseFirestore.instance;
  List<Map> foods = [];
  int points;
  List<String> categories = [];
  bool isLoading = true;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }
 int getNumberOfItems(String category){
    int count=0;
    for(var i=0;i<foods.length;i++){
      if(foods[i]["category"]==category){
        count++;
      }
    }
    return count;
  }
  getCategories(List<Map<dynamic, dynamic>> foods) {
    List<String> categories = [];
    for (var i = 0; i < foods.length; i++) {
      foods[i].forEach((k, v) {
        if (k == 'category') {
          if (!categories.contains(v)) {
            categories.add(v);
          }
        }
      });
    }
    print("List of Categories:");
    categories.sort();
    print(categories);
    return categories;
  }

  getMenu() {
    firestoreInstance.collection("menu").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data());
        foods.add(result.data());
      }
      );
      categories = getCategories(foods);
      print(foods);
      isLoading = false;
      setState(() {});
    }
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMenu();

  }

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: isLoading
          ? Center(
            child: CircularProgressIndicator(
                backgroundColor: Colors.cyan,
                strokeWidth: 5,
              ),
          )
          : Padding(
              padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
              child: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Dishes",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      FlatButton(
                        child: Text(
                          "View More",
                          style: TextStyle(
//                      fontSize: 22,
//                      fontWeight: FontWeight.w800,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return DishesScreen(foods: foods);
                                // return DishesScreen(foods: foods,cart: widget.cart,);
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  CarouselSlider(
                    height: MediaQuery.of(context).size.height / 2.4,
                    items: map<Widget>(
                      foods,
                      (index, i) {
                        Map food = foods[index];
                        return SliderItem(
                          // cart:widget.cart,
                          food:food,
                          img: food['image'],
                          isFav: false,
                          name: food['name'],

                        );
                      },
                    ).toList(),
                    autoPlay: true,
//                enlargeCenterPage: true,
                    viewportFraction: 1.0,
//              aspectRatio: 2.0,
                    onPageChanged: (index) {
                      setState(() {
                        _current = index;
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    "Food Categories",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    height: 65.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: categories == null ? 0 : categories.length,
                      itemBuilder: (BuildContext context, int index) {
                        return HomeCategory(
                          // cart:widget.cart,
                          foods:foods,
                          title: categories[index],
                          categories:categories,
                          items: getNumberOfItems(categories[index]).toString(),
                          isHome: true,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 40.0),
                  Text(
                    "Popular Items",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: foods.length,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                            leading: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage('${foods[index]["image"]}')),
                            title: Text('${foods[index]["name"]}'),
                            trailing:Text('\$'+'${foods[index]["price"]}'),
                            onTap: (){
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context){
                                    return ProductDetails(foodItem: foods[index]);
                                  },
                                ),
                              );
                            }
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
