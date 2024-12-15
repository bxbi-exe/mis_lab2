import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'jokes_screen.dart';
import 'random_joke_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<String>> jokeTypes;

  @override
  void initState() {
    super.initState();
    jokeTypes = ApiService.fetchJokeTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('211041 JokesApp'),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: [
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RandomJokeScreen()),
            ),
            child: const Text(
              'Random Joke',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: jokeTypes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No joke types available'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            padding: const EdgeInsets.all(8.0),
            itemBuilder: (context, index) {
              final type = snapshot.data![index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: ListTile(
                  title: Text(type.toUpperCase()),
                  trailing: const Icon(Icons.arrow_forward),
                  tileColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JokesByTypeScreen(type: type),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
