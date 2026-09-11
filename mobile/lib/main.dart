import 'package:flutter/material.dart';
import 'package:nehal_teacher_ai_mobile/widgets/error_boundary.dart';

void main() {
  runApp(const NehalTeacherApp());
}

class NehalTeacherApp extends StatelessWidget {
  const NehalTeacherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      child: MaterialApp(
        title: 'Nehal Ki Teacher AI',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const FoundationHomePage(),
      ),
    );
  }
}

class FoundationHomePage extends StatelessWidget {
  const FoundationHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nehal Ki Teacher AI - Production Ready'),
      ),
      body: const Center(
        child: Text(
          'Phase 8 Production Readiness & Security Hardening Ready',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
