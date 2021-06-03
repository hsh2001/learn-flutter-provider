import 'package:flutter/material.dart';

class FavoritePokemonsProvider extends ChangeNotifier {
  List<String> _list = [];

  List<String> get list => _list;

  add(String name) {
    _list.add(name);
    notifyListeners();
  }

  delete(String name) {
    _list.remove(name);
    notifyListeners();
  }

  clear() {
    _list = [];
    notifyListeners();
  }
}
