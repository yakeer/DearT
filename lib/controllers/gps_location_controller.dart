import 'package:deart/controllers/user_controller.dart';
import 'package:deart/controllers/vehicle_controller.dart';
import 'package:deart/models/vehicle_data.dart';
import 'package:deart/utils/marker_generator.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:platform_maps_flutter/platform_maps_flutter.dart';

import '../models/internal/gps_location.dart';

class GPSLocationController extends GetxController {
  Rx<GPSLocation?> gpsLocation = Rx(null);
  Rx<List<Marker>> markers = Rx([]);
  Rx<List<Circle>> circles = Rx([]);

  PlatformMapController? mapController;
  TextEditingController nameInputController = TextEditingController();
  TextEditingController radiusInputController = TextEditingController();

  GPSLocationController(String? id) {
    if (id != null) {
      gpsLocation.value =
          Get.find<UserController>().findExcludedLocationById(id)!;
    }
  }

  @override
  void onInit() {
    nameInputController.value = TextEditingValue(text: gpsLocation.value!.name);
    radiusInputController.value =
        TextEditingValue(text: gpsLocation.value!.radius?.toString() ?? '');

    initMarkers();
    initCircles();

    super.onInit();
  }

  @override
  void onReady() {
    requestPermissions();
    super.onReady();
  }

  Future requestPermissions() async {
    if (await Geolocator.isLocationServiceEnabled()) {
      LocationPermission permissionResult = await Geolocator.checkPermission();
      if (permissionResult == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
    }
  }

  void initMarkers() async {
    MarkerGenerator markerGenerator = MarkerGenerator(100);

    List<Marker> annotationsSet = [];

    VehicleData vehicleData = Get.find<VehicleController>().vehicleData.value!;

    annotationsSet.add(Marker(
      markerId: MarkerId(gpsLocation.value!.id),
      position: LatLng(
        gpsLocation.value!.latitude,
        gpsLocation.value!.longitude,
      ),
      visible: true,
      infoWindow: InfoWindow(title: gpsLocation.value!.name),
    ));

    annotationsSet.add(Marker(
      markerId: MarkerId(vehicleData.displayName),
      position: LatLng(
        vehicleData.driveState.latitude,
        vehicleData.driveState.longitude,
      ),
      // anchor: const Offset(0.5, 0.5),
      visible: true,
      infoWindow: InfoWindow(title: vehicleData.displayName),
      icon: await markerGenerator.createBitmapDescriptorFromIconData(
        Icons.electric_car,
        Colors.blue,
        Colors.transparent,
        Colors.transparent,
      ),
    ));

    // ignore: invalid_use_of_protected_member
    markers.value = annotationsSet.toList();
  }

  void initCircles() {
    List<Circle> circlesList = [];
    circlesList.add(
      Circle(
        circleId: CircleId("carRadius"),
        center: LatLng(
          gpsLocation.value!.latitude,
          gpsLocation.value!.longitude,
        ),
        radius: gpsLocation.value!.radius ?? 50,
        fillColor: const Color.fromARGB(68, 33, 149, 243),
        strokeWidth: 1,
        strokeColor: const Color.fromARGB(68, 33, 149, 243),
      ),
    );
    circles.value = circlesList;
  }

  void onMapCreated(PlatformMapController controller) {
    mapController = controller;
  }

  void updateName(String name) {
    gpsLocation.value!.name = name;
    gpsLocation.value = gpsLocation.value;
    Get.find<UserController>().saveAutoSentryExcludedLocations();
  }

  void updateRadius(double radius) {
    gpsLocation.value!.radius = radius;
    gpsLocation.value = gpsLocation.value;

    Get.find<UserController>().saveAutoSentryExcludedLocations();
  }

  deleteLocation(GPSLocation location) {
    Get.find<UserController>().removeAutoSentryExcludedLocation(location);
    Get.back();
  }
}
