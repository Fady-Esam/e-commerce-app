import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewsrtes/Features/admin/presentation/manager/cubits/admin_products/admin_products_cubit.dart';
import 'package:ewsrtes/Features/admin/presentation/manager/cubits/admin_products/admin_products_state.dart';
import 'package:ewsrtes/Features/admin/presentation/views/admin_view.dart';
import 'package:ewsrtes/core/functions/show_snack_bar_fun.dart';
import 'package:ewsrtes/core/functions/show_warning_message_fun.dart';
import 'package:ewsrtes/core/models/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:uuid/uuid.dart';
import 'functions/show_option_dialog.dart';
import 'widgets/custom_all_fields.dart';
import 'widgets/image_container.dart';
import 'widgets/image_picker_widget.dart';

class AddOrEditProduct extends StatefulWidget {
  const AddOrEditProduct(
      {super.key, this.productModel, this.isEditing = false});

  final ProductModel? productModel;
  final bool isEditing;

  @override
  State<AddOrEditProduct> createState() => _AddOrEditProductState();
}

class _AddOrEditProductState extends State<AddOrEditProduct> {
  late TextEditingController titleController;
  late TextEditingController priceController;
  late TextEditingController quantityController;
  late TextEditingController descriptionController;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(
      text: !widget.isEditing ? null : widget.productModel!.productTitle,
    );
    priceController = TextEditingController(
      text: !widget.isEditing ? null : widget.productModel!.productPrice,
    );
    quantityController = TextEditingController(
      text: !widget.isEditing ? null : widget.productModel!.productQuantity,
    );
    descriptionController = TextEditingController(
      text: !widget.isEditing ? null : widget.productModel!.productDescription,
    );
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    priceController.dispose();
    quantityController.dispose();
    descriptionController.dispose();
  }

  String? dropdownButtonItem;
  static List<String> categoriesList = [
    'Phones',
    'Laptops',
    'Electronics',
    'Watches',
    'Clothes',
    'Shoes',
    'Books',
    'Accessories',
  ];
  List<DropdownMenuItem<String>> categoriesDropDownItems =
      List<DropdownMenuItem<String>>.generate(
    categoriesList.length,
    (index) => DropdownMenuItem(
      value: categoriesList[index],
      child: Text(
        categoriesList[index],
      ),
    ),
  );

  final ImagePicker imagePicker = ImagePicker();
  File? pickedImage;
  bool isLoading = false;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? imageInEditing;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminProductsCubit, AdminProductsState>(
      listener: (context, state) {
        if (state is LoadingUploadAdminProductsState ||
            state is LoadingEditAdminProductsState ||
            state is LoadingDeleteAdminProductsState) {
          isLoading = true;
        } else if (state is FailureUploadAdminProductsState ||
            state is FailureEditAdminProductsState) {
          showSnackBarFun(
            context: context,
            text:
                'Failed to ${widget.isEditing ? 'Edit' : 'Upload'} Product, Please try again',
          );
          isLoading = false;
        } else if (state is SuccessUploadAdminProductsState) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          showSnackBarFun(
            context: context,
            text: "Upload Product done Successfully",
          );
          isLoading = false;
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AdminView()),
              (route) => false);
        } else if (state is SuccessEditAdminProductsState) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          showSnackBarFun(
            context: context,
            text: 'Edit Product done Successfully',
          );
          isLoading = false;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AdminView()),
            (route) => false,
          );
        } else if (state is FailureDeleteAdminProductsState) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          showSnackBarFun(
            context: context,
            text: 'Failed to delete Product, Please try again',
          );
          isLoading = false;
        } else if (state is SuccessDeleteAdminProductsState) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          showSnackBarFun(
            context: context,
            text: 'Product deleted successfully',
          );
          isLoading = false;
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AdminView()),
              (route) => false);
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                widget.isEditing ? 'Edit Product' : 'Add a new product',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
              actions: [
                widget.isEditing
                    ? IconButton(
                        onPressed: () async {
                          showOptionDialog(
                            context: context,
                            warningText: 'Are you Sure to delete this product',
                            onYesPress: () {
                              Navigator.pop(context);
                              BlocProvider.of<AdminProductsCubit>(context)
                                  .deleteProduct(
                                productId: widget.productModel!.productId,
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 28,
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      ImageContainer(widget: widget, pickedImage: pickedImage),
                      const SizedBox(height: 8),
                      ImagePickerWidget(
                        isEditing: widget.isEditing,
                        pickedImage: pickedImage,
                        onImagePicked: (XFile pickImage) {
                          pickedImage = File(pickImage.path);
                          setState(() {});
                        },
                        onRemoveImage: () {
                          pickedImage = null;
                          setState(() {});
                        },
                      ),
                      DropdownButton(
                        hint: Text(
                          !widget.isEditing
                              ? 'Select Category'
                              : widget.productModel!.productCategory,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        value: dropdownButtonItem,
                        items: categoriesDropDownItems,
                        onChanged: (value) {
                          dropdownButtonItem = value as String;
                          setState(() {});
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomAllFields(
                        titleControlleronChanged: (value) {
                          titleController.text = value;
                          setState(() {});
                        },
                        priceControlleronChanged: (value) {
                          priceController.text = value;
                          setState(() {});
                        },
                        quantityControlleronChanged: (value) {
                          quantityController.text = value;
                          setState(() {});
                        },
                        descriptionControlleronChanged: (value) {
                          descriptionController.text = value;
                          setState(() {});
                        },
                        titleController: titleController,
                        priceController: priceController,
                        quantityController: quantityController,
                        descriptionController: descriptionController,
                        autovalidateMode: autovalidateMode,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: (widget.isEditing &&
                                (titleController.text !=
                                        widget.productModel!.productTitle ||
                                    priceController.text !=
                                        widget.productModel!.productPrice ||
                                    quantityController.text !=
                                        widget.productModel!.productQuantity ||
                                    descriptionController.text !=
                                        widget
                                            .productModel!.productDescription ||
                                    dropdownButtonItem != null ||
                                    pickedImage != null))
                            ? MainAxisAlignment.spaceEvenly
                            : MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                            ),
                            onPressed: () async {
                              await showOptionDialog(
                                context: context,
                                warningText: 'Are you Sure to Clear?',
                                onYesPress: () {
                                  Navigator.pop(context);
                                  titleController.clear();
                                  priceController.clear();
                                  quantityController.clear();
                                  descriptionController.clear();
                                  pickedImage = null;
                                  dropdownButtonItem = null;
                                  setState(() {});
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.clear,
                            ),
                            label: const Text(
                              'Clear',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 22),
                          if ((widget.isEditing &&
                                  (titleController.text !=
                                          widget.productModel!.productTitle ||
                                      priceController.text !=
                                          widget.productModel!.productPrice ||
                                      quantityController.text !=
                                          widget
                                              .productModel!.productQuantity ||
                                      descriptionController.text !=
                                          widget.productModel!
                                              .productDescription ||
                                      dropdownButtonItem != null ||
                                      pickedImage != null)) ||
                              !widget.isEditing)
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                              ),
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  if (dropdownButtonItem == null &&
                                      !widget.isEditing) {
                                    await showWarningMessageFun(
                                      context: context,
                                      text: 'Please select a category',
                                    );
                                    return;
                                  } else if (pickedImage == null &&
                                      !widget.isEditing) {
                                    await showWarningMessageFun(
                                        context: context,
                                        text: 'Please select an Image');
                                    return;
                                  }
                                  if (!widget.isEditing &&
                                      pickedImage != null) {
                                    final productId = const Uuid().v4();
                                    Reference ref = FirebaseStorage.instance
                                        .ref()
                                        .child('productImages')
                                        .child('$productId.jpg');
                                    await ref.putFile(pickedImage!);
                                    final String imageUrl =
                                        await ref.getDownloadURL();
                                    BlocProvider.of<AdminProductsCubit>(context)
                                        .uploadAdminProducts(
                                      productId: productId,
                                      productTitle: titleController.text,
                                      productPrice: priceController.text,
                                      productCategory: dropdownButtonItem!,
                                      productDescription:
                                          descriptionController.text,
                                      productImage: imageUrl,
                                      productQuantity: quantityController.text,
                                      createdAt: Timestamp.now(),
                                    );
                                  } else if (widget.isEditing) {
                                    if (pickedImage != null) {
                                      Reference ref = FirebaseStorage.instance
                                          .ref()
                                          .child('productImages')
                                          .child(
                                              '${widget.productModel!.productId}.jpg');
                                      await ref.putFile(pickedImage!);
                                      imageInEditing =
                                          await ref.getDownloadURL();
                                      setState(() {});
                                    }
                                    BlocProvider.of<AdminProductsCubit>(context)
                                        .editAdminProducts(
                                      productId: widget.productModel!.productId,
                                      productTitle: titleController.text,
                                      productPrice: priceController.text,
                                      productCategory: dropdownButtonItem ??
                                          widget.productModel!.productCategory,
                                      productDescription:
                                          descriptionController.text,
                                      productImage: imageInEditing ??
                                          widget.productModel!.productImage,
                                      productQuantity: quantityController.text,
                                    );
                                  }
                                } else {
                                  autovalidateMode = AutovalidateMode.always;
                                  setState(() {});
                                }
                              },
                              icon: Icon(
                                !widget.isEditing ? Icons.upload : Icons.edit,
                              ),
                              label: Text(
                                !widget.isEditing
                                    ? 'Upload Product'
                                    : 'Edit Product',
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 22),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
