import 'package:flutter/material.dart';
import 'package:genius_lens/data/entity/community.dart';
import 'package:genius_lens/data/entity/generate.dart';

class CommunityProvider extends ChangeNotifier {
  CommunityVO? _community;

  CommunityVO? get community => _community;

  void setCommunity(CommunityVO community) {
    _community = community;
    notifyListeners();
  }

  void updateFunction(FunctionVO function) {
    _community?.function = function;
    notifyListeners();
  }

  void clearCommunity() {
    _community = null;
    notifyListeners();
  }
}
