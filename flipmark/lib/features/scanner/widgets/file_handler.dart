import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FileHandler extends StatelessWidget {
  final void Function(XFile?) onFileSelected;
  // callback, var onFileSelected holds a function from scanner_page

  final bool hasFile;
  final XFile? file;

  FileHandler({
    super.key,
    required this.onFileSelected,
    required this.hasFile,
    required this.file,
  });

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickFile() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      onFileSelected(
        pickedFile,
      ); // selects file and rebuilds UI (from scanner_page)
    } catch (e) {
      debugPrint("Error selecting file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return (ElevatedButton.icon(
      onPressed: _pickFile,
      icon: const Icon(Icons.folder),
      label: Text(hasFile ? 'Change File' : 'Choose File'),
    ));
  }
}
