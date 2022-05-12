import 'dart:io';

import 'package:demo_with_getx_and_100ms/views/PreviewWidget.dart';
import 'package:demo_with_getx_and_100ms/views/RoomWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final meetingTextController = TextEditingController(text: "https://shaik.app.100ms.live/meeting/ajk-stp-ebs");
    final nameTextController = TextEditingController();

    return 
      SafeArea(
        child: Scaffold(
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300.0,
                  child: TextField(
                    controller: meetingTextController,
                    decoration: const InputDecoration(
                        hintText: 'Meeting Url'
                    ),
                  ),
                ),
                const SizedBox(height: 30.0,),
                SizedBox(
                  width: 200.0,
                  child: TextField(
                    controller: nameTextController,
                    decoration: const InputDecoration(
                        hintText: 'name'
                    ),
                  ),
                ),
                const SizedBox(height: 30.0,),
                ElevatedButton(
                  onPressed: () async{
                    if (!(GetUtils.isBlank(meetingTextController.text) ?? true) &&
                        !(GetUtils.isBlank(nameTextController.text) ?? true))
                      {
                        if (kDebugMode) {
                          print("RaisedButton ${meetingTextController.text} ${nameTextController.text}");
                        }
                        bool res = await getPermissions();
                        if(res) {
                          Get.to(()=>PreviewWidget(meetingTextController.text, nameTextController.text));
                        }
                      }
                  },
                  child: const Text("Join Now"),
                )
              ],
            )),
    ),
      );
  }


  Future<bool> getPermissions() async {
    if (Platform.isIOS) return true;
    await Permission.camera.request();
    await Permission.microphone.request();

    while ((await Permission.camera.isDenied)) {
      await Permission.camera.request();
    }
    while ((await Permission.microphone.isDenied)) {
      await Permission.microphone.request();
    }

    while ((await Permission.bluetoothConnect.isDenied)) {
      await Permission.bluetoothConnect.request();
    }
    return true;
  }
}
