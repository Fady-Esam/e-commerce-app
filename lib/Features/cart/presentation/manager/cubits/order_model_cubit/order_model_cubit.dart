import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/order_model.dart';
import 'order_model_state.dart';

class OrderModelCubit extends Cubit<OrderModelState> {
  OrderModelCubit() : super(OrderModelInitial());
  var orders = FirebaseFirestore.instance.collection('orders');
  Future<void> sendOrders({
    required String orderId,
    required String userId,
    required String productId,
    required String productTitle,
    required String userName,
    required String price,
    required String imageUrl,
    required String quantity,
    required Timestamp orderDate,
  }) async {
    await orders.doc(orderId).set({
      'orderId': orderId,
      'userId': userId,
      'productId': productId,
      'productTitle': productTitle,
      'userName': userName,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'orderDate': orderDate,
    });
  }

  List<dynamic> ordersList = [];
  void fetchOrders({required String userId}) {
    orders.snapshots().listen((event) {
      ordersList.clear();
      for (var e in event.docs) {
        if (e['userId'] == userId) {
          ordersList.add(OrderModel.fromJson(e.data()));
        }
      }
      emit(OrderModelFetchOrdersForUser());
    });
  }

  List<dynamic> allOrders = [];

  void fetchAllOrders() {
    orders.snapshots().listen((event) {
      allOrders.clear();
      for (var e in event.docs) {
        allOrders.add(OrderModel.fromJson(e.data()));
      }
      emit(OrderModelFetchAllOrders());
    });
  }

  Future<void> deleteOrder({required String orderId}) async {
    await orders.doc(orderId).delete();
    emit(OrderModelDeleteOrder());
  }

  Future<void> clearUserOrders() async {
    emit(OrderModelLoadingClearOrdersForUser());
    try {
      var query = await orders.get();
      for (int i = 0; i < query.docs.length; i++) {
        if (query.docs[i]['userId'] == FirebaseAuth.instance.currentUser!.uid) {
          await orders.doc(query.docs[i]['orderId']).delete();
        }
      }
      emit(OrderModelSuccessClearOrdersForUser());
    } on Exception {
      emit(OrderModelFailureClearOrdersForUser());
    }
  }

  Future<void> clearAllOrders() async {
    emit(OrderModelLoadingClearAllOrders());
    try {
      var query = await orders.get();
      for (int i = 0; i < query.docs.length; i++) {
        await orders.doc(query.docs[i]['orderId']).delete();
      }
      emit(OrderModelSuccessClearAllOrders());
    } on Exception {
      emit(OrderModelFailureClearAllOrders());
    }
  }
}
