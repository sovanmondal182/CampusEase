class Food {
  String? itemName;
  int? totalQty;
  int? price;
  String? id;

  Food(this.id, this.itemName, this.totalQty, this.price);

  Food.fromMap(Map<String, dynamic> data) {
    itemName = data['item_name'];
    totalQty = data['total_qty'];
    price = data['price'];
    id = data['item_id'];
  }

  Map<String, dynamic> toMapForCart() {
    return {
      'item_name': itemName,
      'total_qty': totalQty,
      'price': price,
      'item_id': id,
    };
  }
}
