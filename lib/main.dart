import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestion = <WordPair>[];
  final _saved = <WordPair>{};

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          final savedTiles = _saved.map((pair) {
            return ListTile(
              title: Text(pair.asPascalCase),
              trailing: const Icon(Icons.delete),
              onTap: () {
                setState(() {
                  _saved.remove(pair);
                });
              },
            );
          });

          final divided = savedTiles.isNotEmpty
              ? ListTile.divideTiles(context: context, tiles: savedTiles)
                  .toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(
              children: divided,
            ),
          );
        });
      },
    )).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(onPressed: _pushSaved, icon: const Icon(Icons.list))
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();

          final index = i ~/ 2;
          if (index >= _suggestion.length) {
            _suggestion.addAll(generateWordPairs().take(10));
          }

          final alreadySaved = _saved.contains(_suggestion[index]);

          return ListTile(
            title: Text(_suggestion[index].asPascalCase),
            trailing: Icon(
                alreadySaved ? Icons.favorite : Icons.favorite_outline,
                color: alreadySaved ? Colors.red : null,
                semanticLabel: alreadySaved ? 'Remove from saved' : 'Saved'),
            onTap: () {
              setState(() {
                if (alreadySaved) {
                  _saved.remove(_suggestion[index]);
                } else {
                  _saved.add(_suggestion[index]);
                }
              });
            },
          );
        },
      ),
    );
  }
}
