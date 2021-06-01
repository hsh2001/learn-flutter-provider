import 'dart:convert';

import 'package:http/http.dart' as http;

class PokeAPI {
  static final limit = 30;

  List<String> pokemons = [];

  int _index = 0;
  get index => _index;

  Future<List<String>> loadPokemons() async {
    final offset = _index * 100;
    final uri = 'https://pokeapi.co/api/v2/pokemon?limit=$limit&offset=$offset';
    final rawResponse = await http.read(Uri.parse(uri));
    _index++;
    final parsedResponse = jsonDecode(rawResponse);
    final results = parsedResponse['results'];

    final List<String> loadedPokemons = List.generate(
      results.length,
      (index) => results[index]['name'],
    );

    pokemons.addAll(loadedPokemons);

    return pokemons;
  }

  Future<Map<String, dynamic>> loadPokemon(String pokemonName) async {
    final uri = 'https://pokeapi.co/api/v2/pokemon/$pokemonName';
    final rawResponse = await http.read(Uri.parse(uri));
    final parsedResponse = jsonDecode(rawResponse);
    return parsedResponse;
  }
}
