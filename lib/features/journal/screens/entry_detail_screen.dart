import 'package:flutter/material.dart';

class EntryDetailScreen extends StatelessWidget {
  final Map entry;
  const EntryDetailScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(entry['title'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mood:  ${entry['mood']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(entry['body'], style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text('Created: ${entry['created_at']}'),
          ],
        ),
      ),
    );
  }
}
