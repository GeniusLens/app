import 'package:card_swiper/card_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(function.name ?? ''),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRouter.soloGeneratePage, arguments: function);
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return ExtendedImage.network(
                  _images[index],
                  fit: BoxFit.fitWidth,
                );
              },
              loop: false,
              itemCount: _images.length,
              controller: _swiperCtrl,
              pagination: const SwiperPagination(
                margin: EdgeInsets.only(bottom: 4),
              ),
              control: const SwiperControl(),
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
            loop: false,
            viewportFraction: (_images.length > 2) ? 0.3 : 1,
            itemCount: _images.length,
            controller: _swiperCtrl,
          ),
        )
      ]),
    );
  }
}
