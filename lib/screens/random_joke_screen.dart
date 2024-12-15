import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/joke_model.dart';

class RandomJokeScreen extends StatefulWidget {
  const RandomJokeScreen({super.key});

  @override
  _RandomJokeScreenState createState() => _RandomJokeScreenState();
}

class _RandomJokeScreenState extends State<RandomJokeScreen> {
  late Future<Joke> _jokeFuture;

  @override
  void initState() {
    super.initState();
    _jokeFuture = ApiService.fetchRandomJoke();
  }

  void _getAnotherJoke() {
    setState(() {
      _jokeFuture = ApiService.fetchRandomJoke();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Random Joke')),
      body: FutureBuilder<Joke>(
        future: _jokeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No joke available'));
          }

          final joke = snapshot.data!;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(joke.setup, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 10),
                Text(joke.punchline, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _getAnotherJoke,
                  child: const Text('Another One'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
