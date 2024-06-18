import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

//Imports for authentication
import 'package:lazarus_job_tracker/src/services/auth_service.dart';
import 'package:lazarus_job_tracker/src/views/auth/auth_view_model.dart';

//Imports for list views navigation
import 'package:lazarus_job_tracker/src/views/client/client_list_view.dart';
import 'package:lazarus_job_tracker/src/views/equipment/equipment_list_view.dart';


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
                double buttonWidth = constraints.maxWidth * 0.7; // 80% of the screen width

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: buttonWidth,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ClientListView()),
                          );
                        },
                        child: const Text('Clients'),
                      ),
                    ),
                    SizedBox(height: 15), // Add some spacing between buttons
                    SizedBox(
                      width: buttonWidth,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const EquipmentListView()),
                          );
                        },
                        child: const Text('Equipment'),
                      ),
                    ),
                    
                    // Add more buttons here if needed
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









//       body: const Center(
//         child: Text('Welcome to the Home Page!'),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => CreateUpdateView()), // Navigate to CreateUpdateView
//           );
//         },
//         child: const Icon(Icons.add),
//         tooltip: 'Add Equipment',
//       ),
//     );
//   }
// }
