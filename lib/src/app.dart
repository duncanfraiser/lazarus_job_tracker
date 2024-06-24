import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/models/user_model.dart';
import 'package:lazarus_job_tracker/src/views/auth/create_user_view.dart';
import 'package:lazarus_job_tracker/src/views/auth/sign_up_view.dart';
import 'package:lazarus_job_tracker/src/views/auth/user_list_view.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lazarus_job_tracker/src/views/home/home_view.dart';
import 'package:lazarus_job_tracker/src/views/auth/login_view.dart';
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
        ChangeNotifierProvider(create: (_) => UserModel(
          id: '',
          firstName: '',
          lastName: '',
          email: '',
          companyName: '',
          userRole: '',
          phoneNumber: '',
          address: '',
          emergencyContacts: [],
          isLoggedIn: false,
          clockTimes: [],
        )),
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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Job Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: userModel.getIsLoggedIn ? '/' : '/login',
      routes: {
        '/': (context) => const HomeView(),
        '/login': (context) => const LoginView(),
        '/signUp': (context) => const SignUpView(),
        '/createUser': (context) => const CreateUserView(),
        '/userList': (context) => const UserListView(),
      },
    );
  }
}
