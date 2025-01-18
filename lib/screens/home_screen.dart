import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/joke_model.dart';
import '../services/api_service.dart';
import 'favorite_jokes_screen.dart';
import 'jokes_screen.dart';
import 'random_joke_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<String>> jokeTypes;
  List<Joke> favoriteJokes = [];
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    jokeTypes = ApiService.fetchJokeTypes();
    _initializeNotifications();
    _scheduleDailyNotification();
  }

  void _initializeNotifications() async {
    final androidInitializationSettings = AndroidInitializationSettings('app_icon');
    final initializationSettings = InitializationSettings(android: androidInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _scheduleDailyNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'daily_id',
      'Daily Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      'New Daily Joke!',
      'Check the Joke Now!',
      RepeatInterval.daily,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exact,
    );
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
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FavoriteJokesScreen(
                  favoriteJokes: favoriteJokes, // Pass the actual favoriteJokes list
                ),
              ),
            );
          },
        )],
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
                        builder: (context) => JokesByTypeScreen(type: type, onFavoriteToggle: (Joke joke) {
                          setState(() {
                            if (joke.isFavorite){
                              favoriteJokes.add(joke);
                            } else {
                              favoriteJokes.removeWhere((faveJoke) => faveJoke.id == joke.id);
                            }
                          });
                        },),
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
