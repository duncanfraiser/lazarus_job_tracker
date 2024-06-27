import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/models/job_material_model.dart';
import 'package:lazarus_job_tracker/src/services/job_material_service.dart';
import 'package:lazarus_job_tracker/src/services/auth_service.dart';
import 'package:lazarus_job_tracker/src/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:lazarus_job_tracker/src/app_styles.dart';
import 'package:lazarus_job_tracker/src/views/job_material/job_material_create_update_view.dart';
import 'package:lazarus_job_tracker/src/widgets/reusable_card.dart';
import 'package:lazarus_job_tracker/src/widgets/loading_view.dart';
import 'package:lazarus_job_tracker/src/widgets/error_view.dart';
import 'package:lazarus_job_tracker/src/widgets/no_data_view.dart';
import 'package:lazarus_job_tracker/src/widgets/top_bar.dart';
import 'package:lazarus_job_tracker/src/widgets/bottom_bar.dart';

class JobMaterialDetailView extends StatelessWidget {
  final JobMaterialModel jobMaterial;

  const JobMaterialDetailView({super.key, required this.jobMaterial});

  @override
  Widget build(BuildContext context) {
    final jobMaterialService = Provider.of<JobMaterialService>(context, listen: false);
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
          return const NoDataView(title: 'Material Detail', message: 'No user data found');
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
                      builder: (context) => JobMaterialCreateUpdateView(jobMaterial: jobMaterial),
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
                        child: Text('Delete Material'),
                      ),
                      content: Text('Are you sure you want to delete ${jobMaterial.name} from the material list?'),
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
                    await jobMaterialService.deleteJobMaterial(jobMaterial.documentId!);
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
                    'Material Detail',
                    style: AppStyles.headlineStyle,
                  ),
                ),
                const SizedBox(height: 8.0), // Reduced spacing
                Expanded(
                  child: ListView(
                    children: [
                      ReusableCard(
                        icon: Icons.inventory,
                        title: 'Name',
                        subtitle: jobMaterial.name,
                      ),
                      ReusableCard(
                        icon: Icons.attach_money,
                        title: 'Price',
                        subtitle: '\$${jobMaterial.price.toStringAsFixed(2)}',
                      ),
                      ReusableCard(
                        icon: Icons.description,
                        title: 'Description',
                        subtitle: jobMaterial.description,
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
