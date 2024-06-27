import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/models/equipment_model.dart';
import 'package:lazarus_job_tracker/src/services/equipment_service.dart';
import 'package:lazarus_job_tracker/src/app_styles.dart';
import 'package:lazarus_job_tracker/src/widgets/no_data_view.dart';
import 'package:provider/provider.dart';
import 'package:lazarus_job_tracker/src/services/auth_service.dart';
import 'package:lazarus_job_tracker/src/models/user_model.dart';
import 'package:lazarus_job_tracker/src/widgets/loading_view.dart';
import 'package:lazarus_job_tracker/src/widgets/error_view.dart';
import 'package:lazarus_job_tracker/src/widgets/top_bar.dart';
import 'package:lazarus_job_tracker/src/widgets/bottom_bar.dart';
import 'package:lazarus_job_tracker/src/widgets/reusable_form_card.dart';

class EquipmentCreateUpdateView extends StatefulWidget {
  final EquipmentModel? equipment;

  const EquipmentCreateUpdateView({super.key, this.equipment});

  @override
  _EquipmentCreateUpdateViewState createState() => _EquipmentCreateUpdateViewState();
}

class _EquipmentCreateUpdateViewState extends State<EquipmentCreateUpdateView> {
  final _formKey = GlobalKey<FormState>();
  final EquipmentService _equipmentService = EquipmentService();

  late TextEditingController _nameController;
  late TextEditingController _ratePerHourController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.equipment?.name ?? '');
    _ratePerHourController = TextEditingController(text: widget.equipment?.ratePerHour.toString() ?? '');
    _descriptionController = TextEditingController(text: widget.equipment?.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ratePerHourController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final name = _nameController.text;
        final ratePerHour = double.parse(_ratePerHourController.text);
        final description = _descriptionController.text;

        if (widget.equipment == null) {
          // Create new equipment
          await _equipmentService.addEquipment(EquipmentModel(
            name: name,
            ratePerHour: ratePerHour,
            description: description,
          ));
        } else {
          // Update existing equipment
          await _equipmentService.updateEquipment(EquipmentModel(
            documentId: widget.equipment!.documentId,
            name: name,
            ratePerHour: ratePerHour,
            description: description,
          ));
        }

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
        ));
      }
    }
  }

  void _deleteEquipment() async {
    if (widget.equipment != null && widget.equipment!.documentId != null) {
      bool? confirmDelete = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Equipment'),
          content: const Text('Are you sure you want to delete this equipment?'),
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
        await _equipmentService.deleteEquipment(widget.equipment!.documentId!);
        Navigator.pop(context); // Close the form after deletion
      }
    }
  }

  void _navigateHome() {
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

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
                icon: Icon(Icons.check, color: AppStyles.greenCheckIcon.color, size: AppStyles.greenCheckIcon.size),
                onPressed: _submitForm,
                iconSize: AppStyles.topBarIconSize,
              ),
              if (widget.equipment != null) // Show delete button only for existing equipment
                IconButton(
                  icon: Icon(Icons.delete, color: AppStyles.redDeleteIcon.color, size: AppStyles.redDeleteIcon.size),
                  onPressed: _deleteEquipment,
                  iconSize: AppStyles.topBarIconSize,
                ),
            ],
          ),
          backgroundColor: AppStyles.backgroundColor,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Text(
                    widget.equipment == null ? 'Create Equipment' : 'Update Equipment',
                    style: AppStyles.headlineStyle,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 16.0),
                  ReusableFormCard(
                    icon: Icons.build,
                    title: 'Name',
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text, // Added keyboardType
                  ),
                  const SizedBox(height: 8.0), // Adjust spacing between cards
                  ReusableFormCard(
                    icon: Icons.attach_money,
                    title: 'Rate per Hour',
                    controller: _ratePerHourController,
                    keyboardType: TextInputType.number, // Added keyboardType
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a rate per hour';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8.0), // Adjust spacing between cards
                  ReusableFormCard(
                    icon: Icons.description,
                    title: 'Description',
                    controller: _descriptionController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text, // Added keyboardType
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomBar(
            onHomePressed: _navigateHome,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }
}
