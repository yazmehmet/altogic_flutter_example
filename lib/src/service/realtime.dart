import 'package:altogic_flutter/altogic_flutter.dart';
import 'package:altogic_flutter_example/main.dart';
import 'package:altogic_flutter_example/src/service/service_base.dart';
import 'package:altogic_flutter_example/src/view/pages/database/cases.dart';
import 'package:flutter/material.dart';

class RealtimeService extends ServiceBase {
  static RealtimeService of(BuildContext context) {
    return InheritedService.of<RealtimeService>(context);
  }

  RealtimeManager get realtime => altogic.realtime;

  Future<void> open() async {
    realtime.open();
  }

  Future<void> close() async {
    realtime.close();
  }

  void on(String event, Function(dynamic) callback) {
    realtime.on(event, callback);
    response.value = 'on $event';
  }

  void off(String event, Function(dynamic) callback) {
    realtime.off(event, callback);
    response.value = 'off $event';
  }

  void broadcast(String event, dynamic data) {
    realtime.broadcast(event, {"message": data});
    response.value = "Sent to $event";
  }

  void send(String channel, String event, dynamic data) {
    realtime.send(channel, event, {"message": data});
    response.value = "Sent message to $event only $channel members";
  }

  void join(String room) {
    realtime.join(room);
    response.value = "Joined $room";
  }

  void leave(String room) {
    realtime.leave(room);
    response.value = "Left $room";
  }

  void getMembers(String room) async {
    var res = await realtime.getMembers(room);
    response.value = "Members of $room : \n$res";
  }

  void updateUserData(String data) async {
    realtime.updateProfile(MemberData(
        id: currentUser.user.id,
        data: {'name': currentUser.user.name, 'data': data}));
    response.value = "Updated user data";
  }

  void message() {}
}
