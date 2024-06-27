import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/models/job_model.dart';
import 'package:lazarus_job_tracker/src/models/user_model.dart';
import 'package:intl/intl.dart';

class EmployeeHoursDialog extends StatefulWidget {
  final List<UserModel> employees;
  final Map<String, List<EmployeeHour>> initialSelectedHours;

  const EmployeeHoursDialog({
    required this.employees,
    required this.initialSelectedHours,
    super.key,
  });

  @override
  _EmployeeHoursDialogState createState() => _EmployeeHoursDialogState();
}

class _EmployeeHoursDialogState extends State<EmployeeHoursDialog> {
  late Map<String, List<EmployeeHour>> _selectedHours;

  @override
  void initState() {
    super.initState();
    _selectedHours = Map.from(widget.initialSelectedHours);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.employees.length,
              itemBuilder: (context, index) {
                var employee = widget.employees[index];
                return ListTile(
                  title: Text('${employee.firstName} ${employee.lastName}'),
                  subtitle: _buildEmployeeHours(employee),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(_selectedHours),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeHours(UserModel employee) {
    var employeeId = employee.documentId!;
    var employeeHours = _selectedHours[employeeId] ?? [];

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: employeeHours.length,
          itemBuilder: (context, index) {
            var employeeHour = employeeHours[index];
            return Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: DateFormat('yyyy-MM-dd').format(employeeHour.date),
                    decoration: const InputDecoration(labelText: 'Date'),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: employeeHour.date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null && pickedDate != employeeHour.date) {
                        setState(() {
                          employeeHours[index] = EmployeeHour(date: pickedDate, hours: employeeHour.hours);
                          _selectedHours[employeeId] = employeeHours;
                        });
                      }
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    initialValue: employeeHour.hours.toString(),
                    decoration: const InputDecoration(labelText: 'Hours'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      var hours = double.tryParse(value) ?? 0.0;
                      setState(() {
                        employeeHours[index] = EmployeeHour(date: employeeHour.date, hours: hours);
                        _selectedHours[employeeId] = employeeHours;
                      });
                    },
                  ),
                ),
              ],
            );
          },
        ),
        TextButton(
          onPressed: () {
            setState(() {
              employeeHours.add(EmployeeHour(date: DateTime.now(), hours: 0));
              _selectedHours[employeeId] = employeeHours;
            });
          },
          child: const Text('Add Hour Entry'),
        ),
      ],
    );
  }
}
