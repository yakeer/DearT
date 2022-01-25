import 'package:deart/screens/home.dart';
import 'package:deart/screens/login.dart';
import 'package:deart/screens/settings.dart';
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
    name: '/settings',
    page: () => const SettingsScreen(),
  )
];
