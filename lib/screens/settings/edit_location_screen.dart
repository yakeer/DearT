import 'package:deart/controllers/gps_location_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:platform_maps_flutter/platform_maps_flutter.dart';

class EditLocationScreen extends GetView<GPSLocationController> {
  const EditLocationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<GPSLocationController>(
      init: GPSLocationController(Get.parameters['id']),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text('Edit "${controller.gpsLocation.value?.name}"'),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => controller.deleteLocation(
                controller.gpsLocation.value!,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Flex(
            direction: Axis.vertical,
            children: [
              Flexible(
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Location Name'),
                  controller: controller.nameInputController,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      controller.updateName(value);
                    }
                  },
                ),
              ),
              Flexible(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Radius (meters)',
                    helperText:
                        'The radius around coordinates which will be considered as valid',
                  ),
                  keyboardType: TextInputType.number,
                  controller: controller.radiusInputController,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      controller.updateRadius(double.parse(value));
                    }
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: PlatformMap(
                    trafficEnabled: false,
                    onMapCreated: controller.onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        controller.gpsLocation.value!.latitude,
                        controller.gpsLocation.value!.longitude,
                      ),
                      zoom: 17,
                    ),
                    // myLocationEnabled: false,
                    // compassEnabled: true,
                    markers: controller.markers.value.toSet(),
                    circles: controller.circles.value.toSet(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
