import 'package:deart/constants.dart';
import 'package:deart/models/charge_state.dart';
import 'package:deart/models/command_result.dart';
import 'package:deart/utils/api_utils.dart';
import 'package:deart/utils/auth_utils.dart';
import 'package:http/http.dart' as http;
import 'package:deart/globals.dart';
import 'package:deart/models/vehicle.dart';

class TeslaAPI {
  final String baseURL = Constants.baseURL;

  Future<Vehicle?> getVehicle() async {
    String apiName = 'api/1/vehicles';
    Uri uri = _getUriByAPIName(apiName);

    http.Response response = await http.get(
      uri,
      headers: _initHeaders(),
    );

    if (response.statusCode == 200) {
      List<Vehicle> vehicles = parseResponse(response, Vehicle.fromJsonList);
      return vehicles.first;
    } else if (response.statusCode == 401) {
      await refreshToken();
      return getVehicle();
    } else {
      return null;
    }
  }

  Future<bool> wakeUp({int currentTryCount = 0}) async {
    String apiName = 'api/1/vehicles/${Globals.vehicleId}/wake_up';

    Uri uri = _getUriByAPIName(apiName);

    http.Response response = await http.post(uri, headers: _initHeaders());

    if (response.statusCode == 200) {
      Vehicle vehicle = parseResponse(response, Vehicle.fromJson);
      if (vehicle.state == "online") {
        return true;
      } else {
        currentTryCount++;
        if (currentTryCount < 10) {
          return Future.delayed(
            const Duration(seconds: 10),
            () => wakeUp(currentTryCount: currentTryCount),
          );
        } else {
          return false;
        }
      }
    } else if (response.statusCode == 401) {
      await refreshToken();
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
      await refreshToken();
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

  Future<bool> horn() async {
    String apiName = 'api/1/vehicles/${Globals.vehicleId}/command/honk_horn';

    Uri uri = _getUriByAPIName(apiName);

    http.Response response = await http.post(uri, headers: _initHeaders());

    if (response.statusCode == 200) {
      CommandResult commandResult =
          parseResponse(response, CommandResult.fromJson);
      return commandResult.result;
    } else if (response.statusCode == 408) {
      if (await wakeUp()) {
        return horn();
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
