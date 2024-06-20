import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:lazarus_job_tracker/src/models/equipment_model.dart';
import 'package:lazarus_job_tracker/src/models/job_model.dart';

class EquipmentUsageDialog extends StatefulWidget {
  final EquipmentModel equipment;
  final List<EquipmentUsage> usage;

  const EquipmentUsageDialog({
    required this.equipment,
    required this.usage,
  });

  @override
  _EquipmentUsageDialogState createState() => _EquipmentUsageDialogState();
}

class _EquipmentUsageDialogState extends State<EquipmentUsageDialog> {
  final List<EquipmentUsage> _usage = [];
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd'); // Define the date format

  @override
  void initState() {
    super.initState();
    _usage.addAll(widget.usage);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Usage for ${widget.equipment.name}'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            for (var entry in _usage)
              ListTile(
                title: Text('Date: ${_dateFormat.format(entry.date)}'),
                subtitle: Text('Hours: ${entry.hours}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _usage.remove(entry);
                    });
                  },
                ),
              ),
            ElevatedButton(
              onPressed: _addNewEntry,
              child: Text('Add New Entry'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_usage),
          child: Text('Save'),
        ),
      ],
    );
  }

  void _addNewEntry() async {
    final dateController = TextEditingController();
    final hoursController = TextEditingController();

    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Usage Entry'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'Date (yyyy-MM-dd)'),
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
              controller: hoursController,
              decoration: InputDecoration(labelText: 'Hours'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (dateController.text.isNotEmpty && hoursController.text.isNotEmpty) {
                try {
                  final date = _dateFormat.parse(dateController.text); // Parse the date using the defined format
                  final hours = double.parse(hoursController.text);
                  Navigator.of(context).pop(EquipmentUsage(date: date, hours: hours));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: Invalid date or hours format')),
                  );
                }
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );

    if (result != null && result is EquipmentUsage) {
      setState(() {
        _usage.add(result);
      });
    }
  }
}
