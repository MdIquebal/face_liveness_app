import 'package:face/screen/home.dart';

import 'package:flutter/material.dart';

class ImagePicker extends StatefulWidget {
  @override
  State<ImagePicker> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Home(),
      // Column(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     Expanded(
      //       child: Container(
      //         height: double.infinity,
      //         width: double.infinity,
      //         child: Home(),
      //       ),
      //     ),
      //     // IconButton(
      //     //   color: Color.fromARGB(255, 138, 3, 248),
      //     //   onPressed: () {
      //     //     Navigator.of(context).push(
      //     //       MaterialPageRoute(builder: (context) => UpLoadImage()),
      //     //     );
      //     //   },
      //     //   icon: Icon(
      //     //     Icons.camera_alt_outlined,
      //     //     color: Colors.white,
      //     //     size: 40,
      //     //   ),
      //     // ),
      //   ],
      // ),
    );
  }
}
