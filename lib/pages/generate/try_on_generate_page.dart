import 'dart:async';

import 'package:card_swiper/card_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:genius_lens/api/request/common.dart';
import 'package:genius_lens/api/request/generate.dart';
import 'package:genius_lens/data/entity/common.dart';
import 'package:genius_lens/data/entity/generate.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class TryOnGeneratePage extends StatefulWidget {
  const TryOnGeneratePage({super.key});

  @override
  State<TryOnGeneratePage> createState() => _TryOnGeneratePageState();
}

/// 试穿页面
class _TryOnGeneratePageState extends State<TryOnGeneratePage> {
  /// 功能分类
  /// 显示在AppBar的标题上
  late final CategoryVO _category;

  /// 功能
  /// 用于提交任务
  late final FunctionVO _function;

  /// 任务ID
  int? _taskId;

  /// 任务信息
  TaskVO? currentTask;

  /// 服装选择面板的Key
  final GlobalKey _panelKey = GlobalKey();

  /// 模特列表
  final List<ModelVO> _models = [];

  /// 服装列表
  final List<ClothVO> _clothes = [];

  /// 试穿结果
  /// 存储结果的URL
  final List<String> _results = [];

  /// 是否正在等待换装
  bool _tryonWaiting = false;

  /// 是否正在上传自定义服装
  bool _uploadingCloth = false;

  /// 是否正在上传自定义模特
  bool _uploadingModel = false;

  /// 上下翻转控制器（结果和模特）
  late final SwiperController _updownSwiperCtrl;

  /// 模特选择控制器
  late final SwiperController _modelSwiperCtrl;

  /// 选择的服装
  int _selectedCloth = -1;

  /// 选择的模特
  int _selectedModel = -1;

  /// Panel 高度
  double panelHeight = 312;

