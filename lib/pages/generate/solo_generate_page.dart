import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:genius_lens/router.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../api/request/generate.dart';
import '../../data/entity/generate.dart';

class SoloGeneratePage extends StatefulWidget {
  const SoloGeneratePage({super.key});

  @override
  State<SoloGeneratePage> createState() => _SoloGeneratePageState();
}

class _SoloGeneratePageState extends State<SoloGeneratePage> {
  late final FunctionVO function;
  final List<LoraVO> _loras = [];
  int _index = 0;
  int _selected = -1;
  DateTime _lastTime = DateTime.now();

  Future<void> _fetchLoraList() async {
    var list = await GenerateApi.getUserLoraList();
    setState(() {
      _loras.clear();
      _loras.addAll(list);
    });
  }

  @override
  void initState() {
    super.initState();
    function = Get.arguments as FunctionVO;
    _fetchLoraList();
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
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 1),
            if (_loras.isNotEmpty && _selected != -1)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(8),
                child: Text(
                  '您已选择 ${_loras[_selected].name}',
                  style: TextStyle(
                    fontSize: 16,
                    color: context.theme.primaryColor.withOpacity(0.6),
                  ),
                ),
              ),
            if (_loras.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(8),
                child: AnimatedSmoothIndicator(
                  activeIndex: _index,
                  count: _loras.length,
                  onDotClicked: (index) {
                    setState(() => _index = index);
                  },
                  effect: WormEffect(
                    dotColor: context.theme.primaryColor.withOpacity(0.4),
                    activeDotColor: context.theme.primaryColor,
                    dotHeight: 8,
                    dotWidth: 8,
                  ),
                ),
              ),
            if (_loras.isNotEmpty)
              GestureDetector(
                // 监听左右滑动
                onHorizontalDragUpdate: (details) {
                  // 滑动距离小于阈值不触发
                  if (details.primaryDelta!.abs() < 4) return;
                  // 时间间隔小于阈值不触发
                  if (DateTime.now().difference(_lastTime).inMilliseconds < 300)
                    return;
                  if (details.primaryDelta! > 0) {
                    if (_index > 0) {
                      setState(() => _index--);
                    } else {
                      setState(() => _index = _loras.length - 1);
                    }
                  } else {
                    if (_index < _loras.length - 1) {
                      setState(() => _index++);
                    } else {
                      setState(() => _index = 0);
                    }
                  }
                  _lastTime = DateTime.now();
                },
                child: Row(
                  children: [
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          if (_index > 0) {
                            setState(() => _index--);
                          } else {
                            setState(() => _index = _loras.length - 1);
                          }
                        },
                        icon: const Icon(Icons.chevron_left, size: 48),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 224,
                      width: 224,
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        // color: context.theme.cardColor,
                        shape: BoxShape.circle,
                        border: (_selected == _index)
                            ? Border.all(
                                color:
                                    context.theme.primaryColor.withOpacity(0.8),
                                width: 2,
                              )
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (_selected != _index) {
                            setState(() => _selected = _index);
                          } else {
                            setState(() => _selected = -1);
                          }
                        },
                        child: CircleAvatar(
                          radius: 224,
                          backgroundImage: ExtendedImage.network(
                            _loras[_index].avatar,
                            fit: BoxFit.cover,
                          ).image,
                        ),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          if (_index < _loras.length - 1) {
                            setState(() => _index++);
                          } else {
                            setState(() => _index = 0);
                          }
                        },
                        icon: const Icon(Icons.chevron_right, size: 48),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                _loras.isEmpty ? '加载中...' : _loras[_index].name!,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: context.theme.primaryColor.withOpacity(0.6),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                '${_loras.isEmpty ? '加载中...' : _loras[_index].description}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const Spacer(flex: 2),
            GestureDetector(
              onTap: () => Get.toNamed(AppRouter.generateResultPage),
              child: Container(
                height: 48,
                margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
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
                child: Center(
                  child: Text('生成',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
