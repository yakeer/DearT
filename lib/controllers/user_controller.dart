import 'dart:convert';

import 'package:deart/controllers/vehicle_controller.dart';
import 'package:deart/globals.dart';
import 'package:deart/models/internal/gps_location.dart';
import 'package:deart/models/internal/vehicle_preference.dart';
import 'package:deart/models/vehicle.dart';
import 'package:deart/services/auth_service.dart';
import 'package:deart/utils/storage_utils.dart';
import 'package:deart/services/tesla_api.dart';
import 'package:deart/utils/ui_utils.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  int? selectedVehicleId;
  Rx<Vehicle?> selectedVehicle = Rx(null);
  Rx<List<Vehicle>?> vehicles = Rx(null);
  TeslaAPI api = Get.find<TeslaAPI>();
  Rx<List<VehiclePreference>> preferences = Rx([]);
  Rx<List<GPSLocation>> excludedAutoSentryLocations = Rx([]);

  UserController(this.selectedVehicleId) : super();

  Future initVehicles() async {
    Get.put(VehicleController(selectedVehicleId), permanent: true);

    // Load the vehicle objects (for vehicle name) etc...;
    Vehicle? vehicle = await loadVehicles();
    if (vehicle != null) {
      Get.find<VehicleController>().setVehicleParameters(vehicle);

      if (selectedVehicleId == null || selectedVehicleId != vehicle.id) {
        selectedVehicleId = vehicle.id;
      }
    }

    await initSettings();
  }

  Future initSettings() async {
    await _initVehiclePreferences();
    await loadAutoSentryExcludedLocations();
  }

  Future<void> _initVehiclePreferences() async {
    preferences.value.add(
      VehiclePreference(
        'activateSentry',
        await readPreference<bool>(selectedVehicleId!, 'activateSentry', false),
      ),
    );

    preferences.value.add(
      VehiclePreference(
        'activateSentryWhenLocked',
        await readPreference<bool>(
            selectedVehicleId!, 'activateSentryWhenLocked', false),
      ),
    );

    preferences.value.add(
      VehiclePreference(
        'sentryQuickActionToggle',
        await readPreference<bool>(
            selectedVehicleId!, 'sentryQuickActionToggle', true),
      ),
    );

    preferences.value.add(
      VehiclePreference(
        'showBatteryLevelInAppBar',
        await readPreference<bool>(
            selectedVehicleId!, 'showBatteryLevelInAppBar', false),
      ),
    );

    preferences.value.add(
      VehiclePreference(
        'dataRefreshInterval',
        await readPreference<double>(
            selectedVehicleId!, 'dataRefreshInterval', 0),
      ),
    );
  }

  Future<Vehicle?> loadVehicles() async {
    Vehicle? vehicle;

    // Load Vehicles from API
    vehicles.value = await api.getVehicles();

    // Show an error message and logut.
    if (vehicles.value!.isEmpty) {
      openPopup('Error', 'No vehicles found in your account.');

      await Get.find<AuthService>().logout();
    }

    if (vehicles.value != null && vehicles.value!.isNotEmpty) {
      // Auto select first vehicle
      if (vehicles.value!.length == 1) {
        vehicle = vehicles.value!.first;
      } else {
        if (selectedVehicleId == null) {
          vehicle = vehicles.value!.first;
        } else {
          vehicle = vehicles.value!
              .firstWhereOrNull((element) => (element.id == selectedVehicleId));

          vehicle ??= vehicles.value!.first;
        }
      }

      selectedVehicle.value = vehicle;

      carChanged(vehicle.id, vehicle.displayName);
    }

    return vehicle;
  }

  T? getPreference<T>(String prefName) {
    VehiclePreference? pref = preferences.value
        .firstWhereOrNull((element) => element.name == prefName);

    if (pref != null) {
      return pref.value as T;
    } else {
      return null;
    }
  }

  void setPreference<T>(String prefName, T value) {
    VehiclePreference? pref = preferences.value
        .firstWhereOrNull((element) => element.name == prefName);
    if (pref != null) {
      pref.value = value;
    }

    preferences.trigger(preferences.value);
  }

  void addAutoSentryExcludedLocation(GPSLocation location) async {
    List<GPSLocation> locations = excludedAutoSentryLocations.value;
    locations.add(location);

    excludedAutoSentryLocations.value = locations;

    excludedAutoSentryLocations.trigger(locations);

    await saveAutoSentryExcludedLocations();
  }

  void removeAutoSentryExcludedLocation(GPSLocation location) {
    var gpsLocation = excludedAutoSentryLocations.value.firstWhereOrNull(
        (element) =>
            element.latitude == location.latitude &&
            element.longitude == location.longitude);
    if (gpsLocation != null) {
      excludedAutoSentryLocations.value.remove(gpsLocation);
      excludedAutoSentryLocations.trigger(excludedAutoSentryLocations.value);

      saveAutoSentryExcludedLocations();
    }
  }

  Future saveAutoSentryExcludedLocations() async {
    String jsonMap = jsonEncode(excludedAutoSentryLocations.value);

    await writeUserPreference('excludedAutoSentryLocations', jsonMap);

    excludedAutoSentryLocations.trigger(excludedAutoSentryLocations.value);
  }

  Future loadAutoSentryExcludedLocations() async {
    String? jsonData =
        await readUserPreference<String>('excludedAutoSentryLocations');
    if (jsonData != null) {
      var locationsMap = jsonDecode(jsonData);

      excludedAutoSentryLocations.value =
          GPSLocation.fromJsonList(locationsMap);
    }
  }

  GPSLocation? findExcludedLocationById(String id) {
    return excludedAutoSentryLocations.value
        .firstWhereOrNull((element) => element.id == id);
  }

  carChanged(
    int vehicleId,
    String vehicleName, {
    bool reloadData = false,
  }) async {
    // Set selected vehicle id
    Globals.vehicleId = vehicleId;
    await writeStorageKey('vehicleId', vehicleId.toString());

    // Set selected Vehicle name
    String vehicleName = Get.find<UserController>()
        .vehicles
        .value!
        .firstWhere((x) => x.id == vehicleId)
        .displayName;
    await writeStorageKey('vehicleName', vehicleName.toString());

    if (reloadData) {
      Vehicle? vehicle =
          vehicles.value?.firstWhere((element) => element.id == vehicleId);
      if (vehicle != null) {
        selectedVehicle.value = vehicle;
      }
      Get.find<VehicleController>().changeVehicle(vehicleId, vehicleName);

      // Reload data if car changed
      Get.find<VehicleController>().refreshState(false);
    }
  }
}
