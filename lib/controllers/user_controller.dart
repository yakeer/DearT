import 'package:deart/controllers/vehicle_controller.dart';
import 'package:deart/globals.dart';
import 'package:deart/models/vehicle.dart';
import 'package:deart/utils/storage_utils.dart';
import 'package:deart/utils/tesla_api.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final int? selectedVehicleId;
  Rx<Vehicle?> selectedVehicle = Rx(null);
  Rx<List<Vehicle>?> vehicles = Rx(null);
  TeslaAPI api = Get.find<TeslaAPI>();

  UserController(this.selectedVehicleId) : super();

  // @override
  // void onReady() async {
  //   // if (selectedVehicleId == null) {
  //   //   // Load the vehicles and select the first.
  //   //   Vehicle? vehicle = await loadVehicles();
  //   //   Get.put(VehicleController(vehicle!.id, vehicle: vehicle),
  //   //       permanent: true);
  //   // } else {
  //   //   // Init Vehicle Controller so everything will load in the meanwhile
  //   //   Get.put(VehicleController(selectedVehicleId!), permanent: true);

  //   //   // Load the vehicle objects (for vehicle name) etc...;
  //   //   Vehicle? vehicle = await loadVehicles();
  //   //   if (vehicle != null) {
  //   //     Get.find<VehicleController>().setVehicleParameters(vehicle);
  //   //   }
  //   // }

  //   // Init Vehicle Controller so everything will load in the meanwhile

  //   super.onReady();
  // }

  Future initVehicles() async {
    Get.put(VehicleController(selectedVehicleId), permanent: true);

    // Load the vehicle objects (for vehicle name) etc...;
    Vehicle? vehicle = await loadVehicles();
    if (vehicle != null) {
      Get.find<VehicleController>().setVehicleParameters(vehicle);
    }
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
