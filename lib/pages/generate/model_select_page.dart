import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:genius_lens/api/request/common.dart';
import 'package:genius_lens/router.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../api/request/generate.dart';
import '../../data/entity/generate.dart';

class ModelSelectPage extends StatefulWidget {
  const ModelSelectPage({super.key});

  @override
  State<ModelSelectPage> createState() => _ModelSelectPageState();
}

class _ModelSelectPageState extends State<ModelSelectPage> {
  late final CategoryVO category;
  final List<FunctionVO> _functions = [];
  String? _uploadedImage;

  Future<void> _loadFunctions() async {
    var list = await GenerateApi.getFunctionList(category.name);
    setState(() {
      _functions.clear();
      _functions.addAll(list);
    });
  }

  @override
  void initState() {
    super.initState();
    category = Get.arguments as CategoryVO;
    _loadFunctions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          GestureDetector(
            onTap: () async {
              // 选择图片
              var image =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (image == null) return;
              EasyLoading.show(status: '上传中...');
              var result = await CommonAPi.uploadFile(image.path);
              if (result != null) {
                setState(() {
                  _uploadedImage = result;
                });
                EasyLoading.dismiss();
                FunctionVO function = FunctionVO.custom(result);
                Get.toNamed(AppRouter.soloGeneratePage, arguments: function);
              } else {
                EasyLoading.showError('上传失败');
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.only(right: 8),
              // alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.theme.primaryColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: const Text('自定义', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: _functions.isNotEmpty
            ? AnimationLimiter(
                child: GridView.count(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  children: _functions
                      .map(
                        (e) => AnimationConfiguration.staggeredGrid(
                          position: _functions.indexOf(e),
                          columnCount: 2,
                          delay: const Duration(milliseconds: 50),
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: _ModelItem(function: e),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              )
            : Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: context.theme.primaryColor,
                  size: 36,
                ),
              ),
      ),
    );
  }
}

class _ModelItem extends StatelessWidget {
  const _ModelItem({required this.function});

  final FunctionVO function;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              // height: 256,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                image: DecorationImage(
                  image: ExtendedImage.network(
                    (function.url?.contains(',') ?? false)
                        ? function.url!.split(',')[0]
                        : function.url!,
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
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    function.name ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    switch (function.type) {
                      case 'solo' || 'video_solo':
                        Get.toNamed(AppRouter.viewGenerateExamplePage,
                            arguments: function);
                        break;
                      case 'multi':
                        Get.toNamed(AppRouter.viewGenerateExamplePage,
                            arguments: function);
                        break;
                      case 'scene' || 'video_scene':
                        Get.toNamed(AppRouter.viewGenerateExamplePage,
                            arguments: function);
                      case 'anime':
                        Get.toNamed(AppRouter.animeGeneratePage,
                            arguments: function);
                        break;
                      default:
                        EasyLoading.showError('未知的模型类型');
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '使用',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
