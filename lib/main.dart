import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genius_lens/pages/index.dart';
import 'package:genius_lens/router.dart';
import 'package:genius_lens/utils/package_util.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  if (Platform.isAndroid) {
    SystemUiOverlayStyle style = const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light);
    SystemChrome.setSystemUIOverlayStyle(style);
  }
  runApp(const MyApp());
  await PackageUtil().initialize();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData lightTheme() {
    var base = ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF836D)));

    base = base.copyWith(
      primaryColor: const Color(0xFFFF836D),
      scaffoldBackgroundColor: const Color(0xfff6f6f6),
      cardColor: Colors.white,
    );

    return base;
  }

  ThemeData darkTheme() {
    var base = ThemeData.dark();

    return base;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '创艺相机',
      theme: lightTheme(),
      darkTheme: darkTheme(),
      onGenerateRoute: AppRouter.onGenerateRoute,
      debugShowCheckedModeBanner: false,
      home: const IndexPage(),
    );
  }
}
