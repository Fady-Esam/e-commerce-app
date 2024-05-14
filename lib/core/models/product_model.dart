import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String productId,
      productTitle,
      productPrice,
      productCategory,
      productDescription,
      productImage,
      productQuantity;
  final Timestamp createdAt;

  ProductModel({
    required this.productId,
    required this.productTitle,
    required this.productPrice,
    required this.productCategory,
    required this.productDescription,
    required this.productImage,
    required this.productQuantity,
    required this.createdAt,
  });

  factory ProductModel.fromJson(DocumentSnapshot documentSnapshot) {
    Map<String,dynamic> json = documentSnapshot.data() as Map<String,dynamic>;
    return ProductModel(
      productId: json['productId'],
      productTitle: json['productTitle'],
      productPrice: json['productPrice'],
      productCategory: json['productCategory'],
      productDescription: json['productDescription'],
      productImage: json['productImage'],
      productQuantity: json['productQuantity'],
      createdAt: json['createdAt'],
    );
  }

  factory ProductModel.fromJsonForWishList(Map<String,dynamic> json) {
    return ProductModel(
      productId: json['productId'],
      productTitle: json['productTitle'],
      productPrice: json['productPrice'],
      productCategory: json['productCategory'],
      productDescription: json['productDescription'],
      productImage: json['productImage'],
      productQuantity: json['productQuantity'],
      createdAt: json['createdAt'],
    );
  }
}
