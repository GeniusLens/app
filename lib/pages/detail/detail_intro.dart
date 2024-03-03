import 'package:flutter/material.dart';
import 'package:genius_lens/constants.dart';

class DetailIntro extends StatefulWidget {
  const DetailIntro({super.key});

  @override
  State<DetailIntro> createState() => _DetailIntroState();
}

class _DetailIntroState extends State<DetailIntro> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                '数十种模板，创造独一无二的个人专属写真',
                style: TextStyle(
                  fontSize: Constants.subtitleSize,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              color: Colors.redAccent,
              icon: const Icon(Icons.favorite_outline),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text('        欢迎体验我们的主题写真功能，您可以轻松打造专属于个人风格的写真集。请按照以下步骤操作：',
              style: TextStyle(color: Colors.grey[900])),
        ),
        const SizedBox(height: 8),
        const Row(
          children: [
            SizedBox(width: 8),
            Expanded(
              child: Text(
                '        1. 选择一个主题模板：我们提供了多种主题供您选择，如圣诞、春节、热门IP、民族风情等。',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Row(
          children: [
            SizedBox(width: 8),
            Expanded(
              child: Text(
                '        2. 选择您想使用的AI分身。',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Row(
          children: [
            SizedBox(width: 8),
            Expanded(
              child: Text(
                '        3. 个性化调整：一旦系统生成了主题写真，您可以使用“更像我一点”功能进行个性化调整，确保最终写真贴近您的个人风格和审美。',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Row(
          children: [
            SizedBox(width: 8),
            Expanded(
              child: Text(
                '        请确保您上传的照片清晰且多样，以便系统更准确地捕捉您的风格和表情，从而创造出独一无二的个性化写真。我们的智能处理技术将保证照片的质感和合成效果，让您的创意得以完美呈现。开始创作，展现您的创意和独特风格吧！',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
