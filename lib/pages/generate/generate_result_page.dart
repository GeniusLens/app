import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:genius_lens/data/entity/generate.dart';
import 'package:genius_lens/router.dart';
import 'package:genius_lens/widget/image_save_widget.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class GenerateResultPage extends StatefulWidget {
  const GenerateResultPage({super.key});

  @override
  State<GenerateResultPage> createState() => _GenerateResultPageState();
}

class _GenerateResultPageState extends State<GenerateResultPage> {
  late final TaskVO _task;

  @override
  void initState() {
    super.initState();
    _task = Get.arguments as TaskVO;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('生成结果'),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            (_task.result != null)
                ? Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: context.theme.cardColor,
                      borderRadius: BorderRadius.circular(16 + 2),
                      border: Border.all(
                        color: context.theme.primaryColor,
                        width: 2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: ExtendedImage.network(
                        _task.result!,
                        loadStateChanged: (state) {
                          if (state.extendedImageLoadState ==
                              LoadState.loading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (state.extendedImageLoadState ==
                              LoadState.failed) {
                            return const Center(
                              child: Text('加载失败'),
                            );
                          }
                          return null;
                        },
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  )
                : Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: context.theme.primaryColor,
                      size: 36,
                    ),
                  ),
            const Spacer(),
            if (_task.result != null)
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.bottomSheet(
                          ImageSaveWidget(imageUrl: _task.result!)),
                      child: Container(
                        height: 48,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 32),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: context.theme.primaryColor,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: const Text(
                          '保存',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: GestureDetector(
                  //     onTap: () => Get.toNamed(AppRouter.soloGeneratePage),
                  //     child: Container(
                  //       height: 48,
                  //       alignment: Alignment.center,
                  //       margin: const EdgeInsets.symmetric(
                  //           vertical: 8, horizontal: 32),
                  //       padding: const EdgeInsets.symmetric(horizontal: 16),
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(8),
                  //         color: context.theme.primaryColor,
                  //         boxShadow: const [
                  //           BoxShadow(
                  //             color: Colors.black26,
                  //             blurRadius: 4,
                  //             offset: Offset(2, 2),
                  //           ),
                  //         ],
                  //       ),
                  //       child: const Text(
                  //         '分享',
                  //         style: TextStyle(color: Colors.white),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
