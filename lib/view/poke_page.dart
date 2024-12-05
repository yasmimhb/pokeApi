import 'package:flutter/material.dart';

class PokePage extends StatelessWidget {
  final Map _poke;

  const PokePage(this._poke, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_poke["name"] ?? "Detalhes do Pokémon"),
        backgroundColor: const Color.fromARGB(255, 196, 187, 187),
      ),
      backgroundColor: const Color.fromARGB(255, 196, 187, 187),
      body: Center(
        child: Image.network(_poke["sprites"]["front_default"] ??
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/0.png'), 
      ),
    );
  }
}


