import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'widgets/camera_handler.dart';
import 'widgets/file_handler.dart';
import 'widgets/image_preview.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../results/widgets/book_result.dart';
import '../results/results_page.dart';

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
                ImagePreview(image: _image, isCameraMode: isCameraMode),
                const SizedBox(height: 20),
              ],

              if (isCameraMode)
                hasCapturedImage
                    ? ElevatedButton.icon(
                        onPressed: _clearImage,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text("Retake Photo"),
                      )
                    : CameraHandler(onImageCaptured: _imageSelected)
              else
                FileHandler(
                  onFileSelected: _imageSelected,
                  hasFile: hasCapturedImage,
                ),

              if (hasCapturedImage) const SizedBox(height: 20),

              // Connects to python backend
              if (hasCapturedImage)
                ElevatedButton.icon(
                  onPressed: () async {
                    if (_image == null) return;

                    final file = File(_image!.path);

                    // Build request
                    final request = http.MultipartRequest(
                      'POST',
                      Uri.parse("http://127.0.0.1:8000/upload_synopsis"),
                    );

                    request.files.add(
                      await http.MultipartFile.fromPath('file', file.path),
                    );

                    // Send request
                    final streamed = await request.send();
                    final response = await http.Response.fromStream(streamed);

                    debugPrint("Backend response: ${response.body}");

                    // Parse JSON
                    final data = jsonDecode(response.body);
                    final query = data["query"];
                    final resultsJson = data["results"] as List;

                    final results = resultsJson
                        .map((item) => BookResult.fromJson(item))
                        .toList();

                    // Navigate to results page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ResultsPage(query: query, results: results),
                      ),
                    );
                  },
                  icon: const Icon(Icons.check),
                  label: const Text("Find Similar Books"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
