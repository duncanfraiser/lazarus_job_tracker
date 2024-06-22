import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lazarus_job_tracker/src/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser; // Add a getter for the current user

  Future<User?> signUp(String email, String password, UserModel userModel) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      // Add additional user data to Firestore
      await _firestore.collection('employees').doc(user!.uid).set(userModel.toMap());

      return user;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<UserModel?> getUserData(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('employees').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromDocument(doc);
      }
      return null;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<void> updateUserData(String userId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('employees').doc(userId).update(updatedData);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Stream<List<UserModel>> getUsers() {
    return _firestore.collection('employees').snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => UserModel.fromDocument(doc)).toList());
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<User?> createUser(UserModel userModel, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: userModel.email, password: password);
      User? user = result.user;

      // Add additional user data to Firestore
      await _firestore.collection('employees').doc(user!.uid).set(userModel.toMap());

      return user;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      // Delete user data from Firestore
      await _firestore.collection('employees').doc(userId).delete();
      
      // Optionally, delete the user from FirebaseAuth
      // Note: You can only delete the currently signed-in user
      User? user = _auth.currentUser;
      if (user != null && user.uid == userId) {
        await user.delete();
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('employees').get();
      return querySnapshot.docs.map((doc) => UserModel.fromDocument(doc)).toList();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
