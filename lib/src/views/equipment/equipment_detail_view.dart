import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/models/equipment_model.dart';
import 'package:lazarus_job_tracker/src/services/equipment_service.dart';
import 'package:lazarus_job_tracker/src/services/auth_service.dart';
import 'package:lazarus_job_tracker/src/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:lazarus_job_tracker/src/app_styles.dart';
import 'package:lazarus_job_tracker/src/views/equipment/equipment_create_update_view.dart';
import 'package:lazarus_job_tracker/src/widgets/reusable_card.dart';
import 'package:lazarus_job_tracker/src/widgets/loading_view.dart';
import 'package:lazarus_job_tracker/src/widgets/error_view.dart';
import 'package:lazarus_job_tracker/src/widgets/no_data_view.dart';
import 'package:lazarus_job_tracker/src/widgets/top_bar.dart';
import 'package:lazarus_job_tracker/src/widgets/bottom_bar.dart';

class EquipmentDetailView extends StatelessWidget {
  final EquipmentModel equipment;

  const EquipmentDetailView({super.key, required this.equipment});

  @override
  Widget build(BuildContext context) {
    final equipmentService = Provider.of<EquipmentService>(context, listen: false);
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
          return const NoDataView(title: 'Equipment Detail', message: 'No user data found');
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
                      builder: (context) => EquipmentCreateUpdateView(equipment: equipment),
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
                        child: Text('Delete Equipment'),
                      ),
                      content: Text('Are you sure you want to delete ${equipment.name} from the equipment list?'),
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
                    await equipmentService.deleteEquipment(equipment.documentId!);
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
                    'Equipment Detail',
                    style: AppStyles.headlineStyle,
                  ),
                ),
                const SizedBox(height: 8.0), // Reduced spacing
                Expanded(
                  child: ListView(
                    children: [
                      ReusableCard(
                        icon: Icons.build,
                        title: 'Name',
                        subtitle: equipment.name,
                      ),
                      ReusableCard(
                        icon: Icons.description,
                        title: 'Description',
                        subtitle: equipment.description,
                      ),
                      ReusableCard(
                        icon: Icons.attach_money,
                        title: 'Rate per Hour',
                        subtitle: '\$${equipment.ratePerHour.toStringAsFixed(2)}',
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