  /// 提交任务
  void _handleTaskQuery() {
    if (_taskId == null) {
      debugPrint('Task Id is null');
      return;
    }
    // 轮询获取结果
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      var result = await GenerateApi.getTaskInfo(_taskId!);
      if (result.statusCode == TaskVOStatus.completed.index ||
          result.statusCode == TaskVOStatus.failed.index) {
        // 取消定时器
        timer.cancel();
        EasyLoading.dismiss();

        // 处理失败情况
        if (result.statusCode == TaskVOStatus.failed.index && _tryonWaiting) {
          EasyLoading.showToast('试穿失败');
          setState(() {
            _tryonWaiting = false;
          });
          return;
        }

        // 处理成功情况
        // 按照,分割并去掉最后一个空字符串
        currentTask = result;
        var resultUrls = currentTask!.result!.split(',');
        setState(() {
          _tryonWaiting = false;
          _results.clear();
          _results.addAll(resultUrls);
        });
        // 切换到结果页
        if (_updownSwiperCtrl.index == 0) {
          _updownSwiperCtrl.next();
        }
      }
    });
  }

  /// 加载服装
  Future<void> _loadClothes() async {
    var data = await CommonAPi.getClothes();
    setState(() {
      _clothes.clear();
      _clothes.addAll(data);
    });
  }

  /// 加载模特
  Future<void> _loadModels() async {
    var data = await CommonAPi.getModels();
    setState(() {
      _models.clear();
      _models.addAll(data);
    });
  }

  /// 加载功能列表
  Future<void> _loadFunction() async {
    var result = await GenerateApi.getFunctionList(_category.name);
    if (result.isNotEmpty) {
      setState(() {
        _function =
            result.where((element) => element.name == _category.name).first;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // 获取Panel高度
      final RenderBox renderBox =
          _panelKey.currentContext!.findRenderObject() as RenderBox;
      panelHeight = renderBox.size.height;
    });

    _category = Get.arguments as CategoryVO;

    _updownSwiperCtrl = SwiperController();
    _modelSwiperCtrl = SwiperController();

    _loadModels();
    _loadFunction();
    _loadClothes();
  }

  @override
  void dispose() {
    // 及时销毁定时器
    if (_taskId != null) {
      Timer.periodic(const Duration(seconds: 1), (timer) {});
    }
    _updownSwiperCtrl.dispose();
    _modelSwiperCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_category.name),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actions: [
          // 提交按钮
          GestureDetector(
            onTap: _onSubmit,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: context.theme.primaryColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: (_tryonWaiting)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: LoadingAnimationWidget.prograssiveDots(
                        color: Colors.white,
                        size: 16,
                      ),
                    )
                  : const Text(
                      '试穿',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: SlidingUpPanel(
        panel: Container(
          key: _panelKey,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: const Text(
                  '选择试穿的衣服',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Scrollbar(
                  thickness: 4,
                  radius: const Radius.circular(4),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _clothes.length + 1,
                    itemBuilder: _buildClothItem,
                  ),
                ),
              ),
            ],
          ),
        ),
        maxHeight: MediaQuery.of(context).size.height * (1 - 0.618),
        minHeight: 196,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        body: Column(
          children: [
            Expanded(
              child: Swiper(
                controller: _updownSwiperCtrl,
                itemCount: 1 + (_results.isEmpty ? 0 : 1),
                scrollDirection: Axis.vertical,
                loop: false,
                control: SwiperControl(
                  color: context.theme.primaryColor,
                  disableColor: Colors.grey[400]!,
                  size: 24,
                ),
                transformer: ScaleAndFadeTransformer(),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildModelLevel(context);
                  } else {
                    return _buildResultLevel(context);
                  }
                },
              ),
            ),
            // const SizedBox(height: 294),
            SizedBox.fromSize(size: Size.fromHeight(panelHeight)),
          ],
        ),
      ),
    );
  }

  /// 构建服装选择项
  /// 最后一项为添加按钮
  Widget? _buildClothItem(context, index) {
    if (index == _clothes.length) {
      return GestureDetector(
        onTap: () async {
          // EasyLoading.show(status: '上传中...');
          var file = await ImagePicker().pickImage(
            source: ImageSource.gallery,
          );
          if (file == null || file.path.isEmpty) {
            return;
          } else {
            setState(() {
              _uploadingCloth = true;
            });
            // EasyLoading.show(status: '上传中...');
          }

          var uploaded = await CommonAPi.uploadFile(file.path);
          if (uploaded != null) {
            setState(() {
              _clothes.add(ClothVO(
                url: uploaded,
              ));
              // 选择最后一个
              _selectedCloth = _clothes.length - 1;
              _uploadingCloth = false;
            });
            // EasyLoading.dismiss();
            // EasyLoading.showToast('上传成功');
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: _uploadingCloth
                ? LoadingAnimationWidget.prograssiveDots(
                    color: Theme.of(context).primaryColor,
                    size: 32,
                  )
                : const Icon(
                    Icons.add,
                    color: Colors.grey,
                  ),
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        if (_tryonWaiting) return;
        setState(() {
          if (_selectedCloth == index) {
            _selectedCloth = -1;
          } else {
            _selectedCloth = index;
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: (_selectedCloth == index)
              ? Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                )
              : null,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: ExtendedImage.network(
            _clothes[index].url!,
            fit: BoxFit.cover,
            loadStateChanged: (state) {
              if (state.extendedImageLoadState == LoadState.loading) {
                return Center(
                  child: LoadingAnimationWidget.prograssiveDots(
                    color: Theme.of(context).primaryColor,
                    size: 32,
                  ),
                );
              } else if (state.extendedImageLoadState == LoadState.failed) {
                return const Center(
                  child: Icon(Icons.error),
                );
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  /// 提交任务
  void _onSubmit() async {
    if (_tryonWaiting) {
      EasyLoading.showToast('正在试穿中');
      return;
    }
    if (_selectedCloth == -1) {
      EasyLoading.showToast('请选择衣服');
      return;
    }
    setState(() => _tryonWaiting = true);

    // 提交任务
    var submittedTaskId = await GenerateApi.submitTryonTask(
        modelUrl: _models[_selectedModel].url!,
        clothUrl: _clothes[_selectedCloth].url!,
        func: _function,
        clothId: _clothes[_selectedCloth].id!);

    if (submittedTaskId == null) {
      EasyLoading.showToast('提交失败');
      return;
    }
    setState(() => _taskId = submittedTaskId);
    _handleTaskQuery();
  }

  Swiper _buildModelLevel(BuildContext context) {
    return Swiper(
      itemCount: _models.length + 1,
      loop: false,
      scale: 0.8,
      viewportFraction: 0.7,
      onIndexChanged: (index) => setState(() => _selectedModel = index),
      itemBuilder: (context, index) {
        if (index == _models.length) {
          return Center(
            child: GestureDetector(
              onTap: () async {
                var file = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                if (file == null || file.path.isEmpty) {
                  return;
                }
                setState(() {
                  _uploadingModel = true;
                });
                // EasyLoading.show(status: '上传中...');
                var upload = await CommonAPi.uploadFile(file.path);
                if (upload != null) {
                  setState(() {
                    _models.add(ModelVO(
                      url: upload,
                    ));
                    // 选择最后一个
                    _selectedModel = _models.length - 1;
                    _uploadingModel = false;
                  });
                  // EasyLoading.dismiss();
                  // EasyLoading.showToast('上传成功');
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
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
                child: _uploadingModel
                    ? LoadingAnimationWidget.prograssiveDots(
                        color: context.theme.primaryColor,
                        size: 32,
                      )
                    : Icon(
                        Icons.add,
                        color: context.theme.primaryColor,
                        size: 48,
                      ),
              ),
            ),
          );
        }
        return Container(
          margin: const EdgeInsets.only(bottom: 32, top: 32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: context.theme.cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300]!,
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ExtendedImage.network(
                    _models[index].url!,
                    loadStateChanged: (state) {
                      if (state.extendedImageLoadState == LoadState.loading) {
                        return Center(
                          child: LoadingAnimationWidget.prograssiveDots(
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
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // 加载时添加一个蒙版
              AnimatedOpacity(
                opacity: _tryonWaiting ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Swiper _buildResultLevel(BuildContext context) {
    return Swiper(
      itemCount: (_results.isEmpty) ? 1 : _results.length,
      loop: false,
      scale: 0.8,
      viewportFraction: 0.7,
      itemBuilder: (context, index) {
        if (_results.isEmpty) {
          if (_tryonWaiting) {
            return Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: context.theme.primaryColor,
                size: 48,
              ),
            );
          } else {
            return const Center(
              child: Text(
                '暂无结果',
                style: TextStyle(fontSize: 18),
              ),
            );
          }
        }
        return Container(
          margin: const EdgeInsets.only(bottom: 32, top: 32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: context.theme.cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300]!,
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ExtendedImage.network(
                    _results[index],
                    loadStateChanged: (state) {
                      if (state.extendedImageLoadState == LoadState.loading) {
                        return Center(
                          child: LoadingAnimationWidget.prograssiveDots(
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
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // 加载时添加一个蒙版
              AnimatedOpacity(
                opacity: _tryonWaiting ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
