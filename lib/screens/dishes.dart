import 'package:flutter/material.dart';
import 'package:restaurant_ui_kit/screens/notifications.dart';
import 'package:restaurant_ui_kit/util/foods.dart';
import 'package:restaurant_ui_kit/widgets/badge.dart';
import 'package:restaurant_ui_kit/widgets/grid_product.dart';

class DishesScreen extends StatefulWidget {
  final List<Map> foods;

  DishesScreen({Key key, @required this.foods}) : super(key: key);

  @override
  _DishesScreenState createState() => _DishesScreenState();
}



class _DishesScreenState extends State<DishesScreen> {
  List<String> categories = [];

  void initState() {
    // TODO: implement initState
    super.initState();
    categories = getCategories(widget.foods);
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
    print(categories);
    return categories;
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
          "Dishes",
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: IconBadge(
              icon: Icons.notifications,
              size: 22.0,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return Notifications();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          children: generateFoodItems(),
        ),
      ),
    );
  }

  List<Widget> generateFoodItems() {
    List<String> categories = getCategories(widget.foods);
    List<Widget> children = [];
    for (int i = 0; i < categories.length; i++) {
      children.add(Text(
        categories[i],
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
        maxLines: 2,
      ));
      children.add(Divider());
      List temp = widget.foods
          .where((food) => food["category"] == categories[i])
          .toList();
      children.add(
        GridView.builder(
          shrinkWrap: true,
          primary: false,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 1.25),
          ),
          itemCount: temp.length,
          itemBuilder: (BuildContext context, int index) {
            Map food = temp[index];
            print(food);
            return GridProduct(
              img: food['image'],
              isFav: false,
              name: food['name'],
              rating: 5.0,
              raters: 23,
            );
          },
        ),
      );
    }
    return children;
  }
}
