import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});

  final void Function(File image) onPickImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _takenPhoto;

  void _takePhoto() async {
    final imagePicker = ImagePicker();
    final cameraPhoto =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (cameraPhoto == null) {
      return;
    }
    setState(() {
      _takenPhoto = File(cameraPhoto.path);
    });

    widget.onPickImage(_takenPhoto!);
  }

  @override
  Widget build(BuildContext context) {
    Widget photosWidget = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton.icon(
          onPressed: _takePhoto,
          icon: const Icon(
            Icons.camera,
            size: 30.0,
          ),
          label: const Text(
            'Take Photo',
            style: TextStyle(fontSize: 30.0),
          ),
        ),
      ],
    );

    if (_takenPhoto != null) {
      photosWidget = GestureDetector(
        onTap: _takePhoto,
        child: Image.file(
          _takenPhoto!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      height: 250.0,
      width: double.infinity,
      child: photosWidget,
    );
  }
}
