import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraHandler extends StatefulWidget {
  final void Function(XFile?) onImageCaptured;
  // callback, var onImageCaptured holds a function from scanner_page
  // takes in a XFile from _takePhoto()

  const CameraHandler({super.key, required this.onImageCaptured});

  @override
  State<CameraHandler> createState() => _CameraHandlerState();
}

class _CameraHandlerState extends State<CameraHandler>
    with WidgetsBindingObserver {
  CameraController? _controller;
  // ^ handles opening camera, preview, taking photos
  List<CameraDescription>? _cameras;
  // ^ stores a list of all cameras detected on the device
  bool _isInitialized = false; // has the camera loaded?

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // triggers when user leaves the app (or minimizes it) and returns to the app

    if (_controller == null || !_controller!.value.isInitialized) return;

    if (kIsWeb) return; // for running app in web browser
    // webs handle camera perms, can skip this functoin

    if (state == AppLifecycleState.inactive) {
      // if the app is closed/minimized
      _controller?.dispose(); // close the camera entirely
      _isInitialized = false;
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera(); // restart the camera
    }
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();

      if (_cameras != null && _cameras!.isNotEmpty) {
        CameraDescription selectedCamera = _cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => _cameras!.first,
        ); // finds the back camera, if not, then the front lens

        _controller = CameraController(
          selectedCamera,
          ResolutionPreset.medium,
          enableAudio: false,
        );

        await _controller!.initialize();
        if (!mounted) return;
        // if the user left the screen, stop executing
        // otherwise, the camera gets initialized

        setState(() {
          _isInitialized = true;
          // redraw screen
        });
      }
    } catch (e) {
      debugPrint("Camera initialization error: $e");
    }
  }

  Future<void> _takePhoto() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      // take a picture
      final XFile photo = await _controller!.takePicture();
      widget.onImageCaptured(photo);
    } catch (e) {
      debugPrint("Error taking picture: $e");
    }
  }

  @override
  void dispose() {
    //
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 400,
          height: 500,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: (!_isInitialized || _controller == null)
                ? const Center(child: CircularProgressIndicator())
                : CameraPreview(_controller!),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: _takePhoto,
          icon: const Icon(Icons.camera_alt),
          label: const Text("Capture Frame"),
        ),
      ],
    );
  }
}
