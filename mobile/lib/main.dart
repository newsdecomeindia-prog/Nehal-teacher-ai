import 'package:flutter/material.dart';

void main() {
  runApp(const NehalTeacherApp());
}

class NehalTeacherApp extends StatelessWidget {
  const NehalTeacherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nehal Ki Teacher AI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const FoundationHomePage(),
    );
  }
}

class FoundationHomePage extends StatelessWidget {
  const FoundationHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nehal Ki Teacher AI - Phase 1'),
      ),
      body: const Center(
        child: Text(
          'Phase 1 Technical Foundation Ready',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
