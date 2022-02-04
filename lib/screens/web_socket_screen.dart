import 'package:deart/controllers/streaming_api_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebSocketScreen extends GetView<StreamingAPIController> {
  const WebSocketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get.put(StreamingAPIController());
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(controller.title.value),
    //   ),
    //   body: StreamBuilder(
    //       stream: controller.channel!.stream,
    //       builder: (context, snapshot) {
    //         // String rawMessage = String.fromCharCodes(message);
    //         return ListView.builder(
    //           itemCount: snapshot.data.le,
    //           itemBuilder: (context, index) => ListTile(
    //             title: Text(
    //               String.fromCharCodes(snapshot.data[index]),
    //             ),
    //           ),
    //         );
    //       }),
    // );
    return GetX<StreamingAPIController>(
      init: StreamingAPIController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text(controller.title.value),
        ),
        body: ListView.builder(
          itemCount: controller.messages.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(
              controller.messages[index].rawValue,
            ),
          ),
        ),
      ),
    );
  }
}
