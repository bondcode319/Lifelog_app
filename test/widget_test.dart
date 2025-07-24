// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifelog/main.dart';
import 'package:lifelog/features/auth/screens/auth_screen.dart';
import 'package:lifelog/features/auth/screens/login_screen.dart';
import 'package:lifelog/features/auth/screens/signup_screen.dart';
import 'package:lifelog/features/home/screens/home_page.dart';
import 'package:lifelog/features/journal/screens/add_entry_screen.dart';
import 'package:lifelog/features/journal/screens/entry_detail_screen.dart';

void main() {
  testWidgets('AuthGate shows AuthScreen when not logged in', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: AuthGate()));
    expect(find.byType(AuthScreen), findsOneWidget);
  });

  testWidgets('AuthScreen toggles between Login and Signup', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: AuthScreen()));
    expect(find.byType(LoginScreen), findsOneWidget);
    await tester.tap(find.text("Don't have an account? Sign Up"));
    await tester.pumpAndSettle();
    expect(find.byType(SignupScreen), findsOneWidget);
    await tester.tap(find.text('Already have an account? Login'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('LoginScreen form validation', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: LoginScreen(onToggleMode: () {})),
    );
    await tester.tap(find.text('Login'));
    await tester.pump();
    expect(find.text('Please enter a valid email address.'), findsOneWidget);
    expect(
      find.text('Password must be at least 6 characters long.'),
      findsOneWidget,
    );
  });

  testWidgets('SignupScreen form validation', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: SignupScreen(onToggleMode: () {})),
    );
    await tester.tap(find.text('Sign Up'));
    await tester.pump();
    expect(find.text('Please enter a valid email address.'), findsOneWidget);
    expect(
      find.text('Password must be at least 6 characters long.'),
      findsOneWidget,
    );
  });

  testWidgets('HomePage renders and shows add button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('AddEntryScreen renders form fields', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: AddEntryScreen()));
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(Slider), findsOneWidget);
    expect(find.text('Save Entry'), findsOneWidget);
  });

  testWidgets('EntryDetailScreen displays entry details', (
    WidgetTester tester,
  ) async {
    final entry = {
      'title': 'Test Title',
      'body': 'Test Body',
      'mood': 4,
      'created_at': '2023-10-27T12:00:00Z',
    };
    await tester.pumpWidget(MaterialApp(home: EntryDetailScreen(entry: entry)));
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Body'), findsOneWidget);
    expect(find.textContaining('Mood: 4'), findsOneWidget);
    expect(
      find.textContaining('Created: 2023-10-27T12:00:00Z'),
      findsOneWidget,
    );
  });
}
