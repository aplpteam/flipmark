import 'dart:typed_data'; // for Uint8List bytes unsigned 8-bit ints (stores 0s and 1s)
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePreview extends StatelessWidget {
  final XFile? image;
  final bool isCameraMode;

  const ImagePreview({super.key, this.image, required this.isCameraMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 500,
      decoration: BoxDecoration(
        border: image == null ? Border.all(color: Colors.grey) : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: image == null
          ? Center(child: Text('No file uploaded.'))
          : ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FutureBuilder<Uint8List>(
                future: image!.readAsBytes(),
                builder: (context, snapshot) {
                  // gets called everytime future's state changes
                  // snapshot holds the byte data
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return Image.memory(
                      snapshot.data!,
                      fit: isCameraMode ? BoxFit.cover : BoxFit.contain,
                    );
                    // Image.memory() stores the raw bytes (Uin8List)
                  }

                  return const Center(
                    child: Icon(Icons.broken_image, color: Colors.red),
                  );
                },
              ),
            ),
    );
  }
}
