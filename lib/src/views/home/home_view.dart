import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lazarus_job_tracker/src/models/user_model.dart';
import 'package:lazarus_job_tracker/src/services/auth_service.dart';
import 'package:lazarus_job_tracker/src/views/auth/user_list_view.dart';
import 'package:lazarus_job_tracker/src/views/client/client_list_view.dart';
import 'package:lazarus_job_tracker/src/views/equipment/equipment_list_view.dart';
import 'package:lazarus_job_tracker/src/views/job/job_list_view.dart';
import 'package:lazarus_job_tracker/src/views/job_material/job_material_list_view.dart';
import 'package:lazarus_job_tracker/src/app_styles.dart';
import 'package:lazarus_job_tracker/src/widgets/home_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  Future<UserModel?> _getUserInfo(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;

    if (user != null && user.uid.isNotEmpty) {
      final userModel = await authService.getUserData(user.uid);
      return userModel;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: _getUserInfo(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Loading...'),
              backgroundColor: Colors.white,
              flexibleSpace: Container(
                decoration: AppStyles.appBarDecoration,
              ),
              iconTheme: AppStyles.iconTheme,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
              backgroundColor: Colors.white,
              flexibleSpace: Container(
                decoration: AppStyles.appBarDecoration,
              ),
              iconTheme: AppStyles.iconTheme,
            ),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Home'),
              backgroundColor: Colors.white,
              flexibleSpace: Container(
                decoration: AppStyles.appBarDecoration,
              ),
              iconTheme: AppStyles.iconTheme,
            ),
            body: const Center(child: Text('No user data found')),
          );
        }

        final user = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Column(
              children: [
                Text(
                  user.companyName,
                  style: AppStyles.appBarCompanyStyle,
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${user.firstName} ${user.lastName}',
                  style: AppStyles.appBarSubtitleTextStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            backgroundColor: Colors.white,
            flexibleSpace: Container(
              decoration: AppStyles.appBarDecoration,
            ),
            iconTheme: AppStyles.iconTheme,
          ),
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HomeCard(
                      icon: Icons.person,
                      title: 'Clients',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ClientListView())),
                    ),
                    HomeCard(
                      icon: Icons.build,
                      title: 'Equipment',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EquipmentListView())),
                    ),
                    HomeCard(
                      icon: Icons.work,
                      title: 'Job',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const JobListView())),
                    ),
                    HomeCard(
                      icon: Icons.category,
                      title: 'Materials',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const JobMaterialListView())),
                    ),
                    HomeCard(
                      icon: Icons.people,
                      title: 'Employees',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UserListView())),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            shape: AppStyles.bottomAppBarTheme.shape,
            color: AppStyles.bottomAppBarTheme.color,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    iconSize: AppStyles.bottomIconTheme.size!,
                    color: AppStyles.bottomIconTheme.color,
                    onPressed: () async {
                      final authService = Provider.of<AuthService>(context, listen: false);
                      await authService.signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text('Logout', style: TextStyle(color: AppStyles.primaryColor)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


//                     return Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           width: cardWidth,
//                           child: Card(
//                             color: backgroundColor, // Set card color to background color
//                             elevation: 20.0, // Increase elevation for more shadow
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15.0),
//                             ),
//                             child: InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(builder: (context) => const ClientListView()),
//                                 );
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: Center(
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       const Icon(Icons.person, color: Colors.white),
//                                       const SizedBox(width: 10),
//                                       Text('Clients', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         SizedBox(
//                           width: cardWidth,
//                           child: Card(
//                             color: backgroundColor, // Set card color to background color
//                             elevation: 20.0, // Increase elevation for more shadow
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15.0),
//                             ),
//                             child: InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(builder: (context) => const EquipmentListView()),
//                                 );
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: Center(
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       const Icon(Icons.build, color: Colors.white),
//                                       const SizedBox(width: 10),
//                                       Text('Equipment', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         SizedBox(
//                           width: cardWidth,
//                           child: Card(
//                             color: backgroundColor, // Set card color to background color
//                             elevation: 20.0, // Increase elevation for more shadow
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15.0),
//                             ),
//                             child: InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(builder: (context) => const JobListView()),
//                                 );
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: Center(
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       const Icon(Icons.work, color: Colors.white),
//                                       const SizedBox(width: 10),
//                                       Text('Job', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         SizedBox(
//                           width: cardWidth,
//                           child: Card(
//                             color: backgroundColor, // Set card color to background color
//                             elevation: 20.0, // Increase elevation for more shadow
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15.0),
//                             ),
//                             child: InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(builder: (context) => const JobMaterialListView()),
//                                 );
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: Center(
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       const Icon(Icons.category, color: Colors.white),
//                                       const SizedBox(width: 10),
//                                       Text('Materials', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         SizedBox(
//                           width: cardWidth,
//                           child: Card(
//                             color: backgroundColor, // Set card color to background color
//                             elevation: 20.0, // Increase elevation for more shadow
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15.0),
//                             ),
//                             child: InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(builder: (context) => const UserListView()),
//                                 );
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: Center(
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       const Icon(Icons.people, color: Colors.white),
//                                       const SizedBox(width: 10),
//                                       Text('Employees', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//           bottomNavigationBar: BottomAppBar(
//             color: backgroundColor,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.logout, color: Colors.white),
//                     onPressed: () async {
//                       final authService = Provider.of<AuthService>(context, listen: false);
//                       await authService.signOut();
//                       Navigator.pushReplacementNamed(context, '/login');
//                     },
//                   ),
//                   const SizedBox(width: 8),
//                   const Text('Logout', style: TextStyle(color: Colors.white)),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }


//                     return Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           width: cardWidth,
//                           child: Card(
//                             color: backgroundColor, // Set card color to background color
//                             elevation: 20.0, // Increase elevation for more shadow
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15.0),
//                             ),
//                             child: InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(builder: (context) => const ClientListView()),
//                                 );
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: Center(
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       const Icon(Icons.person, color: Colors.white),
//                                       const SizedBox(width: 10),
//                                       Text('Clients', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         SizedBox(
//                           width: cardWidth,
//                           child: Card(
//                             color: backgroundColor, // Set card color to background color
//                             elevation: 20.0, // Increase elevation for more shadow
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15.0),
//                             ),
//                             child: InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(builder: (context) => const EquipmentListView()),
//                                 );
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: Center(
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       const Icon(Icons.build, color: Colors.white),
//                                       const SizedBox(width: 10),
//                                       Text('Equipment', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         SizedBox(
//                           width: cardWidth,
//                           child: Card(
//                             color: backgroundColor, // Set card color to background color
//                             elevation: 20.0, // Increase elevation for more shadow
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15.0),
//                             ),
//                             child: InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(builder: (context) => const JobListView()),
//                                 );
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: Center(
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       const Icon(Icons.work, color: Colors.white),
//                                       const SizedBox(width: 10),
//                                       Text('Job', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         SizedBox(
//                           width: cardWidth,
//                           child: Card(
//                             color: backgroundColor, // Set card color to background color
//                             elevation: 20.0, // Increase elevation for more shadow
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15.0),
//                             ),
//                             child: InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(builder: (context) => const JobMaterialListView()),
//                                 );
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: Center(
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       const Icon(Icons.category, color: Colors.white),
//                                       const SizedBox(width: 10),
//                                       Text('Materials', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         SizedBox(
//                           width: cardWidth,
//                           child: Card(
//                             color: backgroundColor, // Set card color to background color
//                             elevation: 20.0, // Increase elevation for more shadow
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15.0),
//                             ),
//                             child: InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(builder: (context) => const UserListView()),
//                                 );
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: Center(
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       const Icon(Icons.people, color: Colors.white),
//                                       const SizedBox(width: 10),
//                                       Text('Employees', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//           bottomNavigationBar: BottomAppBar(
//             color: backgroundColor,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.logout, color: Colors.white),
//                     onPressed: () async {
//                       final authService = Provider.of<AuthService>(context, listen: false);
//                       await authService.signOut();
//                       Navigator.pushReplacementNamed(context, '/login');
//                     },
//                   ),
//                   const SizedBox(width: 8),
//                   const Text('Logout', style: TextStyle(color: Colors.white)),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
