import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/models/job_material_model.dart';
import 'package:lazarus_job_tracker/src/services/job_material_service.dart';
import 'package:lazarus_job_tracker/src/views/job_material/job_material_create_update_view.dart';
import 'package:lazarus_job_tracker/src/views/job_material/job_material_detail_view.dart';
import 'package:lazarus_job_tracker/src/app_styles.dart';
import 'package:lazarus_job_tracker/src/widgets/reusable_card.dart';
import 'package:lazarus_job_tracker/src/widgets/loading_view.dart';
import 'package:lazarus_job_tracker/src/widgets/error_view.dart';
import 'package:lazarus_job_tracker/src/widgets/no_data_view.dart';
import 'package:lazarus_job_tracker/src/widgets/top_bar.dart';
import 'package:lazarus_job_tracker/src/widgets/bottom_bar.dart';
import 'package:provider/provider.dart';
import 'package:lazarus_job_tracker/src/services/auth_service.dart';
import 'package:lazarus_job_tracker/src/models/user_model.dart';

class JobMaterialListView extends StatefulWidget {
  const JobMaterialListView({super.key});

  @override
  _JobMaterialListViewState createState() => _JobMaterialListViewState();
}

class _JobMaterialListViewState extends State<JobMaterialListView> {
  final JobMaterialService _jobMaterialService = JobMaterialService();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

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
          return const NoDataView(title: 'Home', message: 'No user data found');
        }

        final user = snapshot.data!;
        return Scaffold(
          appBar: TopBar(
            companyName: user.companyName,
            userName: '${user.firstName} ${user.lastName}',
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const JobMaterialCreateUpdateView()),
                  ).then((value) => setState(() {}));
                },
                iconSize: AppStyles.topBarIconSize,
              ),
            ],
          ),
          backgroundColor: AppStyles.backgroundColor,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Material List',
                  style: AppStyles.headlineStyle,
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: StreamBuilder<List<JobMaterialModel>>(
                    stream: _jobMaterialService.getJobMaterials(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No material found'));
                      } else {
                        final jobMaterialList = snapshot.data!;
                        return ListView.builder(
                          itemCount: jobMaterialList.length,
                          itemBuilder: (context, index) {
                            final jobMaterial = jobMaterialList[index];
                            return ReusableCard(
                              icon: Icons.build,
                              title: jobMaterial.name,
                              subtitle: jobMaterial.description,
                              trailing: Text('\$${jobMaterial.price.toStringAsFixed(2)}'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => JobMaterialDetailView(jobMaterial: jobMaterial),
                                  ),
                                ).then((value) => setState(() {}));
                              },
                              onLongPress: () async {
                                bool? confirmDelete = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Delete Material'),
                                    content: const Text('Are you sure you want to delete this material?'),
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
                                  await _jobMaterialService.deleteJobMaterial(jobMaterial.documentId!);
                                  setState(() {});
                                }
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomBar(
            onHomePressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }
}
