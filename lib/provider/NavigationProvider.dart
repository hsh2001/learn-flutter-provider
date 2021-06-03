import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _curruntIndex = 0;

  get curruntIndex => _curruntIndex;

  void setIndex(int newIndex) {
    _curruntIndex = newIndex;
    notifyListeners();
  }

  void goHome() {
    setIndex(0);
  }

  void goFavoraiteList() {
    setIndex(1);
  }
}
