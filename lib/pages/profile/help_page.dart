import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('帮助与反馈'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Container(
                height: 172,
                width: double.infinity,
                margin: const EdgeInsets.only(top: 32),
                child: Image(
                  image: ExtendedImage.network(
                    'https://image.thuray.xyz/2024/03/4a3a3d3b575c63d957c944a5fd9f421a.png',
                    width: 172,
                    height: 172,
                    fit: BoxFit.fill,
                  ).image,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Life In Portrai',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: context.theme.primaryColor.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '如果您在使用中遇到问题，或者有任何建议，欢迎联系我们。',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              Text(
                '常见问题',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: context.theme.primaryColor.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 16),
              ...List.generate(
                10,
                (index) => const _HelpItem(
                  title: '如何使用',
                  content: '点击右下角的按钮，选择图片，即可生成头像。',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HelpItem extends StatelessWidget {
  const _HelpItem({super.key, required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.help,
              color: context.theme.primaryColor,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.theme.primaryColor.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
