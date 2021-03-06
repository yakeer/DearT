import 'package:deart/routing.dart';
import 'package:deart/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DearT',
      theme: Themes.dark,
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      getPages: appPages, // Routing
      locale: const Locale('en'),
    );
  }
}
