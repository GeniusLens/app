import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:genius_lens/api/request/generate.dart';
import 'package:genius_lens/data/entity/generate.dart';
import 'package:genius_lens/router.dart';
import 'package:get/get.dart';

class MultiGeneratePage extends StatefulWidget {
  const MultiGeneratePage({super.key});

  @override
  State<MultiGeneratePage> createState() => _MultiGeneratePageState();
}

class _MultiGeneratePageState extends State<MultiGeneratePage> {
  late final FunctionVO function;

  final List<LoraVO> _loras = [];
  final Map<int, bool> _selected = {};

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
        title: const Text('多人生成'),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                ),
                itemCount: _loras.length,
                itemBuilder: (context, index) => _MultiGenerateItem(
                    model: _loras[index],
                    selected: _selected[index] ?? false,
                    onTap: () {
                      setState(() {
                        if (_selected[index] ?? false) {
                          _selected[index] = false;
                        } else {
                          _selected[index] = true;
                        }
                      });
                    }),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_selected.isEmpty) {
                  EasyLoading.showToast('请选择一个分身');
                  return;
                }
                GenerateApi.submitTask(f: function, lora: _loras, images: [
                  "https://image.thuray.xyz/2024/03/7a0806fe815131850a4b0b5cb8d311e1.png",
                ]);
                Get.offNamed(AppRouter.manageTaskPage);
              },
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
                child: const Center(
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

class _MultiGenerateItem extends StatelessWidget {
  const _MultiGenerateItem(
      {super.key, required this.model, this.selected = false, this.onTap});

  final LoraVO model;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          CircleAvatar(
            radius: 64,
            backgroundImage: ExtendedImage.network(
              model.avatar,
              fit: BoxFit.fill,
            ).image,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    model.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Checkbox(
                    value: selected,
                    shape: const CircleBorder(),
                    activeColor: context.theme.primaryColor,
                    onChanged: (value) {
                      onTap?.call();
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
