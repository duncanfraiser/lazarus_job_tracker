import 'package:lazarus_job_tracker/src/views/job/job_list_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

//Imports for authentication
import 'package:lazarus_job_tracker/src/services/auth_service.dart';
import 'package:lazarus_job_tracker/src/views/auth/auth_view_model.dart';

//Imports for list views navigation
import 'package:lazarus_job_tracker/src/views/client/client_list_view.dart';
import 'package:lazarus_job_tracker/src/views/equipment/equipment_list_view.dart';
import 'package:lazarus_job_tracker/src/views/material/material_list_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false); // Added authViewModel

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.signOut();
              authViewModel.user = null; // Update user state on logout
              Navigator.pushReplacementNamed(context, '/login'); // Navigate to login screen
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Calculate the width as a percentage of the available width
                double cardWidth = constraints.maxWidth * 0.7; // 70% of the screen width

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
                    const SizedBox(height: 15), // Add some spacing between cards
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
                    const SizedBox(height: 15), // Add some spacing between cards
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
                    const SizedBox(height: 15), // Add some spacing between cards
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
                              MaterialPageRoute(builder: (context) => const MaterialListView()),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(child: Text('Material', style: Theme.of(context).textTheme.titleLarge)),
                          ),
                        ),
                      ),
                    ),               // Add more cards here if needed
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
