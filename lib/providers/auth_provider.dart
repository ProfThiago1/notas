import 'package:flutter/foundation.dart'; // para criarmos o provider
import 'package:firebase_auth/firebase_auth.dart'; // para usarmos o FirebaseAuth

class MyAuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _auth
      .currentUser; // para obter o usuário atual ou retornar null se não estiver logado

  //aqui vem o método para criação da conta

  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      notifyListeners(); // para notificar "os ouvintes" sobre a mudança de estado
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }
  // método para login

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      notifyListeners();
    } on FirebaseAuthException catch (_) {
      rethrow;
      // e.message ?? 'Ocorreu um erro ao fazer login';
    }
  }

  //método para logout

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }
}
