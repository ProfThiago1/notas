import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notas/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/forms_login.dart';
import 'package:flutter/gestures.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late TapGestureRecognizer _tapRecognizer;

  @override
  void initState() {
    _tapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.of(context).pushNamed('/cadastro');
      };
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _tapRecognizer.dispose();
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(
                 
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Bem vindo(a) de volta',
                style: TextStyle( fontSize: 14),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withValues(alpha: 0.12)
                            : Colors.black.withValues(alpha: 0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FormsLogin(
                        emailController: _emailController,
                        passwordController: _passwordController,
                        formKey: _formKey,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                        ),
                        onPressed: _submit,
                        child: const Text(
                          'Entrar',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Não tem uma conta? ',
                          style: TextStyle(color: Colors.black87, fontSize: 14),
                          children: [
                            TextSpan(
                              text: 'Cadastre-se',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: _tapRecognizer,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
