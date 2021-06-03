import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './Navigation.dart';
import './PokemonList.dart';
import '../provider/NavigationProvider.dart';
import '../provider/FavoritePokemonsProvider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  NavigationProvider _navigationProvider;

  @override
  Widget build(BuildContext context) {
    _navigationProvider = Provider.of<NavigationProvider>(context);

    switch (_navigationProvider.curruntIndex) {
      case 0:
      case 1:
        return PokemonList();

      default:
        return Center(child: Text('UNKNWON ERROR...'));
    }
  }
}

class App extends StatelessWidget {
  Widget _appBar() {
    return AppBar(
      title: Text('PokèDex'),
    );
  }

  Widget _container({Widget child}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FavoritePokemonsProvider()),
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
      ],
      child: MaterialApp(
        title: 'PokeDex',
        theme: ThemeData(primaryColor: Colors.red),
        home: Scaffold(
          appBar: _appBar(),
          body: child,
          bottomNavigationBar: Navigation(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _container(child: Home());
  }
}
