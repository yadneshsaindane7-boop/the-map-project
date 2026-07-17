import 'package:flutter/material.dart';

import '../models/incident_type.dart';

class IncidentTypeDropdown extends StatelessWidget {
  final IncidentType selectedType;
  final ValueChanged<IncidentType?> onChanged;

  const IncidentTypeDropdown({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<IncidentType>(
      initialValue: selectedType,
      decoration: const InputDecoration(
        labelText: 'Incident Type',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.report_problem_outlined),
      ),
      items: IncidentType.values
          .map(
            (type) => DropdownMenuItem<IncidentType>(
              value: type,
              child: Text(type.label),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Please select an incident type';
        }
        return null;
      },
    );
  }
}