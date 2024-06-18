import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/views/auth/auth_view_model.dart';
import 'package:lazarus_job_tracker/src/views/auth/signup_view.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

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
            ValueListenableBuilder<bool>(
              valueListenable: _isLoading,
              builder: (context, isLoading, child) {
                if (isLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return ElevatedButton(
                    onPressed: () async {
                      _isLoading.value = true;
                      await authViewModel.signIn(_emailController.text, _passwordController.text);
                      _isLoading.value = false;
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
                  );
                }
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupView()),
                );
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
