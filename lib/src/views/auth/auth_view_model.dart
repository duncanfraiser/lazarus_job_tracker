// lib/src/views/auth/auth_view_model.dart

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

  Future<void> signIn(String email, String password) async {
    await _authService.signInWithEmailPassword(email, password);
    notifyListeners();
  }

  Future<void> signUp(String email, String password) async {
    await _authService.signUpWithEmailPassword(email, password);
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    notifyListeners();
  }
}
