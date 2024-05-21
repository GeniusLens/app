import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:genius_lens/api/request/generate.dart';
import 'package:genius_lens/data/entity/generate.dart';
import 'package:genius_lens/router.dart';
import 'package:genius_lens/utils/debug_util.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mime/mime.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ManageTaskPage extends StatefulWidget {
  const ManageTaskPage({super.key});

  @override
  State<ManageTaskPage> createState() => _ManageTaskPageState();
}

class _ManageTaskPageState extends State<ManageTaskPage> {
  final List<TaskVO> _tasks = [];
  // final List<String?> _coverUrls = [];
  bool _isLoading = false;
  String? _seletectedCategory;
  List<String> _categories = ['全部', 'AI趣图像', 'AI趣穿搭', 'AI趣视频'];

  Future<void> _loadData() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    var data = await GenerateApi.getTaskList(
        _seletectedCategory == '全部' ? null : _seletectedCategory);
    // print('data length: ${data.length}');
    // 检查每一个result是否包含","分隔组成的多个URL
    // 如果是则仅保留第一个URL
    // _coverUrls.clear();
    // for (var element in data) {
    //   _coverUrls.add(
    //       (element.result != null) ? element.result!.split(',').first : null);
    // }
    // print('coverUrls length: ${_coverUrls.length}');

    setState(() {
      _tasks.clear();
      _tasks.addAll(data);
      _isLoading = false;
    });
    // print('tasks length: ${_tasks.length}');
  }

  @override
  void initState() {
    super.initState();
    _seletectedCategory = _categories.first;
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的作品'),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          // 弹出菜单
          PopupMenuButton(
            itemBuilder: (context) {
              return _categories
                  .map(
                    (e) => PopupMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList();
            },
            onSelected: (value) {
              setState(() {
                _seletectedCategory = value as String?;
              });
              _loadData();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: RefreshIndicator(
          onRefresh: () => _loadData(),
          child: (_isLoading)
              ? Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                    color: context.theme.primaryColor,
                    size: 36,
                  ),
                )
              : (_tasks.isNotEmpty)
                  ? AnimationLimiter(
                      child: GridView.count(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        children: _tasks
                            .map(
                              (e) => AnimationConfiguration.staggeredGrid(
                                position: _tasks.indexOf(e),
                                columnCount: 2,
                                delay: const Duration(milliseconds: 50),
                                child: ScaleAnimation(
                                  child: FadeInAnimation(
                                    child: _TaskItem(
                                      key: ValueKey(e.id),
                                      task: e,
                                      cover: e.cover,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.hourglass_empty,
                            size: 32,
                            color: context.theme.primaryColor,
                          ),
                          const SizedBox(height: 8),
                          const Text('暂无作品'),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}

class _TaskItem extends StatefulWidget {
  const _TaskItem({
    super.key,
    required this.task,
    this.cover,
  });

  final TaskVO task;
  final String? cover;

  @override
  State<_TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<_TaskItem> {
  Widget? _content;

  String _buildMesage() {
    switch (widget.task.statusCode) {
      case 1:
        return '您的作品还在排队等待中，请耐心等待';
      case 2:
        return '您的作品正在处理中，请耐心等待';
      case 3:
        return '您的作品已经生成成功，点击查看';
      case 4:
        return '您的作品生成失败，请重试';
      default:
        return '未知';
    }
  }

  String _getStatus() {
    switch (widget.task.statusCode) {
      case 1:
        return '等待中';
      case 2:
        return '处理中';
      case 3:
        return '已完成';
      case 4:
        return '失败';
      default:
        return '未知';
    }
  }

  Color _getStatusColor() {
    switch (widget.task.statusCode) {
      case 1:
        return Colors.orange;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.green;
      case 4:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _printInfo(String msg) {
    // print('$msg at time: ${DateTime.now()}');
  }

  void _buildContent(BuildContext context) async {
    // _printInfo('buildContent');

    // // 请求Uint8List
    // var response = await Dio()
    //     .get(widget.cover!, options: Options(responseType: ResponseType.bytes));
    // _printInfo('response: $response');
    // var mime = response.headers['content-type']?.first;
    // if (mime == null) {
    //   return;
    // }
    // _printInfo('mime: $mime');
    // ImageProvider imageProvider;

    // // 视频加载缩略图
    // if (mime.startsWith('video')) {
    //   var thumbnail = await VideoThumbnail.thumbnailData(
    //     video: widget.cover!,
    //     imageFormat: ImageFormat.JPEG,
    //     maxWidth: 256,
    //     quality: 60,
    //   );
    //   imageProvider = MemoryImage(thumbnail!);
    // } else {
    //   // 将图片处理为Uint8List
    //   var bytes = response.data;
    //   imageProvider = MemoryImage(bytes);
    // }
    // _printInfo('imageProvider: $imageProvider');

    if (widget.cover == null) {
      return;
    }

    // 图片加载
    Widget content = ExtendedImage(
      image: Image.network(widget.cover!).image,
      enableMemoryCache: true,
      loadStateChanged: (state) {
        if (state.extendedImageLoadState == LoadState.loading) {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: context.theme.primaryColor,
              size: 24,
            ),
          );
        }
        return null;
      },
      width: double.infinity,
      fit: BoxFit.cover,
    );

    if (mounted) {
      setState(() {
        _content = ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: content,
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.task.statusCode == 3) {
        _buildContent(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.task.statusCode == 3) {
          Get.toNamed(AppRouter.generateResultPage, arguments: widget.task);
        } else {
          EasyLoading.showToast(_buildMesage());
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: (widget.task.result != null)
                  ? _content ??
                      Center(
                        child: LoadingAnimationWidget.staggeredDotsWave(
                          color: context.theme.primaryColor,
                          size: 24,
                        ),
                      )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 32),
                          if (widget.task.statusCode == 1 ||
                              widget.task.statusCode == 2)
                            LoadingAnimationWidget.staggeredDotsWave(
                              color: context.theme.primaryColor,
                              size: 24,
                            ),
                          if (widget.task.statusCode == 4)
                            const Icon(Icons.error,
                                size: 32, color: Colors.red),
                          const SizedBox(height: 8),
                          Text(_getStatus()),
                        ],
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.task.function,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _getStatus(),
                        style:
                            TextStyle(fontSize: 12, color: _getStatusColor()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.task.time,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
