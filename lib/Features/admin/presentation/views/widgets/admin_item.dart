import 'package:flutter/material.dart';

import '../add_or__edit_product_view.dart';
import '../inspect_all_products.dart';
import '../orders_admin_view.dart';

class AdminItem extends StatelessWidget {
  const AdminItem({super.key, required this.text, required this.image});

  final String text;
  final String image;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (text == 'Add a new Product') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddOrEditProduct()));
        } else if (text == 'Inspect all Products') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const InspectAllProductsView()));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const OrdersAdminView()));
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: 100,
            ),
            const SizedBox(height: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 22,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
