class DebugModel {
  final String? title;
  final String? description;
  final String? image;

  DebugModel({this.title, this.description, this.image});

  static List<DebugModel> mocks() {
    return [
      DebugModel(
        title: '单人写真',
        description: '将给定的一张照片与指定的“AI分身”进行脸部替换',
        image: 'https://picsum.photos/200/300',
      ),
      DebugModel(
        title: '多人写真',
        description: '适用于各种场合，如婚纱照、闺蜜照、全家福、毕业合照等',
        image: 'https://picsum.photos/200/300',
      ),
      DebugModel(
        title: '萌宠合照',
        description: '为自己的宠物创造出有趣的人工智能互动场景',
        image: 'https://picsum.photos/200/300',
      ),
      DebugModel(
        title: 'AI趣穿搭',
        description: '上传自己的衣物和饰品照片，通过AI的智能穿搭生成获得独特的时尚灵感',
        image: 'https://picsum.photos/200/300',
      ),
      DebugModel(
        title: 'AI趣编辑',
        image: 'https://picsum.photos/200/300',
      ),
      DebugModel(
        title: '创意视频',
        image: 'https://picsum.photos/200/300',
      ),
    ];
  }
}
