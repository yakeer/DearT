import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:deart/constants.dart';
import 'package:deart/globals.dart';
import 'package:deart/models/refresh_token_response.dart';
import 'package:deart/utils/api_utils.dart';
import 'package:deart/utils/storage_utils.dart';
import 'package:http/http.dart' as http;

void login() async {
//   FlutterAppAuth appAuth = FlutterAppAuth();

//   String authEndpoint = "https://auth.tesla.com/oauth2/v3/authorize";
//   String tokenEndpoint = "https://auth.tesla.com/oauth2/v3/token";
//   String redirectUrl = 'deart.app:/oauthredirect';
//   // String redirectUrl = 'https://auth.tesla.com/void/callback';

//   // CHECK IF CORRECT
//   String endSessionEndpoint = "https://auth.tesla.com/oauth2/v3/signout";

//   String codeVerifier = getRandomString(86);

//   // hash the password
//   var bytes = utf8.encode(codeVerifier);
//   var digest = sha256.convert(bytes);

//   // different formats
//   var codeChallenge = digest.toString();

//   Map<String, String> additionalParams = {};
//   // additionalParams.putIfAbsent('code_challenge', () => codeChallenge);
//   // additionalParams.putIfAbsent('code_challenge_method', () => 'S256');
//   // additionalParams.putIfAbsent('response_type', () => 'code');
//   // additionalParams.putIfAbsent('state', () => getRandomString(5));

//   var request = AuthorizationTokenRequest(
//     'ownerapi',
//     '',
//     serviceConfiguration: AuthorizationServiceConfiguration(
//       authorizationEndpoint: authEndpoint,
//       tokenEndpoint: tokenEndpoint,
//     ),
//     scopes: ['openid', 'email', 'offline_access'],
//     // additionalParameters: additionalParams,
//     preferEphemeralSession: true,
//   );

//   final AuthorizationTokenResponse? result =
//       await appAuth.authorizeAndExchangeCode(
//     request,
//   );

//   print(result);
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

String createCodeChallenge() {
  String codeVerifier = getRandomString(86);

  // hash the password
  var bytes = utf8.encode(codeVerifier);
  var digest = sha256.convert(bytes);

  // different formats
  var codeChallenge = digest.toString();

  return codeChallenge;
}

Future<String?> refreshToken() async {
  String? refreshToken = await readStorageKey('refreshToken');

  String? accessToken;
  if (refreshToken != null) {
    String apiName = 'oauth2/v3/token';

    Uri uri = _getUriByAPIName(apiName);

    http.Response response = await http.post(
      uri,
      body: {
        "client_id": Constants.teslaAPIClientID,
        "grant_type": "refresh_token",
        "refresh_token": refreshToken,
        "scope": Constants.teslaAuthScopes
      },
    );

    if (response.statusCode == 200) {
      RefreshTokenResponse dto = parseAuthResponse<RefreshTokenResponse>(
          response, RefreshTokenResponse.fromJson);

      if (dto.refreshToken != null) {
        Globals.apiRefreshToken = dto.refreshToken;
        writeStorageKey('refreshToken', dto.refreshToken!);
      }

      if (dto.accessToken != null) {
        Globals.apiAccessToken = dto.accessToken;
        writeStorageKey('accessToken', dto.accessToken!);
      }

      if (dto.idToken != null) {
        Globals.apiIdToken = dto.idToken;
        writeStorageKey('idToken', dto.idToken!);
      }

      if (dto.expiresIn != null) {
        DateTime expiryTime =
            DateTime.now().add(Duration(seconds: dto.expiresIn!));

        Globals.apiAccessTokenExpiryTime = expiryTime;

        writeStorageKey(
          'accessTokenExpiryTime',
          expiryTime.toIso8601String(),
        );
      }
    }
  }

  return accessToken;
}

Uri _getUriByAPIName(String apiName) {
  return Uri.parse('${Globals.authBaseURL}/$apiName');
}
