import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobMaterialUsage {
  final DateTime date;
  final double quantity;

  JobMaterialUsage({
    required this.date,
    required this.quantity,
  });

  factory JobMaterialUsage.fromJson(Map<String, dynamic> json) {
    return JobMaterialUsage(
      date: (json['date'] as Timestamp).toDate(),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'quantity': quantity,
    };
  }
}

class JobMaterialUsageDialog extends StatefulWidget {
  final String jobMaterialName;
  final List<JobMaterialUsage> usage;

  const JobMaterialUsageDialog({super.key, 
    required this.jobMaterialName,
    required this.usage,
  });

  @override
  _JobMaterialUsageDialogState createState() => _JobMaterialUsageDialogState();
}

class _JobMaterialUsageDialogState extends State<JobMaterialUsageDialog> {
  final List<JobMaterialUsage> _usage = [];
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _usage.addAll(widget.usage);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Usage for ${widget.jobMaterialName}'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            for (var entry in _usage)
              ListTile(
                title: Text('Date: ${_dateFormat.format(entry.date)}'),
                subtitle: Text('Quantity: ${entry.quantity}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _usage.remove(entry);
                    });
                  },
                ),
              ),
            ElevatedButton(
              onPressed: _addNewEntry,
              child: const Text('Add New Entry'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_usage),
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _addNewEntry() async {
    final dateController = TextEditingController();
    final quantityController = TextEditingController();

    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Usage Entry'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: dateController,
              decoration: const InputDecoration(labelText: 'Date (yyyy-MM-dd)'),
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null) {
                  dateController.text = _dateFormat.format(picked);
                }
              },
            ),
            TextFormField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (dateController.text.isNotEmpty && quantityController.text.isNotEmpty) {
                try {
                  final date = _dateFormat.parse(dateController.text);
                  final quantity = double.parse(quantityController.text);
                  Navigator.of(context).pop(JobMaterialUsage(date: date, quantity: quantity));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error: Invalid date or quantity format')),
                  );
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result != null && result is JobMaterialUsage) {
      setState(() {
        _usage.add(result);
      });
    }
  }
}
