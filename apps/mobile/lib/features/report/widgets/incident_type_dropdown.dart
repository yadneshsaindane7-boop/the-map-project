import 'package:flutter/material.dart';

import '../../../core/localization/app_localizations_helpers.dart';
import '../../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return DropdownButtonFormField<IncidentType>(
      initialValue: selectedType,
      decoration: InputDecoration(
        labelText: l10n.incidentType,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.report_problem_outlined),
      ),
      items: IncidentType.values
          .map(
            (type) => DropdownMenuItem<IncidentType>(
              value: type,
              child: Text(type.localizedLabel(context)),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return l10n.selectIncidentType;
        }
        return null;
      },
    );
  }
}