import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notas/providers/auth_provider.dart';
import 'package:notas/utils/paleta.dart';
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
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(
                      Icons.sticky_note_2_outlined,
                      color: Colors.white,
                      size: 40,
                    ),
                    SizedBox(width: 10),
                    Text(
                    'Login ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ]),
                  
                  SizedBox(height: 10),
                  Text(
                    'Bem vindo(a) de volta',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withValues(alpha: 0.12)
                            : Colors.black.withValues(alpha: 0.12),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: FormsLogin(
                            emailController: _emailController,
                            passwordController: _passwordController,
                            formKey: _formKey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _submit,
                        child: const Text(
                          'Entrar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Não tem uma conta? ',
                          style: TextStyle(
                            color: AppColors.darkGray,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: 'Cadastre-se',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: AppColors.primary,
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
            )
          ],
        ),
      ),
    );
  }
}

