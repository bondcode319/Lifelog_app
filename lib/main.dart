import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/auth/screens/auth_screen.dart';
import 'features/home/screens/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://xhhnyjbupvzvcjyhqktf.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhoaG55amJ1cHZ6dmNqeWhxa3RmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMzMzM4MzAsImV4cCI6MjA2ODkwOTgzMH0.9C3TQVbXHC6qj4HAnBY-_kCiZolM4okrlFi5AewaFEM',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeLog',
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthGate(),
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      return const AuthScreen();
    } else {
      return const HomePage();
    }
  }
}
