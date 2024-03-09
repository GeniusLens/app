import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:genius_lens/provider/community_provider.dart';
import 'package:genius_lens/provider/user_provider.dart';
import 'package:genius_lens/router.dart';
import 'package:genius_lens/utils/package_util.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

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
  EasyLoading.instance.loadingStyle = EasyLoadingStyle.light;
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => CommunityProvider()),
      ],
      child: GetMaterialApp(
        title: '创艺相机',
        theme: lightTheme(),
        darkTheme: darkTheme(),
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRouter.root,
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        // home: const IndexPage(),
      ),
    );
  }
}
