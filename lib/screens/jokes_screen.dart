import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/joke_model.dart';

class JokesByTypeScreen extends StatelessWidget {
  final String type;

  const JokesByTypeScreen({required this.type, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$type Jokes'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Joke>>(
        future: ApiService.fetchJokesByType(type),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No jokes available.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final joke = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(joke.setup),
                  subtitle: Text(joke.punchline),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
