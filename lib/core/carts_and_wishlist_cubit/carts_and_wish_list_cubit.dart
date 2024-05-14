import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../cubits/product_model_cubit/product_model_cubit.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import 'carts_and_wish_list_state.dart';

class CartsAndWishListCubit extends Cubit<CartsAndWishListState> {
  CartsAndWishListCubit() : super(CartsAndWishListInitial());

  var users = FirebaseFirestore.instance.collection('users');

  double total = 0;

  Future<void> addToCart({
    required String productId,
    required String quantity,
  }) async {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }
    try {
      await users.doc(FirebaseAuth.instance.currentUser!.uid).update({
        'userCart': FieldValue.arrayUnion([
          {
            'productId': productId,
            'cartId': const Uuid().v4(),
            'quantity': quantity,
          },
        ]),
      });
      emit(CartModelSuccessAddedToCart());
    } on Exception {
      emit(CartModelFailureAddedToCart());
    }
  }

  List<dynamic> carts = [];
  void fetchCarts() {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }
    try {
      users
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots()
          .listen((event) {
        carts.clear();
        for (var e in event['userCart']) {
          carts.add(CartModel.fromJson(e));
        }
        emit(CartModelSuccessFetchCarts());
      });
    } on FirebaseException catch (e) {
      emit(CartModelFailureFetchCarts(errMessage: e.code));
    } on Exception catch (e) {
      emit(CartModelFailureFetchCarts(errMessage: e.toString()));
    }
  }

  bool isProductInCart({required String productId}) {
    for (int i = 0; i < carts.length; i++) {
      if (carts[i].productId == productId) {
        return true;
      }
    }
    return false;
  }

//* Total And Quantity

  Future<void> updateQuantity(
      {required String productId, required String quantity}) async {
    var doc = await users.doc(FirebaseAuth.instance.currentUser!.uid).get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<dynamic> userCartsList = data['userCart'] as List<dynamic>;
    for (int i = 0; i < userCartsList.length; i++) {
      if (userCartsList[i]['productId'] == productId) {
        userCartsList[i]['quantity'] = quantity;
        await users
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'userCart': userCartsList});
        emit(CartModelSuccessUpdateQuantity());
        break;
      }
    }
  }

  void getTotal({required BuildContext context}) async {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }
    var doc = await users.doc(FirebaseAuth.instance.currentUser!.uid).get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    total = 0;
    for (int i = 0; i < data['userCart'].length; i++) {
      double mult = double.parse((BlocProvider.of<ProductModelCubit>(context)
              .getCurrentProductById(
                  productId: data['userCart'][i]['productId'])!
              .productPrice)) *
          double.parse(data['userCart'][i]['quantity']);
      total += mult;
    }
    emit(CartModelSuccessGetTotal());
  }

//* Total And Quantity

  Future<void> removeOneItem(
      {required String productId,
      required String cartId,
      required String quantity}) async {
    await users.doc(FirebaseAuth.instance.currentUser!.uid).update({
      'userCart': FieldValue.arrayRemove(
        [
          {
            'productId': productId,
            'cartId': cartId,
            'quantity': quantity,
          },
        ],
      ),
    });
    emit(CartModelSuccessRemoveOneItem());
  }

  Future<void> clearCart() async {
    await users.doc(FirebaseAuth.instance.currentUser!.uid).update(
      {
        'userCart': [],
      },
    );
    emit(CartModelSuccessRemovedAllItems());
  }


  //!======================================================================================================================

  Future<void> addToWishList({required ProductModel productModel}) async {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }
    try {
      await users.doc(FirebaseAuth.instance.currentUser!.uid).update({
        'userWish': FieldValue.arrayUnion([
          {
            'productId': productModel.productId,
            'productTitle': productModel.productTitle,
            'productPrice': productModel.productPrice,
            'productCategory': productModel.productCategory,
            'productDescription': productModel.productDescription,
            'productImage': productModel.productImage,
            'productQuantity': productModel.productQuantity,
            'createdAt': productModel.createdAt,
          },
        ]),
      });
      emit(WishListCubitSuccessAdded());
    } on Exception {
      emit(WishListCubitFailedAdded());
    }
  }

  Future<void> removeFromWishList({required ProductModel productModel}) async {
    await users.doc(FirebaseAuth.instance.currentUser!.uid).update({
      'userWish': FieldValue.arrayRemove([
        {
          'productId': productModel.productId,
          'productTitle': productModel.productTitle,
          'productPrice': productModel.productPrice,
          'productCategory': productModel.productCategory,
          'productDescription': productModel.productDescription,
          'productImage': productModel.productImage,
          'productQuantity': productModel.productQuantity,
          'createdAt': productModel.createdAt,
        },
      ]),
    });
    emit(WishListCubitRemoveOneItem());
  }

  List<dynamic> wishListProducts = [];

  void fetchWishList() {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }
    try {
      users
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots()
          .listen((event) {
        wishListProducts.clear();
        for (var e in event['userWish']) {
          wishListProducts.add(ProductModel.fromJsonForWishList(e));
        }
        emit(WishListCubitFetchSuccess());
      });
    } on FirebaseAuthException catch (e) {
      WishListCubitFetchFailure(errMessage: e.code);
    } on Exception catch (e) {
      WishListCubitFetchFailure(errMessage: e.toString());
    }
  }

  bool isInWishList({required String productId}) {
    for (int i = 0; i < wishListProducts.length; i++) {
      if (wishListProducts[i].productId == productId) {
        return true;
      }
    }
    return false;
  }

  Future<void> clearWishList() async {
    await users.doc(FirebaseAuth.instance.currentUser!.uid).update({
      'userWish': [],
    });
    emit(WishListCubitclear());
  }
  
}
