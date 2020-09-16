import 'package:flutter/material.dart';
import 'package:restaurant_ui_kit/util/foodsInCart.dart';

class CartModel with ChangeNotifier {
  List<FoodInCart> cart = [];
  int points=0;
  addToCart(FoodInCart foodItem) {
    cart.add(foodItem);
    notifyListeners();
  }
  removeFromCart(FoodInCart foodItem) {
    cart.remove(foodItem);
    notifyListeners();
  }
  updatePoints(value){
    points=value;
    notifyListeners();
  }
  increasePoints(increase){
    points+=increase;
    notifyListeners();
  }
  decreasePoints(decrease){
    points-=decrease;
    notifyListeners();
  }
  int get quantity => cart.length == 0
      ? 0
      : cart
          .map((item) => item.quantity)
          .reduce((val, element) => val + element);

  incrementQuantity(FoodInCart foodItem) {
    var toIncrement = cart.singleWhere(
        (element) => element.food["name"] == foodItem.food["name"]);
    toIncrement.increaseQuantity();
    notifyListeners();
  }

  decrementQuantity(FoodInCart foodItem) {
    var toDecrement = cart.singleWhere(
        (element) => element.food["name"] == foodItem.food["name"]);
    toDecrement.decreaseQuantity();
    if(toDecrement.quantity==0){
      cart.remove(toDecrement);
    }
    notifyListeners();
  }
}
