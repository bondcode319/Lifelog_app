import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'entry_detail_screen.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});
  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  double _mood = 3;
  bool _isLoading = false;

  Future<bool> _hasEntryToday(String userId) async {
    final today = DateTime.now();
    final start =
        DateTime(today.year, today.month, today.day).toIso8601String();
    final end =
        DateTime(
          today.year,
          today.month,
          today.day,
          23,
          59,
          59,
          999,
        ).toIso8601String();
    final response = await Supabase.instance.client
        .from('journal_entries')
        .select()
        .eq('user_id', userId)
        .gte('created_at', start)
        .lte('created_at', end);
    return response.isNotEmpty;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    if (await _hasEntryToday(userId)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You already have an entry for today!')),
        );
      }
      setState(() => _isLoading = false);
      return;
    }
    final insertResponse =
        await Supabase.instance.client.from('journal_entries').insert({
          'user_id': userId,
          'title': _titleController.text.trim(),
          'body': _bodyController.text.trim(),
          'mood': _mood.round(),
        }).select();
    if (insertResponse == null ||
        (insertResponse is List && insertResponse.isEmpty)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save entry. Please try again.'),
          ),
        );
      }
      setState(() => _isLoading = false);
      return;
    }
    setState(() => _isLoading = false);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => EntryDetailScreen(entry: insertResponse[0]),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(labelText: 'Body'),
                maxLines: 4,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Mood:'),
                  Expanded(
                    child: Slider(
                      value: _mood,
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: _mood.round().toString(),
                      onChanged: (v) => setState(() => _mood = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Save Entry'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
