import 'package:flutter/material.dart';
import 'package:restaurant_ui_kit/util/foodsInCart.dart';

class CartModel with ChangeNotifier {
  List<FoodInCart> cart = [];

  addToCart(FoodInCart foodItem) {
    cart.add(foodItem);
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
    notifyListeners();
  }
}
