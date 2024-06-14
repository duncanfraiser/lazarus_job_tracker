// lib/src/views/auth/login_view.dart

import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/views/auth/auth_view_model.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                await authViewModel.signIn(_emailController.text, _passwordController.text);
                if (authViewModel.user != null) {
                  Navigator.pushReplacementNamed(context, '/');
                } else {
                  // Handle login error
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Failed to login'),
                  ));
                }

              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
