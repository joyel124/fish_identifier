import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Variables to store the captured/uploaded image and the classification result
  String? imageResult;
  CameraController? cameraController;
  List<CameraDescription>? cameras;
  String? classificationResult;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(cameras![0], ResolutionPreset.medium);
    await cameraController!.initialize();
  }

  // Callback function for the "Tomar Foto" button
  void capturePhoto() async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.camera);

      if (pickedImage != null) {
        // The image was successfully captured
        imageResult = pickedImage.path;
        setState(() {});
      } else {
        // The user canceled or did not capture any image
        // Handle the case accordingly
      }
    }
  }

  // Callback function for the "Subir Imagen" button
  void uploadImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      // The image was successfully picked
      imageResult = pickedImage.path;
      setState(() {}); // Refresh the UI to reflect the selected image
    } else {
      // The user canceled or did not select any image
      // Handle the case accordingly
    }
  }

  // Callback function for the "Clasificar" button
  void classifyImage() {
    // Implement your logic to classify the image and obtain the result
    // Assign the classification result to the 'classificationResult' variable
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Fish Identifier"),
            centerTitle: true,
          ),
          backgroundColor: Colors.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                margin: const EdgeInsets.only(top: 50, bottom: 20, left: 50, right: 50),
                height: 200,
                alignment: Alignment.center,
                child: Image.asset('assets/images/EmptyState.png'),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: capturePhoto,
                    child: const Text('Tomar Foto'),
                  ),
                  ElevatedButton(
                    onPressed: uploadImage,
                    child: const Text('Subir Imagen'),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: classifyImage,
                child: const Text('Clasificar'),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                margin: const EdgeInsets.only(top: 20, bottom: 20, left: 80, right: 80),
                height: 50,
                alignment: Alignment.center,
                child: Text("Resultado: ${classificationResult ?? ''}"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
