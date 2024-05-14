import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatelessWidget {
  const ImagePickerWidget({
    super.key,
    required this.isEditing,
    required this.pickedImage,
    required this.onImagePicked,
    required this.onRemoveImage,
  });


  final bool isEditing;
  final File? pickedImage;
  final void Function(XFile pickedImage) onImagePicked;
  final void Function() onRemoveImage;


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: pickedImage == null
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () async {
            String? image = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Choose Option',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pop('Camera');
                        },
                        leading: const Icon(Icons.camera),
                        title: const Text('Camera'),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pop('Gallery');
                        },
                        leading: const Icon(Icons.photo),
                        title: const Text('Gallery'),
                      ),
                    ],
                  ),
                );
              },
            );
            if (image == null) {
              return;
            }
            final XFile? pickImage = await ImagePicker().pickImage(
              source:
                  image == 'Camera' ? ImageSource.camera : ImageSource.gallery,
            );
            if (pickImage != null) {
              onImagePicked(pickImage);
            }
          },
          child: Text(
            isEditing ? 'Pick another image' : 'pick an image',
            style: const TextStyle(
              fontSize: 19,
              color: Colors.blue,
            ),
          ),
        ),
        if (!isEditing && pickedImage != null)
          TextButton(
            onPressed: onRemoveImage,
            child: const Text(
              'Remove image',
              style: TextStyle(
                fontSize: 19,
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }
}
