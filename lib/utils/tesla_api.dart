import 'package:deart/constants.dart';
import 'package:deart/controllers/vehicle_controller.dart';
import 'package:deart/models/charge_state.dart';
import 'package:deart/models/command_result.dart';
import 'package:deart/models/vehicle_data.dart';
import 'package:deart/services/auth_service.dart';
import 'package:deart/utils/api_utils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:deart/globals.dart';
import 'package:deart/models/vehicle.dart';

class TeslaAPI extends GetxService {
  final String baseURL = Constants.baseURL;

  Future<List<Vehicle>?> getVehicles() async {
    String apiName = 'api/1/vehicles';
    Uri uri = _getUriByAPIName(apiName);

    http.Response response = await http.get(
      uri,
      headers: _initHeaders(),
    );

    if (response.statusCode == 200) {
      List<Vehicle> vehicles = parseResponse(response, Vehicle.fromJsonList);
      return vehicles;
    } else if (response.statusCode == 401) {
      await Get.find<AuthService>().refreshToken();
      return getVehicles();
    } else {
      return null;
    }
  }

  Future<bool> wakeUp({int currentTryCount = 0}) async {
    String apiName = 'api/1/vehicles/${Globals.vehicleId}/wake_up';

    Get.find<VehicleController>().setIsOnline(false);

    Uri uri = _getUriByAPIName(apiName);

    http.Response response = await http.post(uri, headers: _initHeaders());

    if (response.statusCode == 200) {
      Get.find<VehicleController>().setIsOnline(false);

      Vehicle vehicle = parseResponse(response, Vehicle.fromJson);
      if (vehicle.state == "online") {
        return true;
      } else {
        currentTryCount++;
        if (currentTryCount < 10) {
          return await Future.delayed(
            const Duration(seconds: 10),
            () async => await wakeUp(currentTryCount: currentTryCount),
          );
        } else {
          return false;
        }
      }
    } else if (response.statusCode == 401) {
      await Get.find<AuthService>().refreshToken();
      return wakeUp();
    } else {
      return false;
    }
  }

  Future<bool> toggleSentry(bool setOn) async {
    String apiName =
        'api/1/vehicles/${Globals.vehicleId}/command/set_sentry_mode';

    Uri uri = _getUriByAPIName(apiName);

    http.Response response = await http
        .post(uri, headers: _initHeaders(), body: {'on': setOn.toString()});

    if (response.statusCode == 200) {
      CommandResult commandResult =
          parseResponse(response, CommandResult.fromJson);
      return commandResult.result;
    } else if (response.statusCode == 408) {
      if (await wakeUp()) {
        return toggleSentry(setOn);
      } else {
        return false;
      }
    } else if (response.statusCode == 401) {
      await Get.find<AuthService>().refreshToken();
      return toggleSentry(setOn);
    } else {
      return false;
    }
  }

