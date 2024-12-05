import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map> getPokemon(String search, int offset) async {
  http.Response response;
  
  if (search == null || search.isEmpty) {
    response = await http.get(Uri.parse("https://pokeapi.co/api/v2/pokemon?limit=25&offset=$offset"));
  } else {
    response = await http.get(Uri.parse("https://pokeapi.co/api/v2/pokemon/$search"));
  }

  return json.decode(response.body);
}
