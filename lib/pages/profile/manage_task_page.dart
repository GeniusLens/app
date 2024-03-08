import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:genius_lens/api/request/generate.dart';
import 'package:genius_lens/data/entity/generate.dart';
import 'package:genius_lens/router.dart';
import 'package:genius_lens/utils/debug_util.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ManageTaskPage extends StatefulWidget {
  const ManageTaskPage({super.key});

  @override
  State<ManageTaskPage> createState() => _ManageTaskPageState();
}

class _ManageTaskPageState extends State<ManageTaskPage> {
  final List<TaskVO> _tasks = [];

  Future<void> _loadData() async {
    var data = await GenerateApi.getTaskList();
    setState(() {
      _tasks.clear();
      _tasks.addAll(data);
    });
  }

  @override
  void initState() {
    super.initState();
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: RefreshIndicator(
          onRefresh: () => _loadData(),
          child: (_tasks.isNotEmpty)
              ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    return _TaskItem(task: _tasks[index]);
                  },
                )
              : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.hourglass_empty, size: 32),
                      const SizedBox(height: 8),
                      Text('暂无作品'),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class _TaskItem extends StatelessWidget {
  const _TaskItem({required this.task});

  final TaskVO task;

  String _buildMesage() {
    switch (task.statusCode) {
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
    switch (task.statusCode) {
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
    switch (task.statusCode) {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (task.statusCode == 3) {
          Get.toNamed(AppRouter.generateResultPage, arguments: task);
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
              child: (task.result != null)
                  ? ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      child: ExtendedImage.network(
                        task.result ?? DebugUtil.getRandomImageURL(),
                        loadStateChanged: (state) {
                          if (state.extendedImageLoadState ==
                              LoadState.loading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return null;
                        },
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 32),
                        if (task.statusCode == 1 || task.statusCode == 2)
                          LoadingAnimationWidget.staggeredDotsWave(
                            color: context.theme.primaryColor,
                            size: 24,
                          ),
                        if (task.statusCode == 4)
                          const Icon(Icons.error, size: 32, color: Colors.red),
                        const SizedBox(height: 8),
                        Text(_getStatus()),
                      ],
                    )),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        task.function,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Text(
                        _getStatus(),
                        style:
                            TextStyle(fontSize: 12, color: _getStatusColor()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.time,
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
