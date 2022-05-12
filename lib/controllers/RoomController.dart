import 'package:demo_with_getx_and_100ms/models/User.dart';
import 'package:demo_with_getx_and_100ms/views/HomePage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

import '../services/RoomService.dart';

class RoomController extends GetxController
    implements HMSUpdateListener, HMSActionResultListener {
  List<User> usersList = <User>[].obs;
  RxBool isLocalVideoOn = false.obs;
  RxBool isLocalAudioOn = false.obs;

  String url;
  String name;

  RoomController(this.url, this.name);

  HMSSDK hmsSdk = Get.find();

  RxBool isVideoOnPreview = false.obs;
  RxBool isAudioOnPreview = false.obs;

  @override
  void onInit() async {
    hmsSdk.addUpdateListener(listener: this);

    hmsSdk.build();
    List<String?>? token = await RoomService().getToken(user: name, room: url);

    if (token == null) return;
    if (token[0] == null) return;

    HMSConfig config = Get.find();

    hmsSdk.join(config: config);


    isVideoOnPreview = Get.find(tag: "isLocalVideoOn");
    isAudioOnPreview = Get.find(tag: "isLocalAudioOn");


    super.onInit();
  }

  @override
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}) {
    // TODO: implement onChangeTrackStateRequest
  }

  @override
  void onError({required HMSException error}) {
    Get.snackbar("Error", error.message);
  }

  @override
  void onJoin({required HMSRoom room}) {

  }

  @override
  void onMessage({required HMSMessage message}) {
    // TODO: implement onMessage
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    // TODO: implement onPeerUpdate
  }

  @override
  void onReconnected() {
    // TODO: implement onReconnected
  }

  @override
  void onReconnecting() {
    // TODO: implement onReconnecting
  }

  @override
  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer}) {
    // TODO: implement onRemovedFromRoom
  }

  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {
    // TODO: implement onRoleChangeRequest
  }

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
    // TODO: implement onRoomUpdate
  }

  @override
  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer}) {

    isLocalAudioOn.value = isAudioOnPreview.value;
    isLocalAudioOn.refresh();

    isLocalVideoOn.value = isVideoOnPreview.value;
    isLocalVideoOn.refresh();

    if (peer.isLocal) {
      if (track.kind == HMSTrackKind.kHMSTrackKindAudio) {

      } else {
        print("OnTrackUpdate ${peer.name} video ${track.isMute}");

      }
    }

    if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
      User user = User(track as HMSVideoTrack, peer.name, !track.isMute, peer);

      if (!usersList.contains(user)) {
        usersList.add(user);
      }
    }
  }

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {
    // TODO: implement onUpdateSpeakers
  }

  void leaveMeeting() async {
    hmsSdk.leave(hmsActionResultListener: this);
  }

  void toggleAudio() async {
    var result = await hmsSdk.switchAudio(isOn: isLocalAudioOn.value);
    if (result == null) {
      isLocalAudioOn.toggle();
    }
  }

  void toggleVideo() async {
    var result = await hmsSdk.switchAudio(isOn: isLocalVideoOn.value);

    if (result == null) {
      isLocalVideoOn.toggle();

      for (var element in usersList) {
        if (element.peer.isLocal) {
          element.isVideoOn = isLocalVideoOn.value;
        }
      }
    }
  }

  @override
  void onException(
      {HMSActionResultListenerMethod? methodType,
      Map<String, dynamic>? arguments,
      required HMSException hmsException}) {
    Get.snackbar("Error", hmsException.message);
  }

  @override
  void onSuccess(
      {HMSActionResultListenerMethod? methodType,
      Map<String, dynamic>? arguments}) {
    usersList.clear();
    Get.back();
  }
}
