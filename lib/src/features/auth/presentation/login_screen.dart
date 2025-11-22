import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'KrisiBandhu',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              Text(
                'Making Crop Insurance Faster and Fairer',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
              const SizedBox(height: 48.0),
              ElevatedButton(
                onPressed: () => context.go('/dashboard'),
                child: const Text('Login as Farmer'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => context.go('/dashboard'),
                child: const Text('Login as Official'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
