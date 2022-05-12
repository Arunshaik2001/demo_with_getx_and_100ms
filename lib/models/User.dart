

import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class User{
  HMSVideoTrack hmsVideoTrack;
  String userName;
  bool isVideoOn;
  HMSPeer peer;

  User(this.hmsVideoTrack, this.userName, this.isVideoOn,this.peer);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          hmsVideoTrack == other.hmsVideoTrack;

  @override
  String toString() {
    return 'User{userName: $userName, isVideoOn: $isVideoOn}';
  }

  @override
  int get hashCode =>
      hmsVideoTrack.hashCode ^ userName.hashCode ^ isVideoOn.hashCode;
}