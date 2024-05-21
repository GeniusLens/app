import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:genius_lens/api/request/common.dart';
import 'package:genius_lens/api/request/generate.dart';
import 'package:genius_lens/data/entity/generate.dart';
import 'package:genius_lens/router.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AnimeGeneratePage extends StatefulWidget {
  const AnimeGeneratePage({super.key});

  @override
  State<AnimeGeneratePage> createState() => _AnimeGeneratePageState();
}

class _AnimeGeneratePageState extends State<AnimeGeneratePage> {
  late final FunctionVO function;
  String? _url;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    function = Get.arguments as FunctionVO;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(function.name ?? ''),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: (_url == null)
                  ? GestureDetector(
                      onTap: () async {
                        var image = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        // print(image);
                        if (image == null) {
                          return;
                        }
                        setState(() => _uploading = true);
                        var uploaded = await CommonAPi.uploadFile(image.path);
                        // print(uploaded);
                        setState(() {
                          _url = uploaded;
                          _uploading = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: context.theme.primaryColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: (_uploading)
                            ? LoadingAnimationWidget.staggeredDotsWave(
                                color: Colors.white,
                                size: 32,
                              )
                            : const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 64,
                              ),
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.all(16),
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: ExtendedImage.network(
                          _url!,
                          fit: BoxFit.cover,
                          loadStateChanged: (state) {
                            if (state.extendedImageLoadState ==
                                LoadState.loading) {
                              return Center(
                                child: LoadingAnimationWidget.staggeredDotsWave(
                                  color: context.theme.primaryColor,
                                  size: 32,
                                ),
                              );
                            } else if (state.extendedImageLoadState ==
                                LoadState.failed) {
                              return const Center(
                                child: Icon(Icons.error),
                              );
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
            ),
          ),
          AnimatedOpacity(
            opacity: _url == null ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            child: GestureDetector(
              onTap: () async {
                if (_url == null) {
                  EasyLoading.showToast('请先选择一张图片');
                }
                var id = await GenerateApi.submitTask(
                  f: function,
                  images: [_url!],
                );
                if (id == null) {
                  EasyLoading.showToast('生成失败');
                  return;
                }
                EasyLoading.showToast('生成成功');
                // 关闭所有页面，跳转到生成结果页面
                Get.offAllNamed(AppRouter.manageTaskPage);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                decoration: BoxDecoration(
                  color: context.theme.primaryColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: const Text(
                  '立即生成',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            child: const Text(
              '点击上方按钮，选择一张图片，即可生成动漫头像',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
