import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget{
  const UserImagePicker({super.key, required this.onPickedImage});

  final void Function (File pickedImage) onPickedImage;

  @override
  State<UserImagePicker> createState() {
    return _UserImagePickerState();
  }
}

class _UserImagePickerState extends State<UserImagePicker>{
  File? _pickedImage;

  void _pickImage() async{
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150,);

    if (pickedImage == null){
      return;
    }

    setState(() {
      _pickedImage = File(pickedImage.path);
    });
    widget.onPickedImage(_pickedImage!);

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage: _pickedImage!=null ? FileImage(_pickedImage!) : null,
        ),
        TextButton.icon(onPressed: _pickImage, label: Text('Pick an image', style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),), icon: Icon(Icons.image)),
      ],
    );
  }
}