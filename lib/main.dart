import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/views/auth/auth_view_model.dart';
import 'package:lazarus_job_tracker/src/views/home/home_view.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lazarus_job_tracker/src/services/job_service.dart';
import 'package:lazarus_job_tracker/src/services/job_material_service.dart';
import 'package:lazarus_job_tracker/src/services/client_service.dart';
import 'package:lazarus_job_tracker/src/services/equipment_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Job Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeView(),
    );
  }
}
