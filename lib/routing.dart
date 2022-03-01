import 'package:deart/screens/settings/diagnostics.dart';
import 'package:deart/screens/main/home.dart';
import 'package:deart/screens/settings/edit_location_screen.dart';
import 'package:deart/screens/settings/excluded_locations.dart';
import 'package:deart/screens/settings/in_app_purchases_screen.dart';
import 'package:deart/screens/auth/login.dart';
import 'package:deart/screens/settings/settings.dart';
import 'package:deart/screens/settings/siri_activities.dart';
import 'package:deart/screens/auth/tesla_logout.dart';
import 'package:deart/screens/auth/token_login.dart';
import 'package:deart/screens/settings/web_socket_screen.dart';
import 'package:deart/screens/welcome.dart';
import 'package:get/get.dart';

var appPages = [
  GetPage(
    name: '/',
    page: () => const WelcomeScreen(),
  ),
  GetPage(
    name: '/home',
    page: () => HomeScreen(),
  ),
  GetPage(
    name: '/login',
    page: () => const LoginScreen(),
  ),
  GetPage(
    name: '/token',
    page: () => const TokenLoginScreen(),
  ),
  GetPage(
    name: '/settings',
    page: () => const SettingsScreen(),
  ),
  GetPage(
    name: '/siri-shortcuts',
    page: () => const SiriActivitiesScreen(),
  ),
  GetPage(
    name: '/stream',
    page: () => const WebSocketScreen(),
  ),
  GetPage(
    name: '/purchases',
    page: () => const InAppPurchasesScreen(),
  ),
  GetPage(
    name: '/excluded-locations',
    page: () => const ExcludedLocationsScreen(),
  ),
  GetPage(
    name: '/edit-location/:id',
    page: () => const EditLocationScreen(),
  ),
  GetPage(
    name: '/diagnostics',
    page: () => const DiagnosticsScreen(),
  ),
  GetPage(
    name: '/tesla-logout',
    page: () => const TeslaLogoutScreen(true),
  ),
  GetPage(
    name: '/logout',
    page: () => const TeslaLogoutScreen(false),
  ),
];
