import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/views/auth/auth_view_model.dart';
import 'package:lazarus_job_tracker/src/views/auth/login_view.dart';
import 'package:lazarus_job_tracker/src/views/auth/signup_view.dart';
import 'package:lazarus_job_tracker/src/views/home/home_view.dart';
import 'package:provider/provider.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'app',
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,

      // Set the initial route based on authentication status
      initialRoute: authViewModel.user != null ? '/' : '/login',

      // Define named routes
      routes: {
        '/': (context) => const HomeView(),
        '/login': (context) => LoginView(),
        '/signup': (context) => SignupView(),
      },
    );
  }
}