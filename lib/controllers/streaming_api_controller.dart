import 'dart:async';
import 'dart:convert';

import 'package:deart/controllers/vehicle_controller.dart';
import 'package:deart/globals.dart';
import 'package:deart/models/streaming/stream_message.dart';
import 'package:deart/models/streaming/tesla_stream_message.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class StreamingAPIController extends GetxController {
  RxList messages = RxList([]);
  RxString title = 'Stream Log'.obs;
  WebSocketChannel? channel;

  StreamSubscription? subscription;

  @override
  void onInit() {
    startChannel();
    listenToMessages();
    sendAuthMessage();
    super.onInit();
  }

  void startChannel() {
    channel = IOWebSocketChannel.connect(
      Uri.parse('wss://streaming.vn.teslamotors.com/streaming/'),
      pingInterval: const Duration(seconds: 5),
    );
  }

  void listenToMessages() {
    subscription = channel!.stream.listen(
      (message) {
        String rawMessage = String.fromCharCodes(message);

        messages.insert(
          0,
          StreamMessage(rawMessage),
        );
      },
    );
  }

  void sendAuthMessage() {
    int streamingVehicleId =
        Get.find<VehicleController>().streamingVehicleId.value!;

    var teslaMessage = TeslaStreamMessage(
      'data:subscribe_oauth',
      // 'speed,odometer,soc,elevation,est_heading,est_lat,est_lng,power,shift_state,range,est_range,heading',
      value:
          'speed,odometer,soc,elevation,est_heading,est_lat,est_lng,power,shift_state,range,est_range,heading,est_corrected_lat,est_corrected_lng,native_latitude,native_longitude,native_heading,native_type,native_location_supported',
      tag: streamingVehicleId.toString(),
      token: Globals.apiAccessToken!,
    );

    String text = jsonEncode(teslaMessage);

    channel!.sink.add(text);
  }

  @override
  void onClose() {
    subscription!.cancel();
    channel!.sink.close();
    super.onClose();
  }
}
