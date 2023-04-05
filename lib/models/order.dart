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
  String? deliveryAt;
  String? placedBy;
  double? totalAmount;
  List<OrderItem>? items;
  String? paymentId;
  String? userName;

  Order(this.items, this.totalAmount, this.paymentId, this.placedAt,
      this.deliveryAt, this.placedBy, this.isDelivered, this.userName);

  Order.fromMap(Map<String, dynamic> map) {
    isDelivered = map['is_delivered'];
    placedAt = map['placed_at'];
    deliveryAt = map['delivery_at'];
    placedBy = map['placed_by'];
    totalAmount = map['total'];
    items = List<OrderItem>.from(
        map['items'].map((e) => OrderItem.fromMap(e)).toList());
    paymentId = map['payment_id'];
    userName = map['user_name'];
  }

  Map<String, dynamic> toMap() {
    return {
      'is_delivered': isDelivered,
      'placed_at': placedAt,
      'delivery_at': deliveryAt,
      'placed_by': placedBy,
      'total': totalAmount,
      'items': items?.map((e) => e.toMap()).toList(),
      'payment_id': paymentId,
      'user_name': userName,
    };
  }
}
