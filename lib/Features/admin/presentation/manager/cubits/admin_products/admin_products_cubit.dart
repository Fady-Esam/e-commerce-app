import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'admin_products_state.dart';

class AdminProductsCubit extends Cubit<AdminProductsState> {
  AdminProductsCubit() : super(AdminProductsInitialState());

  var adminProducts = FirebaseFirestore.instance.collection('adminProducts');
  Future<void> uploadAdminProducts({
    required String productId,
    required String productTitle,
    required String productPrice,
    required String productCategory,
    required String productDescription,
    required String productImage,
    required String productQuantity,
    required Timestamp createdAt,
  }) async {
    emit(LoadingUploadAdminProductsState());
    try {
      await adminProducts.doc(productId).set({
        'productId': productId,
        'productTitle': productTitle,
        'productPrice': productPrice,
        'productCategory': productCategory,
        'productDescription': productDescription,
        'productImage': productImage,
        'productQuantity': productQuantity,
        'createdAt': createdAt,
      });
      emit(SuccessUploadAdminProductsState());
    } on Exception  {
      emit(FailureUploadAdminProductsState());
    } 
  }

  Future<void> editAdminProducts({
    required String productId,
    required String productTitle,
    required String productPrice,
    required String productCategory,
    required String productDescription,
    required String productImage,
    required String productQuantity,
  }) async {
    emit(LoadingEditAdminProductsState());
    try {
      await adminProducts.doc(productId).update({
        'productId': productId,
        'productTitle': productTitle,
        'productPrice': productPrice,
        'productCategory': productCategory,
        'productDescription': productDescription,
        'productImage': productImage,
        'productQuantity': productQuantity,
      });
      emit(SuccessEditAdminProductsState());
    } on Exception  {
      emit(FailureEditAdminProductsState());
    } 
  }

  Future<void> deleteProduct({
    required String productId,
  }) async {
    emit(LoadingDeleteAdminProductsState());
    try{
      await adminProducts.doc(productId).delete();
      emit(SuccessDeleteAdminProductsState());
    } catch(e){
      emit(FailureDeleteAdminProductsState());
    }
  }
}
