import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:genius_lens/pages/common/image_preview_page.dart';
import 'package:genius_lens/pages/community/community_page.dart';
import 'package:genius_lens/pages/community/detail_page.dart';
import 'package:genius_lens/pages/entrance/model_create_page.dart';
import 'package:genius_lens/pages/generate/anime_generate_page.dart';
import 'package:genius_lens/pages/generate/generate_result_page.dart';
import 'package:genius_lens/pages/generate/model_select_page.dart';
import 'package:genius_lens/pages/generate/multi_generate_page.dart';
import 'package:genius_lens/pages/generate/solo_generate_page.dart';
import 'package:genius_lens/pages/generate/try_on_generate_page.dart';
import 'package:genius_lens/pages/generate/video_generate_page.dart';
import 'package:genius_lens/pages/generate/view_generate_example.dart';
import 'package:genius_lens/pages/generate/wear_evaluation_page.dart';
import 'package:genius_lens/pages/index.dart';
import 'package:genius_lens/pages/login/login_page.dart';
import 'package:genius_lens/pages/message/message_page.dart';
import 'package:genius_lens/pages/profile/about_page.dart';
import 'package:genius_lens/pages/profile/follower_list_page.dart';
import 'package:genius_lens/pages/profile/help_page.dart';
import 'package:genius_lens/pages/profile/manage_model_page.dart';
import 'package:genius_lens/pages/profile/manage_task_page.dart';
import 'package:genius_lens/pages/profile/settings_page.dart';
import 'package:genius_lens/pages/detail/detail_page.dart';
import 'package:genius_lens/pages/function/function_page.dart';
import 'package:genius_lens/pages/profile/profile_page.dart';
import 'package:get/get.dart';

class AppRouter {
  /// Static route names
  static const String root = '/';
  static const String login = '/login';
  static const String register = '/register';

  static const String mainPage = '/main';
  static const String imagePreviewPage = '/image/preview';

  static const String modelCreatePage = '/model/create';
  static const String selectModelPage = '/model/select';

  static const String viewGenerateExamplePage = '/generate/view';
  static const String soloGeneratePage = '/generate/solo';
  static const String multiGeneratePage = '/generate/multi';
  static const String videoGeneratePage = '/generate/video';
  static const String wearEvaluatePage = '/generate/wear';
  static const String tryOnGeneratePage = '/generate/tryon';
  static const String animeGeneratePage = '/generate/anime';
  static const String generateResultPage = '/generate/result';

  static const String favoritePage = '/favorite';
  static const String communityPage = '/community';
  static const String communityDetailPage = '/community/detail';

  static const String profilePage = '/profile';
  static const String followerListPage = '/follower';
  static const String manageModelPage = '/manage';
  static const String manageTaskPage = '/manage/task';
  static const String functionPage = '/function';
  static const String detailPage = '/detail';
  static const String settingPage = '/setting';
  static const String helpPage = '/help';
  static const String messagePage = '/message';
  static const String aboutPage = '/about';

  /// Route map for build a page with route name
  static Map<String, Widget Function()> routes = {
    root: () => const IndexPage(),
    login: () => const LoginPage(),
    register: () => const Text('Register'),
    mainPage: () => const Text('Main'),
    imagePreviewPage: () => const ImagePreviewPage(),
    modelCreatePage: () => const ModelCreatePage(),
    selectModelPage: () => const ModelSelectPage(),
    viewGenerateExamplePage: () => const ViewGenerateExamplePage(),
    soloGeneratePage: () => const SoloGeneratePage(),
    animeGeneratePage: () => const AnimeGeneratePage(),
    multiGeneratePage: () => const MultiGeneratePage(),
    videoGeneratePage: () => const VideoGeneratePage(),
    wearEvaluatePage: () => const WearEvaluationPage(),
    tryOnGeneratePage: () => const TryOnGeneratePage(),
    generateResultPage: () => const GenerateResultPage(),
    manageTaskPage: () => const ManageTaskPage(),
    communityPage: () => const CommunityPage(),
    communityDetailPage: () => const CommunityDetailPage(),
    profilePage: () => const ProfilePage(),
    settingPage: () => const SettingPage(),
    followerListPage: () => const FollowerListPage(),
    manageModelPage: () => const ManageModelPage(),
    functionPage: () => const FunctionPage(),
    detailPage: () => const DetailPage(),
    helpPage: () => const HelpPage(),
    messagePage: () => const MessagePage(),
    aboutPage: () => const AboutPage(),
  };

  /// Generate route for not found page
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    String name = settings.name!;
    // 除去参数
    if (name.contains('?')) {
      name = name.substring(0, name.indexOf('?'));
    }
    if (routes.containsKey(name)) {
      return GetPageRoute(
        settings: settings,
        page: routes[name]!,
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 300),
      );
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
