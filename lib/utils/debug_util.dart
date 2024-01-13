import 'dart:math';

class DebugUtil {
  static const List<String> urls = [
    'https://s2.loli.net/2024/01/02/DKAhyMoIirFN14g.png',
    'https://s2.loli.net/2024/01/02/vJMrj8DL2ftansF.png',
    'https://s2.loli.net/2024/01/02/5SZmQk26KGylxNi.png',
    'https://s2.loli.net/2024/01/02/mqbNn2lt7zhiLRH.png',
    'https://s2.loli.net/2024/01/02/c7eAvwdqZCfFoi5.png',
    'https://s2.loli.net/2024/01/02/vms62xKGAz9yJoP.png',
    'https://s2.loli.net/2024/01/02/C69DKHPB5AiJjQW.png',
    'https://s2.loli.net/2024/01/02/VuBrWOn3NLSyY1s.png',
    'https://s2.loli.net/2024/01/02/xAjSUn1qH7ZzD96.png',
    'https://s2.loli.net/2024/01/02/WA96BESTrsHN4XD.png'
  ];

  static String getRandomImageURL({
    int width = 200,
    int height = 300,
  }) {
    return urls[Random().nextInt(urls.length)];
  }
}
