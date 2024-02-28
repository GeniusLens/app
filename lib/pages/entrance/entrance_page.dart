import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:genius_lens/router.dart';
import 'package:get/get.dart';

class EntrancePage extends StatefulWidget {
  const EntrancePage({super.key});

  @override
  State<EntrancePage> createState() => _EntrancePageState();
}

class _EntrancePageState extends State<EntrancePage> {
  final List<String> _labels = ["热门", "最新", "AI分身", "AI模板"];
  int _selectedIndex = 0;

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
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                      (context, index) => const _TemplateItem(),
                  childCount: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
            ),
            const SliverToBoxAdapter(child: _EndText()),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatefulWidget {
  const _Header({super.key});

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
                return Image.network(
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
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
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
  const _Functions({super.key});

  @override
  State<_Functions> createState() => _FunctionsState();
}

class _FunctionsState extends State<_Functions> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Expanded(child: _FunctionItem(label: "所有功能")),
            ...List.generate(
              3,
              (index) => const Expanded(
                child: _FunctionItem(icon: Icons.camera_alt_outlined),
              ),
            ),
          ],
        ));
  }
}

class _FunctionItem extends StatelessWidget {
  const _FunctionItem({super.key, this.icon, this.label});

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
  const _AIModels({super.key});

  @override
  State<_AIModels> createState() => _AIModelsState();
}

class _AIModelsState extends State<_AIModels> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "AI分身",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return const _AIModelItem();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AIModelItem extends StatelessWidget {
  const _AIModelItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Center(
        child: GestureDetector(
          onTap: () => Get.toNamed(AppRouter.manageModelPage),
          child: Container(
            height: 172,
            width: 128,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.theme.cardColor,
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: NetworkImage("https://picsum.photos/200/300"),
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
      ),
    );
  }
}

class _TemplatesHeader extends StatefulWidget {
  const _TemplatesHeader({super.key, required this.labels});

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
  const _TemplateItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      height: 128,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        image: const DecorationImage(
          image: NetworkImage("https://picsum.photos/200/300"),
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
    );
  }
}

class _EndText extends StatelessWidget {
  const _EndText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      alignment: Alignment.center,
      child: Text(
        "—— The End ——",
        style: TextStyle(color: Colors.grey[600]),
      ),
    );
  }
}
