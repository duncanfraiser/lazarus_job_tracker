// lib/src/services/auth_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get user {
    return _firebaseAuth.authStateChanges();
  }

  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

 Future<void> signUpWithEmailPassword(String email, String password, String firstName, String lastName, String company) async {
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;

    if (user != null) {
      await _firestore.collection('employees').doc(user.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'company': company,
        'email': email,
        'createdAt': Timestamp.now(),
      });
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
