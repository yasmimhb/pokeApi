import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokemon/service/poke_service.dart';

import 'poke_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search = "";
  int _offset = 0;

  @override
  void initState() {
    super.initState();
    getPokemon(_search, _offset).then((map) => print(map));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 247, 29, 29),
        title: Image.network(
          "https://raw.githubusercontent.com/PokeAPI/media/master/logo/pokeapi_256.png",
          height: 50.0,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 10.0), 
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Pokédex",
                labelStyle:
                    TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0), fontSize: 20.0),
              textAlign: TextAlign.center,
              onSubmitted: (value) {
                setState(() {
                  _search = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getPokemon(_search, _offset),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color.fromARGB(255, 0, 0, 0)),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Container(
                        alignment: Alignment.center,
                        child: const Text(
                          "Erro ao carregar Pokémon",
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 20),
                        ),
                      );
                    } else {
                      return _createPokeList(context, snapshot);
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _createPokeList(BuildContext context, AsyncSnapshot snapshot) {
    List pokeList =
        _search.isEmpty ? snapshot.data['results'] : [snapshot.data];

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: pokeList.length + (_search.isEmpty ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < pokeList.length) {
          var poke = pokeList[index];
          var pokeName =
              _search.isEmpty ? poke['name'] : poke['species']['name'];


// Pega o sprite do Pokémon diretamente da API
          var spriteUrl = _search.isEmpty
              ? 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${index + 1 + _offset}.png'
              : poke['sprites']['front_default'];

          return GestureDetector(
            child: Column(
              children: [
                Image.network(
                  spriteUrl ?? 'https://via.placeholder.com/100',
                  height: 100.0,
                  fit: BoxFit.cover,
                ),
                Text(
                  pokeName,
                  style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ],
            ),
            onTap: () async {
              var pokeData = await getPokemon(pokeName, 0);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PokePage(pokeData),
                ),
              );
            },
          );
        } else {
          return Container(
            child: GestureDetector(
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Color.fromARGB(255, 0, 0, 0),
                    size: 70.0,
                  ),
                  Text(
                    "Carregar mais...",
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 22.0),
                  )
                ],
              ),
              onTap: () {
                setState(() {
                  _offset += 20;
                });
              },
            ),
          );
        }
      },
    );
  }
}
