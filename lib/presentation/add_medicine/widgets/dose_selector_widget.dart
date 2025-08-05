import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

// lib/presentation/add_medicine/widgets/dose_selector_widget.dart

class DoseSelectorWidget extends StatefulWidget {
  final String initialDose;
  final String initialUnit;
  final Function(String dose, String unit) onDoseChanged;

  const DoseSelectorWidget({
    super.key,
    required this.initialDose,
    required this.initialUnit,
    required this.onDoseChanged,
  });

  @override
  State<DoseSelectorWidget> createState() => _DoseSelectorWidgetState();
}

class _DoseSelectorWidgetState extends State<DoseSelectorWidget> {
  late TextEditingController _doseController;
  late String _selectedUnit;

  final List<String> _doseUnits = [
    'mg',
    'ml',
    'tablets',
    'capsules',
    'drops',
    'units',
    'mcg',
    'g',
    'tsp',
    'tbsp'
  ];

  @override
  void initState() {
    super.initState();
    _doseController = TextEditingController(text: widget.initialDose);
    _selectedUnit = widget.initialUnit;
  }

  @override
  void dispose() {
    _doseController.dispose();
    super.dispose();
  }

  void _updateDose() {
    widget.onDoseChanged(_doseController.text, _selectedUnit);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dosage *',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            // Dose amount input
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _doseController,
                decoration: InputDecoration(
                  hintText: 'Amount',
                  prefixIcon: CustomIconWidget(
                    iconName: 'numbers',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Invalid number';
                  }
                  return null;
                },
                onChanged: (value) => _updateDose(),
              ),
            ),
            SizedBox(width: 16),
            // Unit dropdown
            Expanded(
              flex: 1,
              child: DropdownButtonFormField<String>(
                value: _selectedUnit,
                decoration: InputDecoration(
                  hintText: 'Unit',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                items: _doseUnits.map((unit) {
                  return DropdownMenuItem<String>(
                    value: unit,
                    child: Text(unit),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedUnit = value;
                    });
                    _updateDose();
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'Enter the dose amount and select the unit',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
