import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key,required this.onPickImage});
  final void Function(File image) onPickImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;

  Future<void> _imagePicker() async {
    final imagepicker = ImagePicker();
    final pickedImage =
        await imagepicker.pickImage(source: ImageSource.camera, maxWidth: 600);
    if (pickedImage == null) {
      return;
    }

    setState(() {
      _selectedImage = File(pickedImage.path!);
    });
    widget.onPickImage (_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {

    Widget content = TextButton.icon(
      onPressed:_imagePicker,
      icon: const Icon(Icons.camera,size: 50,),
      label: const Text("Select Image"),
    );
    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _imagePicker,
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.white.withOpacity(0.3))),
      height: 250,
      width: double.infinity,
      child: content,
    );
  }
}