  Future<ChargeState?> chargeState() async {
    String apiName =
        'api/1/vehicles/${Globals.vehicleId}/data_request/charge_state';

    Uri uri = _getUriByAPIName(apiName);

    http.Response response = await http.get(
      uri,
      headers: _initHeaders(),
    );

    if (response.statusCode == 200) {
      ChargeState chargeState = parseResponse(response, ChargeState.fromJson);
      return chargeState;
    } else if (response.statusCode == 408) {
      if (await wakeUp()) {
        return chargeState();
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<VehicleData?> vehicleData() async {
    String apiName = 'api/1/vehicles/${Globals.vehicleId}/vehicle_data';

    Uri uri = _getUriByAPIName(apiName);

    http.Response response = await http.get(
      uri,
      headers: _initHeaders(),
    );

    if (response.statusCode == 200) {
      VehicleData vehicleData = parseResponse(response, VehicleData.fromJson);
      return vehicleData;
    } else if (response.statusCode == 408) {
      if (await wakeUp()) {
        return await vehicleData();
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<bool> horn() async {
    String apiName = 'api/1/vehicles/${Globals.vehicleId}/command/honk_horn';

    Uri uri = _getUriByAPIName(apiName);

    http.Response response = await http.post(uri, headers: _initHeaders());

    return await handleCommandResponse(response, () => horn());
  }

  Future<bool> doorLock(int vehicleId) async {
    String apiName = 'api/1/vehicles/$vehicleId/command/door_lock';

    Uri uri = _getUriByAPIName(apiName);

    http.Response response = await http.post(uri, headers: _initHeaders());

    return await handleCommandResponse(response, () => doorLock(vehicleId));
  }

  Future<bool> doorUnlock(int vehicleId) async {
    String apiName = 'api/1/vehicles/$vehicleId/command/door_unlock';

    Uri uri = _getUriByAPIName(apiName);

    http.Response response = await http.post(uri, headers: _initHeaders());

    return await handleCommandResponse(response, () => doorUnlock(vehicleId));
  }

  Future<bool> openTrunk(int vehicleId) async {
    String apiName = 'api/1/vehicles/$vehicleId/command/actuate_trunk';

    Uri uri = _getUriByAPIName(apiName);

    http.Response response = await http
        .post(uri, headers: _initHeaders(), body: {'which_trunk': 'rear'});

    if (response.statusCode == 200) {
      CommandResult commandResult =
          parseResponse(response, CommandResult.fromJson);
      return commandResult.result;
    } else if (response.statusCode == 408) {
      if (await wakeUp()) {
        return await openTrunk(vehicleId);
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> openFrunk(int vehicleId) async {
    String apiName = 'api/1/vehicles/$vehicleId/command/actuate_trunk';

    Uri uri = _getUriByAPIName(apiName);

    http.Response response = await http
        .post(uri, headers: _initHeaders(), body: {'which_trunk': 'front'});

    if (response.statusCode == 200) {
      CommandResult commandResult =
          parseResponse(response, CommandResult.fromJson);
      return commandResult.result;
    } else if (response.statusCode == 408) {
      if (await wakeUp()) {
        return await openFrunk(vehicleId);
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> flashLights() async {
    String apiName = 'api/1/vehicles/${Globals.vehicleId}/command/flash_lights';

    Uri uri = _getUriByAPIName(apiName);

    http.Response response = await http.post(uri, headers: _initHeaders());

    if (response.statusCode == 200) {
      CommandResult commandResult =
          parseResponse(response, CommandResult.fromJson);
      return commandResult.result;
    } else if (response.statusCode == 408) {
      if (await wakeUp()) {
        return flashLights();
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  //#region Charging
  Future<bool> openChargePort(int vehicleId) async {
    String apiName = 'api/1/vehicles/$vehicleId/command/charge_port_door_open';

    Uri uri = _getUriByAPIName(apiName);

    http.Response response = await http.post(
      uri,
      headers: _initHeaders(),
    );

    if (response.statusCode == 200) {
      CommandResult commandResult =
          parseResponse(response, CommandResult.fromJson);
      return commandResult.result;
    } else if (response.statusCode == 408) {
      if (await wakeUp()) {
        return await openChargePort(vehicleId);
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> closeChargePort(int vehicleId) async {
    String apiName = 'api/1/vehicles/$vehicleId/command/charge_port_door_close';

    Uri uri = _getUriByAPIName(apiName);

    http.Response response = await http.post(
      uri,
      headers: _initHeaders(),
    );

    if (response.statusCode == 200) {
      CommandResult commandResult =
          parseResponse(response, CommandResult.fromJson);
      return commandResult.result;
    } else if (response.statusCode == 408) {
      if (await wakeUp()) {
        return await closeChargePort(vehicleId);
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> startCharging(int vehicleId) async {
    String apiName = 'api/1/vehicles/$vehicleId/command/charge_start';

    Uri uri = _getUriByAPIName(apiName);

    http.Response response = await http.post(
      uri,
      headers: _initHeaders(),
    );

    return await handleCommandResponse(
        response, () => startCharging(vehicleId));
  }

  Future<bool> stopCharging(int vehicleId) async {
    String apiName = 'api/1/vehicles/$vehicleId/command/charge_stop';

    Uri uri = _getUriByAPIName(apiName);

    http.Response response = await http.post(
      uri,
      headers: _initHeaders(),
    );

    return await handleCommandResponse(response, () => stopCharging(vehicleId));
  }

  Future<bool> unlockCharger(int vehicleId) async {
    String apiName = 'api/1/vehicles/$vehicleId/command/charge_port_door_open';

    Uri uri = _getUriByAPIName(apiName);

    http.Response response = await http.post(
      uri,
      headers: _initHeaders(),
    );

    return await handleCommandResponse(
        response, () => unlockCharger(vehicleId));
  }
  //#endregion

  //#region Climate

  Future<bool> setACTemperature(int vehicleId, double temperature) async {
    String apiName = 'api/1/vehicles/$vehicleId/command/set_temps';

    Uri uri = _getUriByAPIName(apiName);

    http.Response response =
        await http.post(uri, headers: _initHeaders(), body: {
      'driver_temp': temperature.toString(),
      'passenger_temp': temperature.toString(),
    });

    return await handleCommandResponse(
        response, () => setACTemperature(vehicleId, temperature));
  }

  Future<bool> acStart(int vehicleId) async {
    String apiName =
        'api/1/vehicles/$vehicleId/command/auto_conditioning_start';

    Uri uri = _getUriByAPIName(apiName);

    http.Response response = await http.post(
      uri,
      headers: _initHeaders(),
    );

    return await handleCommandResponse(
      response,
      () => acStart(
        vehicleId,
      ),
    );
  }

  Future<bool> acStop(int vehicleId) async {
    String apiName = 'api/1/vehicles/$vehicleId/command/auto_conditioning_stop';

    Uri uri = _getUriByAPIName(apiName);

    http.Response response = await http.post(
      uri,
      headers: _initHeaders(),
    );

    return await handleCommandResponse(
      response,
      () => acStop(
        vehicleId,
      ),
    );
  }

  Future<bool> toggleSeatHeater(
      int vehicleId, int seatNumber, int level) async {
    // Seats:
    // 0 - Front Left
    // 1 - Front right
    // 2 - Rear left
    // 4 - Rear center
    // 5 - Rear right
    String apiName =
        'api/1/vehicles/$vehicleId/command/remote_seat_heater_request';

    Uri uri = _getUriByAPIName(apiName);

    http.Response response = await http.post(
      uri,
      headers: _initHeaders(),
      body: {
        'heater': seatNumber.toString(),
        'level': level.toString(),
      },
    );

    return await handleCommandResponse(
      response,
      () => toggleSeatHeater(
        vehicleId,
        seatNumber,
        level,
      ),
    );
  }

  Future<bool> toggleSteeringWheelHeater(int vehicleId, bool setOn) async {
    String apiName =
        'api/1/vehicles/$vehicleId/command/remote_steering_wheel_heater_request';

    Uri uri = _getUriByAPIName(apiName);

    http.Response response = await http.post(
      uri,
      headers: _initHeaders(),
      body: {
        'on': setOn.toString(),
      },
    );

    return await handleCommandResponse(
      response,
      () => toggleSteeringWheelHeater(
        vehicleId,
        setOn,
      ),
    );
  }

  Future<bool> ventWindows(int vehicleId) async {
    String apiName = 'api/1/vehicles/$vehicleId/command/window_control';

    Uri uri = _getUriByAPIName(apiName);

    http.Response response = await http.post(
      uri,
      headers: _initHeaders(),
      body: {
        'command': 'vent',
        'lon': 0.toString(),
        'lat': 0.toString(),
      },
    );

    return await handleCommandResponse(
      response,
      () => ventWindows(
        vehicleId,
      ),
    );
  }

  Future<bool> closeWindows(
      int vehicleId, double longitude, double latitude) async {
    String apiName = 'api/1/vehicles/$vehicleId/command/window_control';

    Uri uri = _getUriByAPIName(apiName);

    http.Response response = await http.post(
      uri,
      headers: _initHeaders(),
      body: {
        'command': 'close',
        'lon': longitude.toString(),
        'lat': latitude.toString(),
      },
    );

    return await handleCommandResponse(
      response,
      () => closeWindows(
        vehicleId,
        longitude,
        latitude,
      ),
    );
  }
  //#endregion

  Future<bool> handleCommandResponse(
    http.Response response,
    Future<bool> Function() retryFunction,
  ) async {
    if (response.statusCode == 200) {
      CommandResult commandResult =
          parseResponse(response, CommandResult.fromJson);
      return commandResult.result;
    } else if (response.statusCode == 408) {
      if (await wakeUp()) {
        return await retryFunction();
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Map<String, String> _initHeaders() {
    Map<String, String> headers = {};

    headers.putIfAbsent(
        'Authorization', () => 'Bearer ${Globals.apiAccessToken!}');
    headers.putIfAbsent('User-Agent', () => 'DearT/1.0.0');

    return headers;
  }

  Uri _getUriByAPIName(String apiName) {
    return Uri.parse('$baseURL/$apiName');
  }
}
