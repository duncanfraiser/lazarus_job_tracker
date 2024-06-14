
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

//Imports for authentication
import 'package:lazarus_job_tracker/src/services/auth_service.dart';
import 'package:lazarus_job_tracker/src/views/auth/auth_view_model.dart';

//Imports for equipment navigation
import 'package:lazarus_job_tracker/src/views/equipment/create_update_view.dart';
import 'package:lazarus_job_tracker/src/views/equipment/equipment_list_view.dart';


class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false); // Added authViewModel

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Welcome to the Home Page!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EquipmentListView()),
                );
              },
              child: const Text('Go to Equipment List'),
            ),
          ],
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
