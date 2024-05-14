import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String orderId,
      userId,
      productId,
      productTitle,
      userName,
      price,
      imageUrl,
      quantity;
  final Timestamp orderDate;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.productId,
    required this.productTitle,
    required this.userName,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.orderDate,
  });
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'],
      userId: json['userId'],
      productId: json['productId'],
      productTitle: json['productTitle'],
      userName: json['userName'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      quantity: json['quantity'],
      orderDate: json['orderDate'],
    );
  }
}
