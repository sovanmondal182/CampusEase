class OrderItem {
  String? itemName;
  int? price;
  String? id;
  int? count;

  OrderItem(this.id, this.itemName, this.count, this.price);

  OrderItem.fromMap(Map<String, dynamic> map) {
    itemName = map['item_name'];
    price = map['price'];
    id = map['item_id'];
    count = map['count'];
  }

  Map<String, dynamic> toMap() {
    return {
      'item_name': itemName,
      'price': price,
      'item_id': id,
      'count': count,
    };
  }
}

class Order {
  bool? isDelivered;
  String? placedAt;
  String? placedBy;
  double? totalAmount;
  List<OrderItem>? items;
  String? paymentId;

  Order(this.items, this.totalAmount, this.paymentId, this.placedAt,
      this.placedBy, this.isDelivered);

  Order.fromMap(Map<String, dynamic> map) {
    isDelivered = map['is_delivered'];
    placedAt = map['placed_at'];
    placedBy = map['placed_by'];
    totalAmount = map['total'];
    items = List<OrderItem>.from(
        map['items'].map((e) => OrderItem.fromMap(e)).toList());
    paymentId = map['payment_id'];
  }

  Map<String, dynamic> toMap() {
    return {
      'is_delivered': isDelivered,
      'placed_at': placedAt,
      'placed_by': placedBy,
      'total': totalAmount,
      'items': items?.map((e) => e.toMap()).toList(),
      'payment_id': paymentId,
    };
  }
}
