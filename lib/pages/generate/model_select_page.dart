import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:genius_lens/router.dart';
import 'package:get/get.dart';

import '../../api/request/generate.dart';
import '../../data/entity/generate.dart';

class ModelSelectPage extends StatefulWidget {
  const ModelSelectPage({super.key});

  @override
  State<ModelSelectPage> createState() => _ModelSelectPageState();
}

class _ModelSelectPageState extends State<ModelSelectPage> {
  late final CategoryVO category;
  final List<FunctionVO> _functions = [];

  Future<void> _loadFunctions() async {
    var list = await GenerateApi.getFunctionList(category.name);
    setState(() {
      _functions.clear();
      _functions.addAll(list);
    });
  }

  @override
  void initState() {
    super.initState();
    category = Get.arguments as CategoryVO;
    _loadFunctions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            mainAxisSpacing: 8,
          ),
          itemCount: _functions.length,
          itemBuilder: (context, index) =>
              _ModelItem(function: _functions[index]),
        ),
      ),
    );
  }
}

class _ModelItem extends StatelessWidget {
  const _ModelItem({required this.function});

  final FunctionVO function;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 256 + 64,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
      child: Column(
        children: [
          Expanded(
            child: Container(
              height: 128,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                image: DecorationImage(
                  image: ExtendedImage.network(
                    function.url ?? 'https://picsum.photos/200/300',
                    cache: true,
                    loadStateChanged: (state) {
                      if (state.extendedImageLoadState == LoadState.loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state.extendedImageLoadState ==
                          LoadState.failed) {
                        return const Center(
                          child: Icon(Icons.error),
                        );
                      }
                      return null;
                    },
                  ).image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(function.name ?? '', style: const TextStyle(fontSize: 16)),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    switch (function.type) {
                      case 'solo':
                        Get.toNamed(AppRouter.soloGeneratePage,
                            arguments: function);
                        break;
                      case 'multi':
                        Get.toNamed(AppRouter.multiGeneratePage,
                            arguments: function);
                        break;
                      default:
                        Get.snackbar('错误', '未知的模型类型');
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '使用',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
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
