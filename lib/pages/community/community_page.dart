import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:genius_lens/constants.dart';
import 'package:genius_lens/pages/community/community_card.dart';
import 'package:get/get.dart';

class EEE {
  String url;
  String? title;

  EEE(this.url, this.title);
}

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage>
    with TickerProviderStateMixin {
  final double _basicWidth = Get.width * 0.618;

  int _selectedIndex = 0;

  late final AnimationController _animationController;
  late final Animation<double> _animation;

  final List<EEE> _demoList = [
    EEE('https://s2.loli.net/2024/01/02/xAjSUn1qH7ZzD96.png', '真是绝绝子鸭！jrm！'),
    EEE('https://s2.loli.net/2024/01/02/WA96BESTrsHN4XD.png', '！！！'),
    EEE('https://s2.loli.net/2024/01/02/c7eAvwdqZCfFoi5.png', null),
    EEE('https://s2.loli.net/2024/01/02/C69DKHPB5AiJjQW.png', '绝赞好APP！'),
    EEE('https://s2.loli.net/2024/01/02/rMwgsZpzCj6vOuE.png', '绝赞好APP！'),
    EEE('https://s2.loli.net/2024/01/02/vJMrj8DL2ftansF.png', '绝赞好APP！'),
    EEE('https://picsum.photos/200/300', 'title7'),
    EEE('https://picsum.photos/200/300', 'title8'),
    EEE('https://picsum.photos/200/300', 'title9'),
    EEE('https://picsum.photos/200/300', 'title10'),
    ];

  void _playAnimation() {
    _animationController.reset();
    _animationController.forward();
  }

  Widget _buildBarText(String text, int index) {
    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = index);
        _playAnimation();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _selectedIndex == index ? _animation.value : 1.0,
              child: Text(
                text,
                style: TextStyle(
                  color: _selectedIndex == index
                      ? Colors.grey[900]
                      : Colors.grey[600],
                  fontSize: Constants.bodySize,
                  // fontSize: _selectedIndex == index
                  //     ? Constants.titleSize
                  //     : Constants.bodySize,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopTabBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildBarText('推荐', 0),
        _buildBarText('热门', 1),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _animation =
        Tween<double>(begin: 1.0, end: 1.2).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: _buildTopTabBar(),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: Constants.globalPadding),
          child: MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            itemBuilder: (context, index) {
              var height = _basicWidth + 32 * Random().nextInt(3);
              return GestureDetector(
                onTap: () {
                  Get.toNamed('/community/detail');
                },
                child: SizedBox(
                  height: height,
                  child: CommunityCard(_demoList[index]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
