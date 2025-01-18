class Joke {
  final int id;
  final String type;
  final String setup;
  final String punchline;
  bool isFavorite;

  Joke({required this.id, required this.type, required this.setup, required this.punchline, required this.isFavorite});

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      id: json['id'],
      type: json['type'],
      setup: json['setup'],
      punchline: json['punchline'],
      isFavorite: false
    );
  }
}