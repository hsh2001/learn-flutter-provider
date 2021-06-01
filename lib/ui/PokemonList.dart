import 'package:flutter/material.dart';
import 'package:flutter_application_1/db/PokeApi.dart';

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

class _Pokemon extends StatelessWidget {
  final String name;

  _Pokemon({
    @required this.name,
  }) : super();

  Widget _title() {
    final text = Text(
      '${name.toUpperCase()}',
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
    return _container(children: [
      Row(children: [_title()]),
      Row(children: [_PokemonDetails(name: name)]),
    ]);
  }
}

class PokemonList extends StatefulWidget {
  @override
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  Widget _container({List<Widget> children}) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: NotificationListener(
        child: ListView(children: children),
        onNotification: (notification) {
          if (notification is ScrollEndNotification) {
            setState(() {});
          }

          return true;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: pokeAPI.loadPokemons(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final List<String> data = snapshot.data == null ? [] : snapshot.data;
        print(data.length);
        return _container(
          children: List<Widget>.generate(
            data.length,
            (index) => _Pokemon(name: data[index]),
          ),
        );
      },
    );
  }
}
