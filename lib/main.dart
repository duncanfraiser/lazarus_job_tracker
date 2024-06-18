import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'src/app.dart';
import 'package:provider/provider.dart';
import 'src/views/auth/auth_view_model.dart';
import 'package:lazarus_job_tracker/src/services/material_service.dart';

void main() async {
  // Ensure Flutter binding is initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the app.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        Provider<MaterialService>(create: (_) => MaterialService()),
      ],
      child: const MyApp(),
    ),
  );
}
