import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/app_styles.dart';
import 'package:lazarus_job_tracker/src/models/user_model.dart';
import 'package:lazarus_job_tracker/src/services/auth_service.dart';
import 'package:lazarus_job_tracker/src/views/auth/create_user_view.dart';
import 'package:provider/provider.dart';
import 'package:lazarus_job_tracker/src/widgets/reusable_card.dart';
import 'package:lazarus_job_tracker/src/widgets/loading_view.dart';
import 'package:lazarus_job_tracker/src/widgets/error_view.dart';
import 'package:lazarus_job_tracker/src/widgets/no_data_view.dart';
import 'package:lazarus_job_tracker/src/widgets/top_bar.dart';
import 'package:lazarus_job_tracker/src/widgets/bottom_bar.dart';

class UserDetailView extends StatelessWidget {
  final UserModel user;

  const UserDetailView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    void navigateHome() {
      Navigator.popUntil(context, ModalRoute.withName('/'));
    }

    return FutureBuilder<UserModel?>(
      future: authService.getUserData(authService.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingView(title: 'Loading...');
        }

        if (snapshot.hasError) {
          return ErrorView(title: 'Error', errorMessage: snapshot.error.toString());
        }

        if (!snapshot.hasData) {
          return const NoDataView(title: 'User Detail', message: 'No user data found');
        }

        final currentUser = snapshot.data!;
        return Scaffold(
          appBar: TopBar(
            companyName: currentUser.companyName,
            userName: '${currentUser.firstName} ${currentUser.lastName}',
            actions: [
              IconButton(
                icon: Icon(Icons.edit, color: AppStyles.orangeEditIcon.color, size: AppStyles.orangeEditIcon.size),
                iconSize: AppStyles.topBarIconSize,
                color: AppStyles.iconTheme.color,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateUserView(), // No user parameter passed
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: AppStyles.redDeleteIcon.color, size: AppStyles.redDeleteIcon.size),
                iconSize: AppStyles.topBarIconSize,
                color: AppStyles.iconTheme.color,
                onPressed: () async {
                  bool? confirmDelete = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete User'),
                      content: const Text('Are you sure you want to delete this user?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  if (confirmDelete == true) {
                    await authService.deleteUser(user.documentId!);
                    Navigator.pop(context); // Close the detail view after deletion
                  }
                },
              ),
            ],
          ),
          backgroundColor: AppStyles.backgroundColor,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0), // Reduced spacing
                  child: Text(
                    'User Detail',
                    style: AppStyles.headlineStyle,
                  ),
                ),
                const SizedBox(height: 8.0), // Reduced spacing
                Expanded(
                  child: ListView(
                    children: [
                      ReusableCard(
                        icon: Icons.person,
                        title: 'First Name',
                        subtitle: user.firstName,
                      ),
                      ReusableCard(
                        icon: Icons.person,
                        title: 'Last Name',
                        subtitle: user.lastName,
                      ),
                      ReusableCard(
                        icon: Icons.email,
                        title: 'Email',
                        subtitle: user.email,
                      ),
                      ReusableCard(
                        icon: Icons.business,
                        title: 'Company',
                        subtitle: user.companyName,
                      ),
                      ReusableCard(
                        icon: Icons.phone,
                        title: 'Phone',
                        subtitle: user.phoneNumber,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomBar(
            onHomePressed: navigateHome,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }
}
