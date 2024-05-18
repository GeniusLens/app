import 'package:card_swiper/card_swiper.dart';
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:genius_lens/data/entity/generate.dart';
import 'package:genius_lens/widget/image_save_widget.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:video_player/video_player.dart';

class GenerateResultPage extends StatefulWidget {
  const GenerateResultPage({super.key});

  @override
  State<GenerateResultPage> createState() => _GenerateResultPageState();
}

class _GenerateResultPageState extends State<GenerateResultPage> {
  /// 任务
  late final TaskVO _task;

  /// 图片或视频的url
  final List<String> _urls = [];

  /// 是否是视频
  bool _isVideo = false;

  /// Swiper控制器
  late final SwiperController _swiperCtrl;

  /// 视频控制器
  VideoPlayerController? _videoCtrl;

  /// 初始化视频播放器
  late Future<void> _initVideoPlayer;

  /// 处理任务结果
  void _process() async {
    // 先对url进行处理
    if (_task.result!.contains(',')) {
      _urls.addAll(_task.result!.split(','));
    } else {
      _urls.add(_task.result!);
    }
    if (_urls.isEmpty) {
      return;
    }
    // 长度大于1说明不是视频
    if (_urls.length > 1) {
      return;
    }
    if (mounted) {
      setState(() {
        _isVideo = false;
      });
    }

    // 请求文件检查是否是视频
    var response = await Dio().get(_task.result!);
    var mime = response.headers['content-type']?.first;
    if (mime == null) {
      return;
    }
    if (mime.startsWith('video')) {
      setState(() {
        _isVideo = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _task = Get.arguments as TaskVO;
    _swiperCtrl = SwiperController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_task.result != null) {
        _process();
      }
    });
  }

  @override
  void dispose() {
    _videoCtrl?.dispose();
    _swiperCtrl.dispose();
    _initVideoPlayer = Future.value();
    super.dispose();
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
            Expanded(
              child: (_urls.isNotEmpty)
                  ? Swiper(
                      controller: _swiperCtrl,
                      loop: false,
                      itemCount: _urls.length,
                      pagination: (_urls.length > 1)
                          ? SwiperPagination(
                              builder: DotSwiperPaginationBuilder(
                                color: Colors.black12,
                                activeColor: context.theme.primaryColor,
                              ),
                            )
                          : const SwiperPagination(
                              builder: DotSwiperPaginationBuilder(
                                color: Colors.transparent,
                                activeColor: Colors.transparent,
                              ),
                            ),
                      autoplay: true,
                      itemBuilder: (context, index) {
                        return Container(
                          child: _buildItem(context, index),
                        );
                      },
                    )
                  : LoadingAnimationWidget.fourRotatingDots(
                      color: context.theme.primaryColor,
                      size: 36,
                    ),
            ),
            // Container(
            //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            //   child: Row(
            //     children: [
            //       Text(
            //         '任务：${_task.function}',
            //         style: const TextStyle(fontSize: 18),
            //       ),
            //     ],
            //   ),
            // ),
            if (_task.result != null)
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (_task.result == null) {
                      return;
                    }
                    Get.bottomSheet(ImageSaveWidget(imageUrl: _task.result!));
                  },
                  child: Container(
                    height: 48,
                    alignment: Alignment.center,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
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
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    Widget content = ExtendedImage.network(
      _urls[index],
      cache: true,
      loadStateChanged: (state) {
        if (state.extendedImageLoadState == LoadState.loading) {
          return Padding(
            padding: const EdgeInsets.all(32),
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: context.theme.primaryColor,
              size: 36,
            ),
          );
        }
        return null;
      },
      fit: BoxFit.fitWidth,
    );
    if (_isVideo) {
      _videoCtrl = VideoPlayerController.networkUrl(Uri.parse(_urls[index]));
      _initVideoPlayer = _videoCtrl!.initialize();
      // initialize后才能播放
      _initVideoPlayer.then((value) {
        _videoCtrl!.setLooping(true);
        _videoCtrl!.play();
      });
      content = FutureBuilder(
        future: _initVideoPlayer,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                AspectRatio(
                  aspectRatio: 3 / 4,
                  child: VideoPlayer(_videoCtrl!),
                ),
              ],
            );
          }
          return Padding(
            padding: const EdgeInsets.all(32),
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: context.theme.primaryColor,
              size: 36,
            ),
          );
        },
      );
    }
    return Center(
      child: Container(
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
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: content,
          ),
        ),
      ),
    );
  }
}
