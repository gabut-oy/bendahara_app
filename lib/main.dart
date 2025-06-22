import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ffemndnsibdhaqfnfiwj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZmZW1uZG5zaWJkaGFxZm5maXdqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA1NTQ1NzUsImV4cCI6MjA2NjEzMDU3NX0.2M3_BAQQEGzA7h7frik_7u76Gs29IOOmkNFP-UBmXLE',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Bendahara',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const TransaksiPage(),
    );
  }
}
