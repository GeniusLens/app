import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genius_lens/pages/index.dart';
import 'package:genius_lens/router.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());

  if(Platform.isAndroid){
    SystemUiOverlayStyle style = const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light
    );
    SystemChrome.setSystemUIOverlayStyle(style);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData lightTheme() {
    var base = ThemeData.light();

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
