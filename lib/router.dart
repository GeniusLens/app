import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:genius_lens/pages/community/community_page.dart';
import 'package:genius_lens/pages/community/detail_page.dart';
import 'package:genius_lens/pages/user_model/model_manage_page.dart';
import 'package:genius_lens/pages/detail/detail_page.dart';
import 'package:genius_lens/pages/favorite/favorite_page.dart';
import 'package:genius_lens/pages/function/function_page.dart';
import 'package:genius_lens/pages/profile/profile_page.dart';
import 'package:get/get.dart';

class AppRouter {
  /// Static route names
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';

  static const String mainPage = '/main';
  static const String modelManagePage = '/manage';
  static const String favoritePage = '/favorite';
  static const String communityPage = '/community';
  static const String communityDetailPage = '/community/detail';
  static const String profilePage = '/profile';
  static const String functionPage = '/function';
  static const String detailPage = '/detail';

  /// Route map for build a page with route name
  static Map<String, Widget Function(BuildContext)> routes = {
    home: (context) => const Text('Home'),
    login: (context) => const Text('Login'),
    register: (context) => const Text('Register'),
    mainPage: (context) => const Text('Main'),
    modelManagePage: (context) => const ModelManagePage(),
    favoritePage: (context) => const FavoritePage(),
    communityPage: (context) => const CommunityPage(),
    communityDetailPage: (context) => const CommunityDetailPage(),
    profilePage: (context) => const ProfilePage(),
    functionPage: (context) => const FunctionPage(),
    detailPage: (context) => const DetailPage(),
  };

  /// Generate route for not found page
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (routes.containsKey(settings.name)) {
      return MaterialPageRoute(
          builder: (context) => routes[settings.name]!(context));
    }
    return MaterialPageRoute(
      builder: (context) => const NotFoundPage(),
    );
  }
}

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('页面不存在'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              width: 256,
              height: 256,
              image: ExtendedImage.asset(
                'assets/gifs/404.gif',
                fit: BoxFit.fill,
              ).image,
            ),
            const SizedBox(height: 24),
            const Text('页面不见了，快去找找吧~', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
