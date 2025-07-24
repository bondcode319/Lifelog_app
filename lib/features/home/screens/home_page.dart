import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../journal/screens/add_entry_screen.dart';
import '../../journal/screens/entry_detail_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<dynamic>> _fetchEntries() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    final response = await Supabase.instance.client
        .from('journal_entries')
        .select()
        .eq('user_id', userId ?? '')
        .order('created_at', ascending: false);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LifeLog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/auth');
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchEntries(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final entries = snapshot.data!;
          if (entries.isEmpty) {
            return const Center(child: Text('No journal entries yet.'));
          }
          // Group by date
          Map<String, List<dynamic>> grouped = {};
          for (var entry in entries) {
            final date = entry['created_at'].substring(0, 10);
            grouped.putIfAbsent(date, () => []).add(entry);
          }
          final dates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
          return ListView.builder(
            itemCount: dates.length,
            itemBuilder: (context, i) {
              final date = dates[i];
              final dayEntries = grouped[date]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      date,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...dayEntries.map(
                    (entry) => ListTile(
                      title: Text(entry['title']),
                      subtitle: Text('Mood:  ${entry['mood']}'),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => EntryDetailScreen(entry: entry),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const AddEntryScreen()));
          if (result == true) setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
