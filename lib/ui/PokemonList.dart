import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../db/PokeApi.dart';
import '../provider/NavigationProvider.dart';
import '../provider/FavoritePokemonsProvider.dart';

final pokeAPI = PokeAPI();

class _PokemonDetails extends StatelessWidget {
  final String name;

  _PokemonDetails({
    @required this.name,
  }) : super();

  Widget _image(String src) {
    if (src == null) {
      return Container();
    }

    return Container(
      margin: EdgeInsets.only(right: 10),
      child: Image.network(
        src,
        cacheHeight: 100,
        cacheWidth: 100,
      ),
    );
  }

  Widget _type(String typeName) {
    return Container(
      child: Text(typeName),
      color: Colors.white,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(right: 5),
    );
  }

  Widget _types(List<dynamic> typeMaps) {
    return Row(
      children: List.generate(
        typeMaps.length,
        (index) => _type(typeMaps[index]['type']['name']),
      ),
    );
  }

  Widget _container({List<Widget> children}) {
    return Container(
      height: 100,
      child: Row(children: children),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: pokeAPI.loadPokemon(name),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final data = snapshot.data;

        if (data == null) {
          return _container(children: [
            Center(
              child: Text(
                'LOADING...',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ]);
        }

        final _weight = Container(
          margin: EdgeInsets.only(top: 5),
          child: Text('${data['weight'] / 10}kg'),
        );

        final _info = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _types(data['types']),
            _weight,
          ],
        );

        final row = Row(children: [
          Center(child: _image(data['sprites']['front_default'])),
          _info,
        ]);

        return _container(children: [row]);
      },
    );
  }
}

class _Pokemon extends StatefulWidget {
  final String name;

  _Pokemon({
    Key key,
    @required this.name,
  }) : super(key: key);

  @override
  __PokemonState createState() => __PokemonState();
}

class __PokemonState extends State<_Pokemon> {
  FavoritePokemonsProvider _favoritePokemonsProvider;

  Widget _title() {
    final text = Text(
      '${widget.name.toUpperCase()} ',
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      softWrap: false,
      style: TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 25,
      ),
    );

    return Flexible(
      child: Container(child: text),
    );
  }

  Widget _favoraiteButton(BuildContext context) {
    final checked = _favoritePokemonsProvider.list.contains(widget.name);
    final icon = checked ? Icons.favorite : Icons.favorite_border;
    final color = checked ? Colors.pink : Colors.grey;

    final showSnakBar = ({String content, Function onClickUndo}) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: onClickUndo,
        ),
      ));
    };

    final onTap = () {
      if (checked) {
        _favoritePokemonsProvider.delete(widget.name);
        showSnakBar(
          content: '${widget.name.toUpperCase()} is successfully deleted.',
          onClickUndo: () => _favoritePokemonsProvider.add(widget.name),
        );
      } else {
        _favoritePokemonsProvider.add(widget.name);
        showSnakBar(
          content: 'You like ${widget.name.toUpperCase()}!',
          onClickUndo: () => _favoritePokemonsProvider.delete(widget.name),
        );
      }
    };

    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        color: color,
      ),
    );
  }

  Widget _container({List<Widget> children}) {
    return Container(
      child: Column(children: children),
      padding: EdgeInsets.all(30),
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      color: Colors.grey[200],
    );
  }

  @override
  Widget build(BuildContext context) {
    _favoritePokemonsProvider = Provider.of<FavoritePokemonsProvider>(context);
    return _container(children: [
      Row(children: [
        _title(),
        _favoraiteButton(context),
      ]),
      Row(children: [_PokemonDetails(name: widget.name)]),
    ]);
  }
}

class PokemonList extends StatefulWidget {
  @override
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  NavigationProvider _navigationProvider;
  FavoritePokemonsProvider _favoritePokemonsProvider;

  Widget _container({List<Widget> children}) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: NotificationListener(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return children.length > index ? children[index] : null;
          },
        ),
      ),
    );
  }

  Widget _pokemons(List<String> pokemonNames) {
    return _container(
      children: List<Widget>.generate(
        pokemonNames.length,
        (index) => _Pokemon(
          key: ValueKey(pokemonNames[index]),
          name: pokemonNames[index],
        ),
      ),
    );
  }

  Widget _allPokemons() {
    return FutureBuilder(
      future: pokeAPI.loadPokemons(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final List<String> data = snapshot.data ?? [];
        return _pokemons(data);
      },
    );
  }

  Widget _favoritePokemons() {
    final list = _favoritePokemonsProvider.list;

    if (list.length > 0) {
      return _pokemons(list);
    }

    return Center(
      child: Text('You have no favorite pokèmons.'),
    );
  }

  @override
  Widget build(BuildContext context) {
    _navigationProvider = Provider.of<NavigationProvider>(context);
    _favoritePokemonsProvider = Provider.of<FavoritePokemonsProvider>(context);

    switch (_navigationProvider.curruntIndex) {
      case 0:
        return _allPokemons();

      case 1:
        return _favoritePokemons();

      default:
        return Center(child: Text('...ERROR...'));
    }
  }
}
