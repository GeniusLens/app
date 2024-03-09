import 'package:card_swiper/card_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:genius_lens/api/request/generate.dart';
import 'package:genius_lens/data/entity/generate.dart';
import 'package:genius_lens/router.dart';
import 'package:get/get.dart';

class EntrancePage extends StatefulWidget {
  const EntrancePage({super.key});

  @override
  State<EntrancePage> createState() => _EntrancePageState();
}

class _EntrancePageState extends State<EntrancePage> {
  final List<String> _labels = ["热门", "最新", "推荐"];
  final List<FunctionVO> _functions = [];

  Future<void> _loadFunctions() async {
    var list = await GenerateApi.getRecommendFunction("all");
    setState(() {
      _functions.addAll(list);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFunctions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: _Header()),
            const SliverToBoxAdapter(child: _Functions()),
            const SliverToBoxAdapter(child: _AIModels()),
            SliverToBoxAdapter(child: _TemplatesHeader(labels: _labels)),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: AnimationLimiter(
                child: SliverGrid.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  children: _functions.map((e) {
                    return AnimationConfiguration.staggeredGrid(
                      position: _functions.indexOf(e),
                      duration: const Duration(milliseconds: 375),
                      delay: const Duration(milliseconds: 20),
                      columnCount: 3,
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          child: _TemplateItem(function: e),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            // const SliverToBoxAdapter(child: _EndText()),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatefulWidget {
  const _Header();

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 256,
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 224,
            child: Swiper(
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return ExtendedImage.network(
                  "https://picsum.photos/600/300?random=$index",
                  fit: BoxFit.cover,
                );
              },
              pagination: SwiperPagination(
                margin: const EdgeInsets.only(bottom: 28),
                builder: DotSwiperPaginationBuilder(
                  size: 8,
                  activeSize: 8,
                  color: Colors.grey[300],
                  activeColor: Colors.grey[800],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => Get.toNamed(AppRouter.modelCreatePage),
            child: Container(
              height: 64,
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  color: context.theme.primaryColor,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                child: const Text("创建AI分身",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Functions extends StatefulWidget {
  const _Functions();

  @override
  State<_Functions> createState() => _FunctionsState();
}

class _FunctionsState extends State<_Functions> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Row(
        children: [
          // const Expanded(child: _CategoryItem(label: "所有功能")),
          Expanded(
            child: _CategoryItem(
                icon: Icons.camera_alt_outlined, key: ValueKey("photo")),
          ),
          Expanded(
            child: _CategoryItem(
                icon: Icons.video_camera_front_outlined,
                key: ValueKey("video")),
          ),
          Expanded(
            child: _CategoryItem(
                icon: Icons.music_note_outlined, key: ValueKey("music")),
          ),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({super.key, this.icon, this.label});

  final IconData? icon;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Center(
        child: Container(
          height: 64,
          width: 64,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.theme.cardColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: (icon != null && label == null)
                ? Icon(
                    icon,
                    size: 32,
                    color: Colors.grey[800],
                  )
                : Text(
                    label!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _AIModels extends StatefulWidget {
  const _AIModels();

  @override
  State<_AIModels> createState() => _AIModelsState();
}

class _AIModelsState extends State<_AIModels> {
  final List<LoraVO> _models = [];

  Future<void> _loadModels() async {
    var list = await GenerateApi.getUserLoraList();
    setState(() {
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
    return Container(
      padding: const EdgeInsets.all(16),
      child: (_models.isNotEmpty)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "AI分身",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 224,
                  child: AnimationLimiter(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _models.length,
                      itemBuilder: (BuildContext context, int index) {
                        // return _AIModelItem(lora: _models[index]);
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            horizontalOffset: 50.0,
                            delay: Duration(milliseconds: 20 + 10 * index),
                            child: FadeInAnimation(
                              child: _AIModelItem(lora: _models[index]),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            )
          : null,
    );
  }
}

class _AIModelItem extends StatelessWidget {
  const _AIModelItem({required this.lora});

  final LoraVO lora;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => Get.toNamed(AppRouter.manageModelPage),
            child: Container(
              height: 172,
              width: 128,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.theme.cardColor,
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: ExtendedImage.network(
                    lora.avatar,
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              lora.name ?? '',
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }
}

class _TemplatesHeader extends StatefulWidget {
  const _TemplatesHeader({required this.labels});

  final List<String> labels;

  @override
  State<_TemplatesHeader> createState() => _TemplatesHeaderState();
}

class _TemplatesHeaderState extends State<_TemplatesHeader> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ...List.generate(
            widget.labels.length,
            (index) => GestureDetector(
              onTap: () => setState(() => selectedIndex = index),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: index == selectedIndex
                      ? context.theme.primaryColor
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  widget.labels[index],
                  style: TextStyle(
                    color: index == selectedIndex
                        ? Colors.white
                        : Colors.grey[800],
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _TemplateItem extends StatelessWidget {
  const _TemplateItem({required this.function});

  final FunctionVO function;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      height: 128,
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: ExtendedImage.network(
            function.url!,
            cache: true,
            loadStateChanged: (state) {
              if (state.extendedImageLoadState == LoadState.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state.extendedImageLoadState == LoadState.failed) {
                return const Center(
                  child: Icon(Icons.error),
                );
              }
              return null;
            },
          ).image,
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          switch (function.type) {
            case "solo":
              Get.toNamed(AppRouter.soloGeneratePage, arguments: function);
              break;
            case "multi":
              Get.toNamed(AppRouter.multiGeneratePage, arguments: function);
              break;
            default:
              break;
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          alignment: Alignment.bottomCenter,
          child: Text(
            function.name!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

// class _EndText extends StatelessWidget {
//   const _EndText();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 64,
//       alignment: Alignment.center,
//       child: Text(
//         "—— The End ——",
//         style: TextStyle(color: Colors.grey[600]),
//       ),
//     );
//   }
// }
