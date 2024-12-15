import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/joke_model.dart';

class ApiService {
  static const String _baseUrl = 'https://official-joke-api.appspot.com';

  static Future<List<String>> fetchJokeTypes() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/types'));
      if (response.statusCode == 200) {
        return List<String>.from(json.decode(response.body));
      } else {
        throw Exception('Failed to load joke types: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching joke types: $e');
    }
  }

  static Future<List<Joke>> fetchJokesByType(String type) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/jokes/$type/ten'));
      if (response.statusCode == 200) {
        final List jokes = json.decode(response.body);
        return jokes.map((j) => Joke.fromJson(j)).toList();
      } else {
        throw Exception('Failed to load jokes: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching jokes by type: $e');
    }
  }

  static Future<Joke> fetchRandomJoke() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/random_joke'));
      if (response.statusCode == 200) {
        return Joke.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load random joke: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching random joke: $e');
    }
  }
}
