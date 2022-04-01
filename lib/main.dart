import 'package:face/screen/image_pick.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'screen/home.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  runApp(
    GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => ImagePicker(),
          transition: Transition.fadeIn,
        ),
        
      ],
    ),
  );
}
