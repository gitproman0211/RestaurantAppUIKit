class FoodInCart {
  Map food;
  int quantity;

  FoodInCart(foodItem, {quantity = 1}) {
    this.food = foodItem;
    this.quantity = quantity;
  }

  increaseQuantity() {
    print("increasing quantity");
    print("Old quantity=");
    print(this.quantity);
    this.quantity = this.quantity + 1;
    print("New quantity=");
    print(this.quantity);
  }

  decreaseQuantity() {
    print("decreasing quantity");
    print("Old quantity=");
    print(this.quantity);
    this.quantity = this.quantity - 1;
    print("New quantity=");
    print(this.quantity);
  }
  @override
  int get hashCode => food["name"].hashCode;

  @override
  bool operator ==(other) {
    // TODO: implement ==
    return food["name"] == other.food["name"];
  }
}
