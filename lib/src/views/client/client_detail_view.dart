import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/models/client_model.dart';
import 'package:lazarus_job_tracker/src/services/client_service.dart';
import 'package:lazarus_job_tracker/src/services/auth_service.dart';
import 'package:lazarus_job_tracker/src/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:lazarus_job_tracker/src/app_styles.dart';
import 'package:lazarus_job_tracker/src/views/client/client_create_update_view.dart';
import 'package:lazarus_job_tracker/src/widgets/reusable_card.dart';
import 'package:lazarus_job_tracker/src/widgets/loading_view.dart';
import 'package:lazarus_job_tracker/src/widgets/error_view.dart';
import 'package:lazarus_job_tracker/src/widgets/no_data_view.dart';
import 'package:lazarus_job_tracker/src/widgets/top_bar.dart';
import 'package:lazarus_job_tracker/src/widgets/bottom_bar.dart';

class ClientDetailView extends StatelessWidget {
  final ClientModel client;

  const ClientDetailView({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    final clientService = Provider.of<ClientService>(context, listen: false);
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
          return const NoDataView(title: 'Client Detail', message: 'No user data found');
        }

        final user = snapshot.data!;
        return Scaffold(
          appBar: TopBar(
            companyName: user.companyName,
            userName: '${user.firstName} ${user.lastName}',
            actions: [
              IconButton(
                icon: Icon(Icons.edit, color: AppStyles.orangeEditIcon.color, size: AppStyles.orangeEditIcon.size),
                iconSize: AppStyles.topBarIconSize,
                color: AppStyles.iconTheme.color,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClientCreateUpdateView(client: client),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: AppStyles.redDeleteIcon.color, size: AppStyles.redDeleteIcon.size),
                iconSize: AppStyles.topBarIconSize,
                color: AppStyles.iconTheme.color,
                onPressed: () async {
                  final confirmDelete = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Center(
                        child: Text('Delete Client'),
                      ),
                      content: Text('Are you sure you want to delete ${client.fName} ${client.lName} from the client list?'),
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
                    await clientService.deleteClient(client.documentId!);
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
                    'Client Detail',
                    style: AppStyles.headlineStyle,
                  ),
                ),
                const SizedBox(height: 8.0), // Reduced spacing
                Expanded(
                  child: ListView(
                    children: [
                      ReusableCard(
                        icon: Icons.person,
                        title: 'Name',
                        subtitle: '${client.fName} ${client.lName}',
                      ),
                      ReusableCard(
                        icon: Icons.home,
                        title: 'Billing Address',
                        subtitle: client.billingAddress,
                      ),
                      ReusableCard(
                        icon: Icons.phone,
                        title: 'Phone',
                        subtitle: client.phone,
                      ),
                      ReusableCard(
                        icon: Icons.email,
                        title: 'Email',
                        subtitle: client.email,
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
