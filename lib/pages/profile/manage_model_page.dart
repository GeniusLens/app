import 'package:card_swiper/card_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:genius_lens/api/generate.dart';
import 'package:genius_lens/data/entity/generate.dart';
import 'package:genius_lens/router.dart';
import 'package:get/get.dart';

class ManageModelPage extends StatefulWidget {
  const ManageModelPage({super.key});

  @override
  State<ManageModelPage> createState() => _ManageModelPageState();
}

class _ManageModelPageState extends State<ManageModelPage> {
  final List<LoraVO> _models = [];
  int _selectedIndex = 0;

  Future<void> _loadModels() async {
    var list = await GenerateApi.getUserLoraList();
    print("Loading models: $list");
    setState(() {
      _models.clear();
      _models.addAll(list);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadModels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的AI分身'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: (_models.isEmpty)
                      ? const Center(child: CircularProgressIndicator())
                      : Image(
                          image: ExtendedImage.network(
                            _models[_selectedIndex].avatar,
                            cache: true,
                            loadStateChanged: (state) {
                              if (state.extendedImageLoadState ==
                                  LoadState.loading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ).image,
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.1),
                  ),
                ),
                if (_models.isNotEmpty)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Center(
                      child: _InfoCard(model: _models[_selectedIndex]),
                    ),
                  ),
              ],
            ),
          ),
          if (_models.isNotEmpty)
            Container(
              height: 172,
              padding: const EdgeInsets.all(16),
              color: context.theme.cardColor,
              child: Column(
                children: [
                  Text(
                    '${_selectedIndex + 1} / ${_models.length}',
                    style: TextStyle(
                      color: context.theme.primaryColor,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 96,
                    child: Swiper(
                      itemCount: _models.length,
                      scale: 0.8,
                      viewportFraction: 0.35,
                      onIndexChanged: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return _ModelItem(
                            isCurrent: index == _selectedIndex,
                            model: _models[index]);
                      },
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ModelItem extends StatelessWidget {
  const _ModelItem({super.key, required this.isCurrent, required this.model});

  final bool isCurrent;
  final LoraVO model;

  @override
  Widget build(BuildContext context) {
    var size = isCurrent ? 48.0 : 32.0;
    return Container(
      margin: const EdgeInsets.all(8),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isCurrent
              ? context.theme.primaryColor.withOpacity(0.6)
              : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: size / 2,
        backgroundImage: ExtendedImage.network(
          model.avatar,
          cache: true,
        ).image,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({super.key, required this.model});

  final LoraVO model;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width - 32,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.cardColor.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(model.name ?? '',
                  style: TextStyle(
                      fontSize: 24,
                      color: context.theme.primaryColor,
                      fontWeight: FontWeight.bold)),
              const Spacer(),
              // 画一个圆形的按钮
              Container(
                width: 48,
                height: 48,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: context.theme.primaryColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRouter.functionPage);
                  },
                  child: const Icon(Icons.edit, color: Colors.white),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRouter.functionPage);
                  },
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(model.description ?? '',
              style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
