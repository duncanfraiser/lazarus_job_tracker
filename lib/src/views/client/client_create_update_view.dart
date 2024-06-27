import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/models/client_model.dart';
import 'package:lazarus_job_tracker/src/services/client_service.dart';
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

class ClientCreateUpdateView extends StatefulWidget {
  final ClientModel? client;

  const ClientCreateUpdateView({super.key, this.client});

  @override
  _ClientCreateUpdateViewState createState() => _ClientCreateUpdateViewState();
}

class _ClientCreateUpdateViewState extends State<ClientCreateUpdateView> {
  final _formKey = GlobalKey<FormState>();
  final ClientService _clientService = ClientService();

  late TextEditingController _fNameController;
  late TextEditingController _lNameController;
  late TextEditingController _billingAddressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _fNameController = TextEditingController(text: widget.client?.fName ?? '');
    _lNameController = TextEditingController(text: widget.client?.lName ?? '');
    _billingAddressController = TextEditingController(text: widget.client?.billingAddress ?? '');
    _phoneController = TextEditingController(text: widget.client?.phone ?? '');
    _emailController = TextEditingController(text: widget.client?.email ?? '');
  }

  @override
  void dispose() {
    _fNameController.dispose();
    _lNameController.dispose();
    _billingAddressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final fName = _fNameController.text;
        final lName = _lNameController.text;
        final billingAddress = _billingAddressController.text;
        final phone = _phoneController.text;
        final email = _emailController.text;

        if (widget.client == null) {
          await _clientService.addClient(ClientModel(
            fName: fName,
            lName: lName,
            billingAddress: billingAddress,
            phone: phone,
            email: email,
          ));
        } else {
          await _clientService.updateClient(ClientModel(
            documentId: widget.client!.documentId,
            fName: fName,
            lName: lName,
            billingAddress: billingAddress,
            phone: phone,
            email: email,
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
            ],
          ),
          backgroundColor: AppStyles.backgroundColor,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        widget.client == null ? 'Create Client' : 'Update Client',
                        style: AppStyles.headlineStyle, // Using the original color
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  ReusableFormCard(
                    icon: Icons.person,
                    title: 'First Name',
                    controller: _fNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8.0), // Adjust spacing between cards
                  ReusableFormCard(
                    icon: Icons.person,
                    title: 'Last Name',
                    controller: _lNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8.0), // Adjust spacing between cards
                  ReusableFormCard(
                    icon: Icons.home,
                    title: 'Billing Address',
                    controller: _billingAddressController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a billing address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8.0), // Adjust spacing between cards
                  ReusableFormCard(
                    icon: Icons.phone,
                    title: 'Phone',
                    controller: _phoneController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8.0), // Adjust spacing between cards
                  ReusableFormCard(
                    icon: Icons.email,
                    title: 'Email',
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
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
