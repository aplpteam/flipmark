import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'widgets/camera_handler.dart';
import 'widgets/file_handler.dart';
import 'widgets/image_preview.dart';

class ScannerPage extends StatefulWidget {
  final String mode;

  const ScannerPage({super.key, required this.mode});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  XFile? _image;

  void _imageSelected(XFile? file) {
    setState(() {
      _image = file;
    });
  }

  void _clearImage() {
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isCameraMode = (widget.mode == "Camera");
    final bool hasCapturedImage = _image != null;

    return Scaffold(
      appBar: AppBar(title: Text('${widget.mode} Scanner'), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isCameraMode || hasCapturedImage) ...[
                ImagePreview(image: _image),
                const SizedBox(height: 20),
              ],

              if (isCameraMode) // if camera mode
                hasCapturedImage
                    ? ElevatedButton.icon(
                        onPressed: _clearImage,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text("Retake Photo"),
                      )
                    : CameraHandler(onImageCaptured: _imageSelected)
              else // else it's file mode
                FileHandler(
                  onFileSelected: _imageSelected,
                  hasFile: hasCapturedImage,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
