import 'package:card_swiper/card_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:genius_lens/api/user_model.dart';
import 'package:genius_lens/data/entity/user_model.dart';
import 'package:get/get.dart';

class ModelManagePage extends StatefulWidget {
  const ModelManagePage({super.key});

  @override
  State<ModelManagePage> createState() => _ModelManagePageState();
}

class _ModelManagePageState extends State<ModelManagePage> {
  List<UserModelEntity> models = [];
  bool _hasError = false;
  bool _isLoading = false;

  Future<void> _getModels() async {
    try {
      setState(() {
        _hasError = false;
        _isLoading = true;
      });
      models = await UserModelApi().getModels();
    } catch (e) {
      Get.snackbar('错误', '获取数据失败');
      setState(() {
        _hasError = true;
      });
    }
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    _getModels();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('创建分身'),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: (models.isEmpty)
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isLoading) const CircularProgressIndicator(),
                        if (_hasError)
                          IconButton(
                            onPressed: () => _getModels(),
                            icon: const Icon(Icons.refresh, size: 48),
                          ),
                        const SizedBox(height: 16),
                        if (_isLoading) const Text('正在加载...'),
                        if (_hasError) const Text('轻触重试'),
                      ],
                    ),
                  )
                : Swiper(
                    itemCount: models.length,
                    transformer: ScaleAndFadeTransformer(),
                    scale: 0.9,
                    fade: 0.6,
                    viewportFraction: 0.8,
                    pagination: const SwiperPagination(
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.only(bottom: 16),
                      builder: DotSwiperPaginationBuilder(
                        color: Colors.grey,
                        activeColor: Colors.white,
                        size: 6,
                        activeSize: 8,
                        space: 4,
                      ),
                    ),
                    itemBuilder: (context, index) {
                      var item = models[index];

                      return Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: ExtendedImage.network(
                              item.coverUrl,
                              cache: true,
                              fit: BoxFit.cover,
                            ).image,
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: (item.isDemo)
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.add_circle_rounded,
                                        color: Colors.white,
                                        size: 48,
                                      ),
                                    ),
                                    const Text(
                                      '点击创建',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 48),
                                  ],
                                ),
                              )
                            : Column(
                                children: [
                                  const SizedBox(height: 24),
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item.description,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
