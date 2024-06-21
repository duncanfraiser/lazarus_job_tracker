import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lazarus_job_tracker/src/views/job/job_list_view.dart';
import 'package:lazarus_job_tracker/src/services/auth_service.dart';
import 'package:lazarus_job_tracker/src/views/auth/auth_view_model.dart';
import 'package:lazarus_job_tracker/src/views/client/client_list_view.dart';
import 'package:lazarus_job_tracker/src/views/equipment/equipment_list_view.dart';
import 'package:lazarus_job_tracker/src/views/job_material/job_material_list_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  Future<Map<String, String>> _getUserInfo(BuildContext context) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final user = authViewModel.user;

    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('employees').doc(user.uid).get();
      if (userDoc.exists) {
        print("User data: ${userDoc.data()}"); // Debugging statement
        return {
          'companyName': userDoc.data()!['company'] ?? '',
          'firstName': userDoc.data()!['firstName'] ?? '',
          'lastName': userDoc.data()!['lastName'] ?? '',
        };
      } else {
        print("No user document found");
      }
    } else {
      print("User is null");
    }
    return {
      'companyName': 'Dashboard',
      'firstName': '',
      'lastName': '',
    };
  }

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return FutureBuilder<Map<String, String>>(
      future: _getUserInfo(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Loading...')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final userInfo = snapshot.data!;
        final companyName = userInfo['companyName'] ?? 'Dashboard';
        final firstName = userInfo['firstName'] ?? '';
        final lastName = userInfo['lastName'] ?? '';

        print("Company Name: $companyName, First Name: $firstName, Last Name: $lastName"); // Debugging statement

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(companyName, style: const TextStyle(color: Colors.black), textAlign: TextAlign.center),
                if (firstName.isNotEmpty && lastName.isNotEmpty)
                  Text(
                    '$firstName $lastName',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await auth.signOut();
                  authViewModel.user = null;
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
            centerTitle: true,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double cardWidth = constraints.maxWidth * 0.7;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: cardWidth,
                          child: Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ClientListView()),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(child: Text('Clients', style: Theme.of(context).textTheme.titleLarge)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: cardWidth,
                          child: Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const EquipmentListView()),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(child: Text('Equipment', style: Theme.of(context).textTheme.titleLarge)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: cardWidth,
                          child: Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const JobListView()),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(child: Text('Job', style: Theme.of(context).textTheme.titleLarge)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: cardWidth,
                          child: Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const JobMaterialListView()),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(child: Text('Material', style: Theme.of(context).textTheme.titleLarge)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
