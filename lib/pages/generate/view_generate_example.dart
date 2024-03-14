import 'package:card_swiper/card_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:genius_lens/data/entity/generate.dart';
import 'package:genius_lens/router.dart';
import 'package:get/get.dart';

class ViewGenerateExamplePage extends StatefulWidget {
  const ViewGenerateExamplePage({super.key});

  @override
  State<ViewGenerateExamplePage> createState() =>
      _ViewGenerateExamplePageState();
}

class _ViewGenerateExamplePageState extends State<ViewGenerateExamplePage> {
  late final FunctionVO function;
  late final SwiperController _swiperCtrl;
  final List<String> _images = [];

  bool _showFab = false;

  @override
  void initState() {
    super.initState();
    function = Get.arguments as FunctionVO;
    print(function);
    // 将图片地址添加到_images中
    if (function.url == null) {
      return;
    } else {
      setState(() {
        if (function.url!.contains(',')) {
          _images.addAll(function.url!.split(','));
        } else {
          _images.add(function.url!);
        }
      });
    }
    print(_images);

    _swiperCtrl = SwiperController();

    // if (function.type == 'scene') {
    //   _showFab = true;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '选择示例',
          style: TextStyle(color: context.theme.primaryColor, fontSize: 20),
        ),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          GestureDetector(
            onTap: () {
              var route = '';
              switch (function.type) {
                case 'solo' || 'video_solo':
                  route = AppRouter.soloGeneratePage;
                  break;
                case 'multi':
                  route = AppRouter.multiGeneratePage;
                  break;
                case 'scene' || 'video_scene':
                  route = AppRouter.soloGeneratePage;
                  break;
                default:
                  EasyLoading.showError('未知的生成类型');
              }
              // 将function的url修改为当前图片的url
              Get.toNamed(
                route,
                arguments: function.copyWith(url: _images[_swiperCtrl.index]),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.primaryColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: const EdgeInsets.only(right: 16),
              child: const Text(
                '一键生成',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
      body: Column(children: [
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 16),
        //   child: Row(
        //     children: [
        //       const Spacer(),
        //       Text(
        //         '选择图片',
        //         style: TextStyle(
        //           color: context.theme.primaryColor,
        //           fontSize: 16,
        //         ),
        //       ),
        //       const Spacer(),
        //     ],
        //   ),
        // ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 32),
                  child: ExtendedImage.network(
                    _images[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
              loop: false,
              itemCount: _images.length,
              controller: _swiperCtrl,
              pagination: SwiperPagination(
                margin: const EdgeInsets.only(bottom: 4),
                builder: DotSwiperPaginationBuilder(
                  color: Colors.black12,
                  activeColor: context.theme.primaryColor,
                ),
              ),
              onIndexChanged: (index) {
                _swiperCtrl.move(index);
              },
              control: SwiperControl(
                color: context.theme.primaryColor,
                size: 24,
                padding: const EdgeInsets.all(8),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 128,
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: 96,
                height: 96,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.theme.cardColor,
                ),
                child: CircleAvatar(
                  radius: 48,
                  backgroundImage: ExtendedImage.network(
                    _images[index],
                    height: 96,
                    width: 96,
                    fit: BoxFit.cover,
                    cache: true,
                    loadStateChanged: (state) {
                      if (state.extendedImageLoadState == LoadState.loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state.extendedImageLoadState ==
                          LoadState.failed) {
                        return const Center(
                          child: Icon(Icons.error),
                        );
                      }
                      return null;
                    },
                  ).image,
                ),
              );
            },
            onIndexChanged: (index) {
              _swiperCtrl.move(index);
            },
            loop: false,
            viewportFraction: 0.3,
            itemCount: _images.length,
            controller: _swiperCtrl,
          ),
        )
      ]),
      floatingActionButton: _showFab
          ? FloatingActionButton(
              onPressed: () {
                EasyLoading.showError('点击此处上传自定义图片');
              },
              backgroundColor: context.theme.primaryColor,
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
