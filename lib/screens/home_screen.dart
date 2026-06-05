import 'package:flutter/material.dart';
import 'package:notas/providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MyAuthProvider().user;
    return Scaffold(
      appBar: AppBar(
        title: Text('Bem-vindo(a), $user!'),
      ),
      body: const Center(
        child: Text('Bem-vindo à tela inicial!'),
      ),
    );
  }
}