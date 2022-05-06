import 'dart:io';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:face/screen/face_detector_painter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'camera_view.dart';
import 'face_detector_painter.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  FaceDetector faceDetector = GoogleMlKit.vision.faceDetector(
    FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
      enableLandmarks: true,
    ),
  );
  bool isBusy = false;
  CustomPaint? customPaint;

  @override
  void dispose() {
    faceDetector.close();
    super.dispose();
  }

  void _pickImage() async {
    try {
      final pickedFile = await _picker.getImage(source: ImageSource.camera);
      setState(() {
        _imageFile = pickedFile!;
      });
    } catch (e) {
      print("Image picker error ");
    }
  }

  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  _previewImage(context) {
    if (_imageFile != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.file(File(_imageFile!.path)),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                upload(File(_imageFile!.path));
              },
              child: const Text('Upload'),
            ),
          ],
        ),
      );
    } else {
      return const Text(
        'Upload Photo',
        textAlign: TextAlign.center,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: CameraView(
                customPaint: customPaint,
                onImage: (inputImage) {
                  processImage(inputImage);
                },
                initialDirection: CameraLensDirection.front,
              ),
            ),
          ),
          Container(
            child: FloatingActionButton(
              backgroundColor: Color.fromARGB(255, 4, 59, 240),
              onPressed: _pickImage,
              tooltip: 'Pick Image from gallery',
              child: Icon(
                Icons.camera_alt_outlined,
              ),
            ),
          ),
          SizedBox(width: 200, child: _previewImage(context)),
          SizedBox(
            height: 40,
            width: 30,
          ),
        ],
      ),
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    final faces = await faceDetector.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = FaceDetectorPainter(
          faces,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      customPaint = CustomPaint(painter: painter);
    } else {
      customPaint = null;
    }
    isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  upload(File imageFile) async {
    print("image file $imageFile");
    // open a bytestream
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("http://192.168.19.204:8080/upload");

    // create multipart request
    var req = http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    req.files.add(multipartFile);

    // send
    var response = await req.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.reasonPhrase;
    }
  }
}
