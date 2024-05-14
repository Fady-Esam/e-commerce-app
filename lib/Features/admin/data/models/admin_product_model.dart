import 'package:cloud_firestore/cloud_firestore.dart';

class AdminProductModel {
  final String productId,
      productTitle,
      productPrice,
      productCategory,
      productDescription,
      productImage,
      productQuantity;
  final Timestamp createdAt;

  AdminProductModel({
    required this.productId,
    required this.productTitle,
    required this.productPrice,
    required this.productCategory,
    required this.productDescription,
    required this.productImage,
    required this.productQuantity,
    required this.createdAt,
  });

}
