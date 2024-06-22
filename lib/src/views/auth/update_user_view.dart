import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/models/user_model.dart';
import 'package:lazarus_job_tracker/src/services/auth_service.dart';
import 'package:lazarus_job_tracker/src/widgets/custom_text_field.dart';


class UpdateUserView extends StatefulWidget {
  final UserModel user;

  const UpdateUserView({super.key, required this.user});

  @override
  // ignore: library_private_types_in_public_api
  _UpdateUserViewState createState() => _UpdateUserViewState();
}

class _UpdateUserViewState extends State<UpdateUserView> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.user.firstName);
    lastNameController = TextEditingController(text: widget.user.lastName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update User')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              CustomTextField(
                controller: firstNameController,
                label: 'First Name',
                validator: (value) => value!.isEmpty ? 'Enter first name' : null,
              ),
              CustomTextField(
                controller: lastNameController,
                label: 'Last Name',
                validator: (value) => value!.isEmpty ? 'Enter last name' : null,
              ),
              const SizedBox(height: 20),
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await _authService.updateUserData(widget.user.id, {
                        'firstName': firstNameController.text,
                        'lastName': lastNameController.text,
                      });
                      Navigator.pop(context);
                    } catch (e) {
                      setState(() {
                        errorMessage = e.toString();
                      });
                    }
                  }
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
