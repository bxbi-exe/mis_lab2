import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/joke_model.dart';

class JokesByTypeScreen extends StatefulWidget {
  final String type;
  final Function(Joke) onFavoriteToggle;

  const JokesByTypeScreen(
      {required this.type, required this.onFavoriteToggle, super.key});

  @override
  _JokesByTypeScreenState createState() => _JokesByTypeScreenState();

}
class _JokesByTypeScreenState extends State<JokesByTypeScreen> {
  late Future<List<Joke>> jokesFuture;
  late List<Joke> jokes;

  @override
  void initState() {
    super.initState();
    jokesFuture = ApiService.fetchJokesByType(widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.type} Jokes'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Joke>>(
        future: jokesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          else {
            jokes = snapshot.data!;
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
                      trailing: IconButton(
                        icon: Icon(
                          jokes[index].isFavorite ? Icons.favorite : Icons
                              .favorite_border,
                          color: jokes[index].isFavorite ? Colors.pink : null,
                        ),
                        onPressed: () {
                          setState(() {
                            jokes[index].isFavorite = !jokes[index].isFavorite;
                          });
                          widget.onFavoriteToggle(jokes[index]);
                        },
                      ),
                    ));
              },
            );
          }
        },
      ),
    );
  }
}
