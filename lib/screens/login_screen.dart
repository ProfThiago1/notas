import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notas/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/forms_login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = Provider.of<MyAuthProvider>(context, listen: false);
    //não queremos que a tela de login seja reconstruída toda vez que o estado do auth mudar, por isso listen: false

    try {
      await auth.signIn(_emailController.text, _passwordController.text);
      if (mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/home', (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      //tratamos apenas os erros do FirebaseAuth,
      //mas poderíamos tratar outros tipos de erros também, dependendo do caso.
      String errorMessage = "Erro ao fazer login";

      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'O email fornecido é inválido';
          break;
        case 'user-not-found':
          errorMessage = 'Usuário não encontrado';
          break;
        case 'wrong-password':
          errorMessage = 'Senha incorreta';
          break;
        case 'user-not-found || wrong-password':
          errorMessage = 'Email ou senha incorretos';
          break;
        default:
          errorMessage = 'Ocorreu um erro ao processar sua solicitação';
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } catch (e) {
      //tratamos outros tipos de erros genéricos aqui, caso algo inesperado aconteça
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Ocorreu um erro inesperado. Tente novamente mais tarde.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bem-vindo ao Notas App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            FormsLogin(
              emailController: _emailController,
              passwordController: _passwordController,
              formKey: _formKey,
            ),

            const SizedBox(height: 20),

            ElevatedButton(onPressed: _submit, child: const Text('Entrar')),
          ],
        ),
      ),
    );
  }
}
