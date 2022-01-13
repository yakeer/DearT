import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:deart/constants.dart';
import 'package:deart/globals.dart';
import 'package:deart/models/internal/login_page_data.dart';
import 'package:deart/models/refresh_token_response.dart';
import 'package:deart/utils/api_utils.dart';
import 'package:deart/utils/storage_utils.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

Future<LoginPageData?> getLoginPage(String username) async {
  String apiName = "oauth2/v3/authorize";

  String codeChallenge = createCodeChallenge();
  String state = getRandomString(10);

  Map<String, String> parameters = {
    "client_id": Constants.teslaAPIClientID,
    "code_challenge": codeChallenge,
    "code_challenge_method": "S256",
    "redirect_uri": "https://auth.tesla.com/void/callback",
    "response_type": "code",
    "state": state,
    "scope": Constants.teslaAuthScopes,
    "locale": "en",
    "prompt": "login",
  };

  Uri uri = _getUriByAPIName(apiName, parameters: parameters);
  http.Response response = await http.get(uri, headers: {
    'User-Agent': "Deart",
    'X-Requested-With': 'com.capitan.deart',
    "x-tesla-user-agent": 'Deart'
  });

  if (response.statusCode == 200) {
    LoginPageData result = LoginPageData();
    result.cookie = response.headers['set-cookie']!;
    result.codeChallenge = codeChallenge;
    result.parameters = parameters;

    // Parse html for hidden inputs.
    String loginHtml = utf8.decode(response.bodyBytes);

    Document loginPage = parse(loginHtml);

    Map<String, String> hiddenInputs = {};

    loginPage.getElementsByTagName('input[type=hidden]').forEach(
      (element) {
        hiddenInputs.putIfAbsent(
          element.attributes['name']!,
          () => element.attributes['value']!,
        );
      },
    );

    result.hiddenInputs = hiddenInputs;

    return result;
  }
}

Future<LoginPageData> obtainAuthorizationCode(
  LoginPageData loginPageData,
  String username,
  String password,
) async {
  String apiName = "oauth2/v3/authorize";

  // loginPageData.parameters['state'] = getRandomString(10);

  Uri uri = _getUriByAPIName(apiName, parameters: loginPageData.parameters);

  Map<String, String> formData = {
    "identity": username,
    "credential": password,
  };

  loginPageData.hiddenInputs.forEach((key, value) {
    formData.putIfAbsent(key, () => value);
  });

  http.Response response = await http.post(uri,
      headers: {
        "Cookie": loginPageData.cookie,
        "Content-Type": "application/x-www-form-urlencoded",
        'User-Agent': "Deart",
        'X-Requested-With': 'com.capitan.deart',
        "x-tesla-user-agent": 'Deart'
        // 'Accept': "*/*",
        // 'accept-encoding': "deflate"
      },
      body: formData,
      encoding: Encoding.getByName('utf-8'));

  if (response.statusCode == 302) {
    String location = response.headers["location"]!;

    Uri redirectLocation = Uri.parse(location);

    String code = redirectLocation.queryParameters['redirect_uri']!;

    loginPageData.authorizationCode = code;
  } else if (response.statusCode == 403) {
    String responseError = utf8.decode(response.bodyBytes);
    print(responseError);
  }

  return loginPageData;
}

void login(String username, String password) async {
  LoginPageData? loginPageData = await getLoginPage(username);
  if (loginPageData != null) {
    loginPageData = await obtainAuthorizationCode(
      loginPageData,
      username,
      password,
    );
  }
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

  // code_verifier = random_string(86)
  //code_challenge = Base64.urlsafe_encode64(Digest::SHA256.hexdigest(code_verifier))

  // hash the password
  var bytes = utf8.encode(codeVerifier);
  var digest = sha256.convert(bytes);

  // different formats
  // var codeChallenge = digest.toString();

  var codeChallenge = base64Url.encode(digest.bytes);

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
  String url = '${Globals.authBaseURL}/$apiName';

  if (parameters != null) {
    url += '?';
    parameters.forEach((key, value) {
      url += '$key=$value&';
    });
  }

  return Uri.parse(url);
}
