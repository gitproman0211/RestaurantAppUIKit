import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_ui_kit/screens/details.dart';
import 'package:restaurant_ui_kit/util/const.dart';
import 'package:restaurant_ui_kit/widgets/smooth_star_rating.dart';


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with AutomaticKeepAliveClientMixin<SearchScreen>{
  final TextEditingController editingController = TextEditingController();
  final firestoreInstance = FirebaseFirestore.instance;
  List<Map> foods = [];
  List<Map> items=[];
  // searchMenu(searchText){
  //   for(var i=0;i<foods.length;i++){
  //     var foodItemName=foods[i]["name"];
  //     if(foodItemName.)
  //   }
  // }
  getMenu() {
    firestoreInstance.collection("menu").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data());
        foods.add(result.data());
      }
      );
      setState(() {});
    }
    );
    // firestoreInstance.collection("redeemMenu").get().then((querySnapshot) {
    //   querySnapshot.docs.forEach((result) {
    //     print(result.data());
    //     foods.add(result.data());
    //   });
    //   // print(redeemFoods);
    //   // isLoading = false;
    //   setState(() {});
    // });
    print("Menu fetched");
  }
  void filterSearchResults(String query) {
    List<Map> dummySearchList = [];
    dummySearchList.addAll(foods);
    if(query.isNotEmpty) {
      List<Map> dummyListData = [];
      dummySearchList.forEach((item) {
        var itemName=item["name"];
        if(itemName.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(foods);
      });
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMenu();
    items.addAll(foods);
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(10.0,0,10.0,0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResults(value);
              },
              controller: editingController,
              decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage('${items[index]["image"]}')),
                    title: Text('${items[index]["name"]}'),
                    trailing:Text('\$'+'${items[index]["price"]}'),
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context){
                              return ProductDetails(foodItem: items[index]);
                            },
                          ),
                        );
                      }
                  ),
                );
              },
            ),
          ),
        ],
      )
    );
  }

  @override
  bool get wantKeepAlive => true;
}
// SizedBox(height: 10.0),
//
// Card(
// elevation: 6.0,
// child: Container(
// decoration: BoxDecoration(
// color: Colors.white,
// borderRadius: BorderRadius.all(
// Radius.circular(5.0),
// ),
// ),
// child: TextField(
// style: TextStyle(
// fontSize: 15.0,
// color: Colors.black,
// ),
// decoration: InputDecoration(
// contentPadding: EdgeInsets.all(10.0),
// border: OutlineInputBorder(
// borderRadius: BorderRadius.circular(5.0),
// borderSide: BorderSide(color: Colors.white),
// ),
// enabledBorder: OutlineInputBorder(
// borderSide: BorderSide(color: Colors.white),
// borderRadius: BorderRadius.circular(5.0),
// ),
// hintText: "Search..",
// suffixIcon: IconButton(
// icon: Icon(
// Icons.search,
// size: 24.0,
// ),
// onPressed: (){},
// ),
// hintStyle: TextStyle(
// fontSize: 15.0,
// color: Colors.black,
// ),
// ),
// maxLines: 1,
// controller: _searchControl,
// ),
// ),
// ),
// SizedBox(height: 10.0),
// ListView.builder(
// shrinkWrap: true,
// primary: false,
// physics: NeverScrollableScrollPhysics(),
// itemCount: foods == null ? 0 :foods.length,
// itemBuilder: (BuildContext context, int index) {
// Map food = foods[index];
// return ListTile(
// title: Text(
// "${food['name']}",
// style: TextStyle(
// //                    fontSize: 15,
// fontWeight: FontWeight.w900,
// ),
// ),
// leading: CircleAvatar(
// radius: 25.0,
// backgroundImage: AssetImage(
// "${food['img']}",
// ),
// ),
// trailing: Text(r"$10"),
// subtitle:  Row(
// children: <Widget>[
// SmoothStarRating(
// starCount: 1,
// color: Constants.ratingBG,
// allowHalfRating: true,
// rating: 5.0,
// size: 12.0,
// ),
// ],
// ),
// onTap: (){},
// );
// },
// ),
//
// SizedBox(height: 30),