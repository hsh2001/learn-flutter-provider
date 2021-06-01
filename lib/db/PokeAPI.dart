import 'dart:convert';

import 'package:http/http.dart' as http;

class PokeAPI {
  static final limit = 100;

  int _index = 0;
  get index => _index;

  Future<List<String>> loadPokemons() async {
    final offset = _index * 100;
    final uri = 'https://pokeapi.co/api/v2/pokemon?limit=$limit&offset=$offset';
    final rawResponse = await http.read(Uri.parse(uri));
    _index++;
    final parsedResponse = jsonDecode(rawResponse);
    final results = parsedResponse['results'];

    return List.generate(results.length, (index) => results[index]['name']);
  }
}
