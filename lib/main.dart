import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:fluro/fluro.dart';
import 'package:lazarus_job_tracker/src/models/user_model.dart';
import 'package:lazarus_job_tracker/src/services/job_service.dart';
import 'package:lazarus_job_tracker/src/services/job_material_service.dart';
import 'package:lazarus_job_tracker/src/services/client_service.dart';
import 'package:lazarus_job_tracker/src/services/equipment_service.dart';
import 'package:lazarus_job_tracker/src/views/home/home_view.dart';
import 'package:lazarus_job_tracker/src/views/auth/login_view.dart';
import 'package:lazarus_job_tracker/src/views/auth/sign_up_view.dart';
import 'package:lazarus_job_tracker/src/views/auth/create_user_view.dart';
import 'package:lazarus_job_tracker/src/views/auth/user_list_view.dart';
import 'package:lazarus_job_tracker/src/services/auth_service.dart';

final FluroRouter router = FluroRouter();

void defineRoutes(FluroRouter router) {
  router.define('/login', handler: Handler(handlerFunc: (context, params) => const LoginView()));
  // Define other routes similarly
  router.define('/', handler: Handler(handlerFunc: (context, params) => const HomeView()));
  router.define('/signUp', handler: Handler(handlerFunc: (context, params) => const SignUpView()));
  router.define('/createUser', handler: Handler(handlerFunc: (context, params) => const CreateUserView()));
  router.define('/userList', handler: Handler(handlerFunc: (context, params) => const UserListView()));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  defineRoutes(router);

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
        )),
        Provider(create: (_) => JobMaterialService()),
        Provider(create: (_) => JobService()),
        Provider(create: (_) => EquipmentService()),
        Provider(create: (_) => ClientService()),
        Provider(create: (_) => AuthService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Job Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (context, child) => ResponsiveWrapper.builder(
        child,
        maxWidth: 1200,
        minWidth: 450,
        defaultScale: true,
        breakpoints: [
          const ResponsiveBreakpoint.resize(450, name: MOBILE),
          const ResponsiveBreakpoint.autoScale(800, name: TABLET),
          const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
        ],
      ),
      onGenerateRoute: router.generator,
      initialRoute: '/login',
    );
  }
}
