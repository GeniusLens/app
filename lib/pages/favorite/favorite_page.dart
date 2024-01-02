import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:genius_lens/constants.dart';
import 'package:genius_lens/pages/favorite/favorite_card.dart';
import 'package:genius_lens/utils/debug_util.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final List<Demo> _demoList = [
    Demo(
      'https://s2.loli.net/2024/01/02/DKAhyMoIirFN14g.png',
      '收藏内容',
      '收藏内容（预设/风格）介绍',
    ),
    Demo(
      'https://s2.loli.net/2024/01/02/vJMrj8DL2ftansF.png',
      '收藏内容',
      '收藏内容（预设/风格）介绍',
    ),
    Demo(
      'https://s2.loli.net/2024/01/02/5SZmQk26KGylxNi.png',
      '收藏内容',
      '收藏内容（预设/风格）介绍',
    ),
    Demo(
      'https://s2.loli.net/2024/01/02/mqbNn2lt7zhiLRH.png',
      '收藏内容',
      '收藏内容（预设/风格）介绍',
    ),
    Demo(
      'https://s2.loli.net/2024/01/02/c7eAvwdqZCfFoi5.png',
      '收藏内容',
      '收藏内容（预设/风格）介绍',
    ),
    Demo(
      'https://s2.loli.net/2024/01/02/vms62xKGAz9yJoP.png',
      '收藏内容',
      '收藏内容（预设/风格）介绍',
    ),
    Demo(
      'https://s2.loli.net/2024/01/02/C69DKHPB5AiJjQW.png',
      '收藏内容',
      '收藏内容（预设/风格）介绍',
    ),
    Demo(
      'https://s2.loli.net/2024/01/02/VuBrWOn3NLSyY1s.png',
      '收藏内容',
      '收藏内容（预设/风格）介绍',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Constants.globalPadding),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: const Text('收藏'),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
                // 在App Bar底部扩展空间显示搜索框
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(48),
                  child: TextField(
                    decoration: InputDecoration(
                      // Use no border outline to avoid the extra padding
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        // Use transparent color to avoid the extra padding
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      isDense: true,
                      constraints: const BoxConstraints(maxHeight: 48),
                      hintText: '搜索收藏',
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              // 占位符
              const SliverToBoxAdapter(
                child: SizedBox(height: 8),
              ),
              SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  return FavoriteCard(_demoList[index]);
                },
                itemCount: _demoList.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
