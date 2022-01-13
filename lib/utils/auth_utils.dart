import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

void login() async {
  FlutterAppAuth appAuth = FlutterAppAuth();

  String authEndpoint = "https://auth.tesla.com/oauth2/v3/authorize";
  String tokenEndpoint = "https://auth.tesla.com/oauth2/v3/token";
  String redirectUrl = 'deart.app:/oauthredirect';
  // String redirectUrl = 'https://auth.tesla.com/void/callback';

  // TODO CHECK IF CORRECT
  String endSessionEndpoint = "https://auth.tesla.com/oauth2/v3/signout";

  String codeVerifier = getRandomString(86);

  // hash the password
  var bytes = utf8.encode(codeVerifier);
  var digest = sha256.convert(bytes);

  // different formats
  var codeChallenge = digest.toString();

  Map<String, String> additionalParams = {};
  // additionalParams.putIfAbsent('code_challenge', () => codeChallenge);
  // additionalParams.putIfAbsent('code_challenge_method', () => 'S256');
  // additionalParams.putIfAbsent('response_type', () => 'code');
  // additionalParams.putIfAbsent('state', () => getRandomString(5));

  var request = AuthorizationTokenRequest(
    'ownerapi',
    '',
    serviceConfiguration: AuthorizationServiceConfiguration(
      authorizationEndpoint: authEndpoint,
      tokenEndpoint: tokenEndpoint,
    ),
    scopes: ['openid', 'email', 'offline_access'],
    // additionalParameters: additionalParams,
    preferEphemeralSession: true,
  );

  final AuthorizationTokenResponse? result =
      await appAuth.authorizeAndExchangeCode(
    request,
  );

  print(result);
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
