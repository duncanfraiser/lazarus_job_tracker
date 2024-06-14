
import 'package:lazarus_job_tracker/src/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:lazarus_job_tracker/src/views/auth/auth_view_model.dart';

import 'package:flutter/material.dart';
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false); // Added authViewModel

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.signOut();
              authViewModel.user = null; // Update user state on logout
              Navigator.pushReplacementNamed(context, '/login'); // Navigate to login screen
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to the Home Page!'),
      ),
    );
  }
}
