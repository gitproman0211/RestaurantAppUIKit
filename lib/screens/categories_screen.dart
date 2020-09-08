import 'package:flutter/material.dart';
import 'package:restaurant_ui_kit/screens/notifications.dart';
import 'package:restaurant_ui_kit/util/categories.dart';
import 'package:restaurant_ui_kit/util/foods.dart';
import 'package:restaurant_ui_kit/util/foodsInCart.dart';
import 'package:restaurant_ui_kit/widgets/badge.dart';
import 'package:restaurant_ui_kit/widgets/grid_product.dart';
import 'package:restaurant_ui_kit/widgets/home_category.dart';

class CategoriesScreen extends StatefulWidget {
  final String title;
  final String items;
  final List<Map> foods;
  final List categories;
  final List<FoodInCart> cart;
  CategoriesScreen({
    Key key,
    @required this.title,
    @required this.items,
    @required this.foods,
    @required  this.categories,
    @required this.cart,
})
      : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var cateogoryItems=[];
  PageController _pageController;
  int _page = 0;
  int getNumberOfItems(String category,List<Map>foods){
    int count=0;
    for(var i=0;i<foods.length;i++){
      if(foods[i]["category"]==category){
        count++;
      }
    }
print("count=");
    print(count);
    return count;
  }
  getCategoryItems(String category,List<Map>foods){
    var categoryItems=[];
    for(var i=0;i<foods.length;i++){
      if(foods[i]["category"]==category){
        categoryItems.add(foods[i]);
      }
    }
    return categoryItems;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cateogoryItems=getCategoryItems(widget.title,widget.foods);
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
          onPressed: ()=>Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Categories",
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: IconBadge(
              icon: Icons.shopping_cart,
              size: 24.0,
            ),
            color: _page == 3
                ? Theme.of(context).accentColor
                : Theme
                .of(context)
                .textTheme.caption.color,
            onPressed: ()=>_pageController.jumpToPage(3),
          ),
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
            Container(
              height: 65.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: widget.categories == null?0:widget.categories.length,
                itemBuilder: (BuildContext context, int index) {
//                  Map cat = categories[index];
                  return HomeCategory(
                    cart:widget.cart,
                    foods:widget.foods,
                    title: widget.categories[index],
                    categories:widget.categories,
                    items: getNumberOfItems(widget.categories[index],widget.foods).toString(),
                    isHome: true,
                  );
                },
              ),
            ),

            SizedBox(height: 20.0),

            Text(
              widget.title,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            Divider(),
            SizedBox(height: 10.0),

            GridView.builder(
              shrinkWrap: true,
              primary: false,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1.25),
              ),
              itemCount: getNumberOfItems(widget.title,widget.foods),
              itemBuilder: (BuildContext context, int index) {
                Map food = cateogoryItems[index];
                return GridProduct(
                  food: food,
                  img: food['image'],
                  isFav: false,
                  name: food['name'],
                  rating: 5.0,
                  raters: 23,
                  cart: widget.cart,
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}
