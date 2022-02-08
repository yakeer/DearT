import 'package:deart/screens/home.dart';
import 'package:deart/screens/login.dart';
import 'package:deart/screens/settings.dart';
import 'package:deart/screens/siri_activities.dart';
import 'package:deart/screens/tesla_logout.dart';
import 'package:deart/screens/token_login.dart';
import 'package:deart/screens/web_socket_screen.dart';
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
    name: '/tesla-logout',
    page: () => const TeslaLogoutScreen(true),
  ),
  GetPage(
    name: '/logout',
    page: () => const TeslaLogoutScreen(false),
  ),
];
