
import 'package:demo_with_getx_and_100ms/controllers/RoomController.dart';
import 'package:demo_with_getx_and_100ms/models/User.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class VideoWidget extends StatelessWidget {
  final int index;

  const VideoWidget(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<RoomController>(builder: (controller) {
      print("IsVideoOn ${controller.usersList[index]}");
      User user = controller.usersList[index];
      return (user.peer.isLocal ? controller.isLocalVideoOn.value : user.isVideoOn)
          ? ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Column(
                children: [
                  SizedBox(
                    height: 200.0,
                    width: 400.0,
                    child: HMSVideoView(
                      track: controller.usersList[index].hmsVideoTrack,
                      matchParent: false,
                    ),
                  ),
                  Text(
                    controller.usersList[index].userName,
                  )
                ],
              ),
            )
          : SizedBox(
              height: 200.0,
              width: 400.0,
              child: Center(
                  child: CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 36,
                      child: Text(
                        controller.usersList[index].userName,
                        style:
                            const TextStyle(fontSize: 36, color: Colors.white),
                      ))));
    });
  }
}
