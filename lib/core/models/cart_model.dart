
class CartModel {
  final String cartId, productId;
  String quantity;


  CartModel({
    required this.cartId,
    required this.productId,
    required this.quantity,
  });

  factory CartModel.fromJson(Map<String, dynamic> data) {
    return CartModel(
      cartId: data['cartId'],
      productId: data['productId'],
      quantity: data['quantity'],
    );
  }
}
