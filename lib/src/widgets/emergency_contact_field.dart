import 'package:flutter/material.dart';

class EmergencyContactField extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final VoidCallback onRemove;

  const EmergencyContactField({super.key, 
    required this.nameController,
    required this.phoneController,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Emergency Contact Name'),
            validator: (value) => value!.isEmpty ? 'Enter contact name' : null,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: phoneController,
            decoration: const InputDecoration(labelText: 'Emergency Contact Phone'),
            validator: (value) => value!.isEmpty ? 'Enter contact phone' : null,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.remove_circle),
          onPressed: onRemove,
        ),
      ],
    );
  }
}
