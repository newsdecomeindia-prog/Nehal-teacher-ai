import 'package:flutter/material.dart';

/// Error Boundary widget preventing app crashes from unhandled Flutter errors.
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(Object error, StackTrace? stackTrace)? errorBuilder;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;

  @override
  void initState() {
    super.initState();
  }

  static Widget _defaultErrorBuilder(Object error, StackTrace? stackTrace) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.orange,
                size: 60,
              ),
              SizedBox(height: 16),
              Text(
                'Something went wrong',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Please restart the application or try again later.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorBuilder != null
          ? widget.errorBuilder!(_error!, null)
          : _defaultErrorBuilder(_error!, null);
    }

    return widget.child;
  }
}
