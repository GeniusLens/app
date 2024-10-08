import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:genius_lens/api/request/common.dart';
import 'package:genius_lens/router.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../api/request/generate.dart';
import '../../data/entity/generate.dart';

class ModelCreatePage extends StatefulWidget {
  const ModelCreatePage({super.key});

  @override
  State<ModelCreatePage> createState() => _ModelCreatePageState();
}

class _ModelCreatePageState extends State<ModelCreatePage> {
  final List<String> _steps = [
    '上传正面照片',
    '上传其他照片',
  ];
  late final PageController _pageController;
  int _selectedIndex = 0;

  final ImagePicker _imagePicker = ImagePicker();
  String? _frontImageUrl;
  bool _isFrontLoading = false;
  bool _isFrontValid = false;
  final Map<int, bool> _isOtherLoadingMap = {};
  final Map<int, bool> _isOtherValidMap = {};
  final List<String?> _otherImageUrls = [];
  String _name = '';
  final List<SampleVO> _samples = [];

  Future<void> _loadSamples() async {
    var result = await GenerateApi.getSamples(0);
    setState(() {
      _samples.addAll(result);
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _selectedIndex = _pageController.page!.round();
      });
    });
    _loadSamples();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('创建分身'),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                _steps.length,
                (index) => GestureDetector(
                  onTap: () => _pageController.animateToPage(index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    margin: const EdgeInsets.only(right: 8),
                    child: Text(
                      '${index + 1}. ${_steps[index]}',
                      style: TextStyle(
                        fontSize: 16,
                        color: _selectedIndex == index
                            ? context.theme.primaryColor
                            : Colors.grey[800],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: (_selectedIndex == 1 &&
              _otherImageUrls.isNotEmpty &&
              _frontImageUrl != null)
          ? FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () async {
                // 检查有无还在上传的图片
                if (_isFrontLoading || _isOtherLoadingMap.containsValue(true)) {
                  EasyLoading.showError('图片正在上传中，请稍后');
                  return;
                }

                // 弹窗要求填写名称
                await Get.dialog(
                  AlertDialog(
                    backgroundColor: context.theme.cardColor,
                    surfaceTintColor: context.theme.cardColor,
                    contentPadding: const EdgeInsets.all(16),
                    titlePadding: const EdgeInsets.all(16),
                    actionsPadding: const EdgeInsets.all(16),
                    title: const Text(
                      '分身名称',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    content: TextField(
                      decoration: const InputDecoration(
                        hintText: '请输入分身名称',
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                      onChanged: (value) => _name = value,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(result: null),
                        child: const Text('取消',
                            style: TextStyle(color: Colors.grey)),
                      ),
                      TextButton(
                        onPressed: () {
                          if (_name.isEmpty) {
                            EasyLoading.showError('名称不能为空');
                            return;
                          }
                          Get.back(result: true);
                        },
                        child: const Text('确定', style: TextStyle()),
                      ),
                    ],
                  ),
                );
                if (_name.isEmpty) return;
                // 提交任务
                var result = await GenerateApi.submitTask(
                  type: 2,
                  sceneId: _name,
                  images: [
                    _frontImageUrl!,
                    ..._otherImageUrls
                        .where((element) => element != null)
                        .map((e) => e!)
                        .toList(),
                  ],
                );

                if (result == null) {
                  EasyLoading.dismiss();
                  EasyLoading.showError('生成失败');
                  return;
                } else {
                  EasyLoading.dismiss();
                  EasyLoading.showSuccess('分身提交成功');
                }
                Future.delayed(const Duration(milliseconds: 500), () {
                  Get.offNamed(AppRouter.manageModelPage);
                });
              },
              child: const Icon(Icons.check),
            )
          : null,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _selectedIndex = index),
        children: [
          _BasePage(
            key: const Key('front'),
            content: Column(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    XFile? file = await _imagePicker.pickImage(
                      source: ImageSource.gallery,
                    );
                    setState(() => _isFrontLoading = true);
                    if (file == null) return;
                    var result = await CommonAPi.uploadFile(file.path);
                    if (result == null) {
                      Get.snackbar('上传失败', '请检查网络连接或稍后重试',
                          snackPosition: SnackPosition.BOTTOM);
                    }
                    setState(() {
                      _frontImageUrl = result;
                    });
                    // 检查图片是否合格
                    var detectResult = await CommonAPi.detect(result!);
                    // print(detectResult);
                    if (detectResult.isFrontal && detectResult.isQualified) {
                      setState(() => _isFrontValid = true);
                    } else {
                      setState(() => _isFrontValid = false);
                    }
                    setState(() => _isFrontLoading = false);
                  },
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      // 减去AppBar高度
                      height: (_frontImageUrl == null)
                          ? 196
                          : Get.height -
                              MediaQuery.of(context).padding.top -
                              kToolbarHeight -
                              256 -
                              64,
                      width: (_frontImageUrl == null) ? 196 : null,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: (_frontImageUrl != null)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: ExtendedImage.network(
                                _frontImageUrl!,
                                cache: true,
                                loadStateChanged: (state) {
                                  if (state.extendedImageLoadState ==
                                      LoadState.loading) {
                                    return Center(
                                      child: LoadingAnimationWidget
                                          .horizontalRotatingDots(
                                        color: context.theme.primaryColor,
                                        size: 32,
                                      ),
                                    );
                                  }
                                  return ExtendedRawImage(
                                      image: state.extendedImageInfo?.image,
                                      fit: BoxFit.cover);
                                },
                                fit: BoxFit.cover,
                              ),
                            )
                          : Center(
                              child: (_isFrontLoading)
                                  ? LoadingAnimationWidget
                                      .horizontalRotatingDots(
                                      color: context.theme.primaryColor,
                                      size: 32,
                                    )
                                  : Icon(
                                      Icons.add,
                                      size: 48,
                                      color: Colors.grey[600],
                                    ),
                            ),
                    ),
                  ),
                ),
                // 指示图片是否合格
                AnimatedOpacity(
                  opacity: (_frontImageUrl == null) ? 0 : 1,
                  duration: const Duration(milliseconds: 300),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Spacer(),
                      if (_isFrontLoading)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: LoadingAnimationWidget.horizontalRotatingDots(
                            color: context.theme.primaryColor,
                            size: 32,
                          ),
                        ),
                      if (!_isFrontLoading)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            _isFrontValid ? Icons.check_circle : Icons.cancel,
                            color: _isFrontValid ? Colors.green : Colors.red,
                          ),
                        ),
                      if (!_isFrontLoading)
                        Text(
                          _isFrontValid ? '图片合格' : '图片不合格',
                          style: TextStyle(
                            fontSize: 12,
                            color: _isFrontValid ? Colors.green : Colors.red,
                          ),
                        ),
                      if (!_isFrontLoading) const SizedBox(width: 16),
                      const Spacer(),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
            goodSamples: _samples
                .where((element) => element.type == 1)
                .map((e) => e.url)
                .toList(),
            badSamples: _samples
                .where((element) => element.type == 2)
                .map((e) => e.url)
                .toList(),
          ),
          _BasePage(
            key: const Key('other'),
            content: Container(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _otherImageUrls.length + 1,
                itemBuilder: (context, index) {
                  var content = index < _otherImageUrls.length
                      ? _otherImageUrls[index] == null
                          ? LoadingAnimationWidget.horizontalRotatingDots(
                              color: context.theme.primaryColor,
                              size: 32,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: ExtendedImage.network(
                                _otherImageUrls[index]!,
                                cache: true,
                                loadStateChanged: (state) {
                                  if (state.extendedImageLoadState ==
                                      LoadState.loading) {
                                    return Center(
                                      child: LoadingAnimationWidget
                                          .horizontalRotatingDots(
                                        color: context.theme.primaryColor,
                                        size: 32,
                                      ),
                                    );
                                  }
                                  return null;
                                },
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                      : Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: (_isOtherLoadingMap[index] == true)
                              ? Center(
                                  child: LoadingAnimationWidget
                                      .horizontalRotatingDots(
                                    color: context.theme.primaryColor,
                                    size: 32,
                                  ),
                                )
                              : Icon(
                                  Icons.add,
                                  size: 48,
                                  color: Colors.grey[600],
                                ),
                        );
                  return GestureDetector(
                    onTap: () async {
                      if (index < _otherImageUrls.length) {
                        // 弹窗询问是否删除
                        bool? result = await Get.dialog<bool>(
                          AlertDialog(
                            backgroundColor: context.theme.cardColor,
                            surfaceTintColor: context.theme.cardColor,
                            contentPadding: const EdgeInsets.all(16),
                            titlePadding: const EdgeInsets.all(16),
                            actionsPadding: const EdgeInsets.all(16),
                            title: const Text(
                              '删除图片',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            content: const Text('确定要删除这张图片吗？'),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(result: false),
                                child: const Text('取消',
                                    style: TextStyle(color: Colors.grey)),
                              ),
                              TextButton(
                                onPressed: () => Get.back(result: true),
                                child: const Text('确定', style: TextStyle()),
                              ),
                            ],
                          ),
                        );
                        if (result == true) {
                          setState(() {
                            _otherImageUrls.removeAt(index);
                          });
                        }
                        return;
                      }

                      // 处理添加图片
                      List<XFile> selected =
                          await _imagePicker.pickMultiImage();
                      if (selected.isEmpty) return;
                      // 将新的图片添加到列表中
                      // 允许批量添加
                      var oldLength = _otherImageUrls.length;
                      for (var file in selected) {
                        var idx = oldLength + selected.indexOf(file);
                        setState(() {
                          _isOtherLoadingMap[idx] = true;
                          _otherImageUrls.add(null);
                          _isOtherValidMap[idx] = false;
                        });
                      }
                      // 上传图片
                      for (var file in selected) {
                        var result = await CommonAPi.uploadFile(file.path);
                        if (result == null) {
                          EasyLoading.showError('上传失败');
                        }
                        var idx = oldLength + selected.indexOf(file);
                        setState(() {
                          _otherImageUrls[idx] = result!;
                        });
                        // 对图片进行检测
                        var detectResult = await CommonAPi.detect(result!);
                        // print(detectResult);
                        if (detectResult.isQualified) {
                          setState(() => _isOtherValidMap[idx] = true);
                        } else {
                          setState(() => _isOtherValidMap[idx] = false);
                        }
                        setState(() {
                          _isOtherLoadingMap[idx] = false;
                        });
                      }
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: content,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // 上传中显示加载动画
                        if (index < _otherImageUrls.length &&
                            _otherImageUrls[index] != null &&
                            (_isOtherLoadingMap[index] ?? true))
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 4),
                            child:
                                LoadingAnimationWidget.horizontalRotatingDots(
                              color: context.theme.primaryColor,
                              size: 16,
                            ),
                          ),
                        if (index < _otherImageUrls.length &&
                            _otherImageUrls[index] != null &&
                            !_isOtherLoadingMap[index]!)
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 4),
                                child: Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: _isOtherValidMap[index] ?? false
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              Text(
                                _isOtherValidMap[index] ?? false
                                    ? '图片合格'
                                    : '图片不合格',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const Spacer(),
                            ],
                          )
                      ],
                    ),
                  );
                },
              ),
            ),
            explain: const [
              '避免上传面部被遮挡的照片。',
              '保证照片只含有一个人的面部。',
              '避免面部占比过小的照片。',
            ],
            goodSamples: _samples
                .where((element) => element.type == 1)
                .map((e) => e.url)
                .toList(),
            badSamples: _samples
                .where((element) => element.type == 2)
                .map((e) => e.url)
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _BasePage extends StatefulWidget {
  const _BasePage(
      {super.key,
      required this.content,
      this.explain = const [],
      required this.goodSamples,
      required this.badSamples});

  final Widget content;
  final List<String> explain;
  final List<String> goodSamples;
  final List<String> badSamples;

  @override
  State<_BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<_BasePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: widget.content,
        ),
        if (widget.explain.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: widget.explain
                  .map(
                    (e) => Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '* $e',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: const Row(
            children: [
              Expanded(child: Divider()),
              SizedBox(width: 16),
              Text(
                '示例',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(width: 16),
              Expanded(child: Divider()),
            ],
          ),
        ),
        Container(
          height: 156,
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.goodSamples.length + widget.badSamples.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: ExtendedImage.network(
                          index < widget.goodSamples.length
                              ? widget.goodSamples[index]
                              : widget.badSamples[
                                  index - widget.goodSamples.length],
                          // cache: true,
                          width: 96,
                          height: 96,
                          loadStateChanged: (state) {
                            if (state.extendedImageLoadState ==
                                LoadState.loading) {
                              return Center(
                                child: LoadingAnimationWidget.fourRotatingDots(
                                  color: context.theme.primaryColor,
                                  size: 32,
                                ),
                              );
                            }
                            return null;
                          },
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        index < widget.goodSamples.length
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: index < widget.goodSamples.length
                            ? Colors.green
                            : Colors.red,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // 隐私声明
        // SizedBox(
        //   height: 32,
        //   child: Text(
        //     '点击下一步，即表示您同意《隐私声明》',
        //     style: TextStyle(
        //       fontSize: 12,
        //       color: Colors.grey[600],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
