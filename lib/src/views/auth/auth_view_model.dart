import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lazarus_job_tracker/src/services/auth_service.dart';

class AuthViewModel with ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  User? get user => _user;

  AuthViewModel() {
    _authService.user.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  set user(User? user) {
    _user = user;
    notifyListeners(); // Notify listeners on user state change
  }

  Future<void> signIn(String email, String password) async {
    await _authService.signInWithEmailPassword(email, password);
    notifyListeners();
  }

  // Future<void> signUp(String email, String password, String firstName, String lastName, String company) async {
  //   await _authService.signUpWithEmailPassword(email, password, firstName, lastName, company);
  //   notifyListeners();
  // }

    Future<bool> signUp(String email, String password, String firstName, String lastName, String company) async {
      try {
        await _authService.signUpWithEmailPassword(email, password, firstName, lastName, company);
        return true;
      } catch (e) {
        print(e); // Handle error appropriately
        return false;
      } finally {
        notifyListeners();
      }
    }

  Future<void> signOut() async {
    await _authService.signOut();
    notifyListeners();
  }
}
