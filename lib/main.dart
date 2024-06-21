import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lazarus_job_tracker/src/services/client_service.dart';
import 'package:lazarus_job_tracker/src/services/equipment_service.dart';
import 'package:lazarus_job_tracker/src/services/job_service.dart';
import 'package:lazarus_job_tracker/src/services/Job_material_service.dart';
import 'firebase_options.dart';

import 'src/app.dart';
import 'package:provider/provider.dart';
import 'src/views/auth/auth_view_model.dart';


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
        Provider(create: (_) => JobMaterialService()),
        Provider(create: (_) => JobService()),
        Provider(create: (_) => EquipmentService()),
        Provider(create: (_) => ClientService()),
      ],
      child: const MyApp(),
    ),
  );
}
