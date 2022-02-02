import 'package:deart/controllers/vehicle_controller.dart';
import 'package:deart/globals.dart';
import 'package:deart/models/internal/vehicle_preference.dart';
import 'package:deart/models/vehicle.dart';
import 'package:deart/utils/storage_utils.dart';
import 'package:deart/utils/tesla_api.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final int? selectedVehicleId;
  Rx<Vehicle?> selectedVehicle = Rx(null);
  Rx<List<Vehicle>?> vehicles = Rx(null);
  TeslaAPI api = Get.find<TeslaAPI>();
  Rx<List<VehiclePreference>> preferences = Rx([]);

  UserController(this.selectedVehicleId) : super();

  Future initVehicles() async {
    Get.put(VehicleController(selectedVehicleId), permanent: true);

    // Load the vehicle objects (for vehicle name) etc...;
    Vehicle? vehicle = await loadVehicles();
    if (vehicle != null) {
      Get.find<VehicleController>().setVehicleParameters(vehicle);
    }

    await initSettings();
  }

  Future initSettings() async {
    preferences.value.add(VehiclePreference(
        'activateSentry',
        await readPreference<bool>(
            selectedVehicleId!, 'activateSentry', false)));
  }

  Future<Vehicle?> loadVehicles() async {
    Vehicle? vehicle;

    // Load Vehicles from API
    vehicles.value = await api.getVehicles();
    if (vehicles.value != null && vehicles.value!.isNotEmpty) {
      // Auto select first vehicle
      if (vehicles.value!.length == 1) {
        vehicle = vehicles.value!.first;
      } else {
        if (selectedVehicleId == null) {
          vehicle = vehicles.value!.first;
        } else {
          vehicle = vehicles.value!
              .firstWhere((element) => (element.id == selectedVehicleId));
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
      Get.find<VehicleController>().refreshState();
    }
  }
}
