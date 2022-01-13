import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:deart/constants.dart';
import 'package:deart/globals.dart';
import 'package:deart/models/internal/login_page_data.dart';
import 'package:deart/models/refresh_token_response.dart';
import 'package:deart/screens/login.dart';
import 'package:deart/utils/api_utils.dart';
import 'package:deart/utils/storage_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void login(BuildContext context, String username, String password) async {
  LoginPageData? loginPageData = await getLoginPage(username);

  await showModalBottomSheet(
    context: context,
    builder: (context) => LoginWebView(loginPageData!),
    useRootNavigator: true,
  );

  loginPageData = await exchangeAuthorizationCodeForBearerToken(loginPageData!);

  loginPageData = await exchangeBearerTokenForAccessToken(loginPageData);
}

Future<LoginPageData?> getLoginPage(String username) async {
  LoginPageData result = LoginPageData();

  String apiName = "oauth2/v3/authorize";

  String codeVerifier = getRandomString(86);
  result.codeVerifier = codeVerifier;

  String codeChallenge = createCodeChallenge(codeVerifier);
  result.codeChallenge = codeChallenge;

  String state = getRandomString(24);

  Map<String, String> parameters = {
    "client_id": Constants.teslaAPIClientID,
    "code_challenge": codeChallenge,
    "code_challenge_method": "S256",
    "redirect_uri": "https://auth.tesla.com/void/callback",
    "response_type": "code",
    "state": state,
    "scope": Constants.teslaAuthScopes,
  };

  result.parameters = parameters;

  result.loginUrl = _getUriByAPIName(apiName, parameters: parameters);

  return result;
}

Future<LoginPageData> exchangeAuthorizationCodeForBearerToken(
    LoginPageData loginPageData) async {
  String apiName = "oauth2/v3/token";

  Map<String, String> requestBody = {
    "grant_type": "authorization_code",
    "client_id": Constants.teslaAPIClientID,
    "code": loginPageData.authorizationCode,
    "code_verifier": loginPageData.codeVerifier,
    "redirect_uri": "https://auth.tesla.com/void/callback",
  };

  Uri uri = _getUriByAPIName(apiName);

  http.Response response = await http.post(
    uri,
    body: requestBody,
  );

  if (response.statusCode == 200) {
    RefreshTokenResponse tokenResponse =
        parseAuthResponse(response, RefreshTokenResponse.fromJson);

    loginPageData.bearerToken = tokenResponse.accessToken!;
    loginPageData.refreshToken = tokenResponse.refreshToken!;
  }

  return loginPageData;
}

Future<LoginPageData> exchangeBearerTokenForAccessToken(
    LoginPageData loginPageData) async {
  String apiName = "oauth/token";

  String clientId =
      "81527cff06843c8634fdc09e8ac0abefb46ac849f38fe1e431c2ef2106796384";
  String clientSecret =
      "c7257eb71a564034f9419ee651c7d0e5f7aa6bfbd18bafb5c5c033b093bb2fa3";

  Map<String, String> requestBody = {
    "grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
    "client_id": clientId,
    "client_secret": clientSecret,
  };

  Uri uri = _getOwnerUriByAPIName(apiName);

  http.Response response = await http.post(
    uri,
    headers: {
      "Authorization": "Bearer ${loginPageData.bearerToken}",
    },
    body: requestBody,
  );

  if (response.statusCode == 200) {
    RefreshTokenResponse tokenResponse =
        parseAuthResponse(response, RefreshTokenResponse.fromJson);

    loginPageData.accessToken = tokenResponse.accessToken!;
    Globals.apiAccessToken = loginPageData.accessToken;
    Globals.apiRefreshToken = loginPageData.refreshToken;

    writeStorageKey('refreshToken', Globals.apiRefreshToken!);

    await refreshToken();
  }

  return loginPageData;
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

String createCodeChallenge(String codeVerifier) {
  //code_challenge = Base64.urlsafe_encode64(Digest::SHA256.hexdigest(code_verifier))

  // hash the password
  List<int> bytes = utf8.encode(codeVerifier);
  Digest digest = sha256.convert(bytes);

  // different formats
  String codeChallenge = base64UrlEncode(digest.bytes);

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

Uri _getUriByAPIName(String apiName, {Map<String, String>? parameters}) {
  String url = '${Constants.authBaseURL}/$apiName';

  if (parameters != null) {
    url += '?';
    parameters.forEach((key, value) {
      url += '$key=$value&';
    });
  }

  return Uri.parse(url);
}

Uri _getOwnerUriByAPIName(String apiName, {Map<String, String>? parameters}) {
  String url = '${Constants.baseURL}/$apiName';

  if (parameters != null) {
    url += '?';
    parameters.forEach((key, value) {
      url += '$key=$value&';
    });
  }

  return Uri.parse(url);
}
