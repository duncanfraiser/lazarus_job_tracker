import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/views/auth/auth_view_model.dart';
import 'package:lazarus_job_tracker/src/views/auth/login_view.dart';
import 'package:lazarus_job_tracker/src/views/auth/signup_view.dart';
import 'package:lazarus_job_tracker/src/views/home/home_view.dart';
import 'package:provider/provider.dart';

import 'sample_feature/sample_item_details_view.dart';
import 'sample_feature/sample_item_list_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';


/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
     final authViewModel = Provider.of<AuthViewModel>(context);
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(

          debugShowCheckedModeBanner: false,
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',
          



          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.

          // Set the initial route based on authentication status
          initialRoute: authViewModel.user != null ? '/' : '/login',
          
          // Define named routes
          routes: {
            '/': (context) => HomeView(),
            '/login': (context) => LoginView(),
            '/signup': (context) => SignupView(),
            SettingsView.routeName: (context) => SettingsView(controller: settingsController),
            SampleItemDetailsView.routeName: (context) => const SampleItemDetailsView(),
          },
        );
      },
    );
  }
}
