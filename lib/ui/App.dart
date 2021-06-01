import 'package:flutter/material.dart';

import 'PokemonList.dart';

class App extends StatelessWidget {
  Widget _appBar() {
    return AppBar(
      title: Text('PokèDex'),
    );
  }

  Widget _container({Widget child}) {
    return MaterialApp(
      title: 'PokeDex',
      theme: ThemeData(primaryColor: Colors.red),
      home: Scaffold(
        appBar: _appBar(),
        body: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _container(
      child: PokemonList(),
    );
  }
}
