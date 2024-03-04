import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:genius_lens/data/entity/generate.dart';
import 'package:genius_lens/router.dart';
import 'package:get/get.dart';

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
            Container(
              padding: const EdgeInsets.all(8),
              child: LinearProgressIndicator(
                color: Colors.blue,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: (_task.result != null)
                    ? ClipRRect(
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
                          },
                          fit: BoxFit.fill,
                        ),
                      )
                    : Center(
                        child: Text(_task.status ?? ''),
                      ),
              ),
            ),
            if (_task.result != null)
              GestureDetector(
                onTap: () => Get.toNamed(AppRouter.soloGeneratePage),
                child: Container(
                  height: 48,
                  alignment: Alignment.center,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: context.theme.primaryColor,
                  ),
                  child: const Text(
                    '更像我一点',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            if (_task.result != null)
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.toNamed(AppRouter.soloGeneratePage),
                      child: Container(
                        height: 48,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 32),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: context.theme.primaryColor,
                        ),
                        child: const Text(
                          '保存全部',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.toNamed(AppRouter.soloGeneratePage),
                      child: Container(
                        height: 48,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 32),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: context.theme.primaryColor,
                        ),
                        child: const Text(
                          '保存全部',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
