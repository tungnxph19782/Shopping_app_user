import 'package:cloud_firestore/cloud_firestore.dart';

class Order_user {
  final String id;
  final String userId;
  final double totalAmount;
  final DateTime createdAt;
  final List<OrderItem> items;

  Order_user({
    required this.id,
    required this.userId,
    required this.totalAmount,
    required this.createdAt,
    required this.items,
  });

  factory Order_user.fromMap(String id, Map<String, dynamic> data) {
    List<OrderItem> orderItems = (data['items'] as List).map((item) {
      return OrderItem.fromMap(item);
    }).toList();

    return Order_user(
      id: id,
      userId: data['userId'],
      totalAmount: data['totalAmount'].toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      items: orderItems,
    );
  }
}

class OrderItem {
  final String productId;
  final double price;
  final int quantity;

  OrderItem({
    required this.productId,
    required this.price,
    required this.quantity,
  });

  factory OrderItem.fromMap(Map<String, dynamic> data) {
    return OrderItem(
      productId: data['productId'],
      price: data['price'].toDouble(),
      quantity: data['quantity'],
    );
  }
}
