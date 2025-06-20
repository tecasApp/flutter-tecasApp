import 'package:flutter/material.dart';

class UnderagePage extends StatelessWidget {
  const UnderagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cuenta desactivada')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.lock, size: 100, color: Colors.redAccent),
              SizedBox(height: 24),
              Text(
                'Tu cuenta ha sido desactivada temporalmente',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                'Debes tener al menos 18 años para usar esta aplicación.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
