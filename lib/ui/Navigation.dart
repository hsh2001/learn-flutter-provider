import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/NavigationProvider.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  NavigationProvider _navigationProvider;

  @override
  Widget build(BuildContext context) {
    _navigationProvider = Provider.of<NavigationProvider>(context);

    print(_navigationProvider.curruntIndex);

    return BottomNavigationBar(
      fixedColor: Colors.red,
      currentIndex: _navigationProvider.curruntIndex,
      onTap: _navigationProvider.setIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'All',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
      ],
    );
  }
}
