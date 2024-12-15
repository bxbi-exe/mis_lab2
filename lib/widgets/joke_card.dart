import 'package:flutter/material.dart';

class JokeCard extends StatelessWidget {
  final String type;
  final VoidCallback onTap;

  const JokeCard({
    required this.type,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          child: Text(
            type,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
