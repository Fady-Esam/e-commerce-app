import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAllFields extends StatefulWidget {
  const CustomAllFields({
    super.key,
    required this.titleController,
    required this.priceController,
    required this.quantityController,
    required this.descriptionController,
    required this.autovalidateMode,
    required this.titleControlleronChanged,
    required this.priceControlleronChanged,
    required this.quantityControlleronChanged,
    required this.descriptionControlleronChanged,
  });

  final TextEditingController titleController,
      priceController,
      quantityController,
      descriptionController;
  final AutovalidateMode autovalidateMode;
  final void Function(String value) titleControlleronChanged;
  final void Function(String value) priceControlleronChanged;
  final void Function(String value) quantityControlleronChanged;
  final void Function(String value) descriptionControlleronChanged;

  @override
  State<CustomAllFields> createState() => _CustomAllFieldsState();
}

class _CustomAllFieldsState extends State<CustomAllFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a valid title';
            }
            return null;
          },
          onChanged: widget.titleControlleronChanged,
          maxLength: 100,
          controller: widget.titleController,
          autovalidateMode: widget.autovalidateMode,
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 2,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.blue,
              ),
            ),
            hintText: 'Product Title',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.blue,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.blue,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Price is missing';
                  }
                  return null;
                },
                onChanged: widget.priceControlleronChanged,
                textInputAction: TextInputAction.newline,
                autovalidateMode: widget.autovalidateMode,
                controller: widget.priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefix: const Text(
                    '\$',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  hintText: 'Price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Quantity is missing';
                  }
                  return null;
                },
                onChanged: widget.quantityControlleronChanged,
                keyboardType: TextInputType.number,
                autovalidateMode: widget.autovalidateMode,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                controller: widget.quantityController,
                decoration: InputDecoration(
                  hintText: 'Qty',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        TextFormField(
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Description is missing';
            }
            return null;
          },
          controller: widget.descriptionController,
          onChanged: widget.descriptionControlleronChanged,
          autovalidateMode: widget.autovalidateMode,
          minLines: 3,
          maxLines: 50,
          maxLength: 1000,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            hintText: 'Product description',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.blue,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.blue,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.blue,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
