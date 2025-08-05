import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

// lib/presentation/add_medicine/widgets/pill_name_input_widget.dart

class PillNameInputWidget extends StatefulWidget {
  final FocusNode? focusNode;
  final String initialValue;
  final Function(String) onChanged;

  const PillNameInputWidget({
    super.key,
    this.focusNode,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<PillNameInputWidget> createState() => _PillNameInputWidgetState();
}

class _PillNameInputWidgetState extends State<PillNameInputWidget> {
  late TextEditingController _controller;
  List<String> _suggestions = [];
  bool _showSuggestions = false;

  // Common medication names for autocomplete
  final List<String> _commonMedications = [
    'Paracetamol',
    'Aspirin',
    'Ibuprofen',
    'Metformin',
    'Lisinopril',
    'Amlodipine',
    'Metoprolol',
    'Omeprazole',
    'Simvastatin',
    'Levothyroxine',
    'Azithromycin',
    'Amoxicillin',
    'Hydrochlorothiazide',
    'Atorvastatin',
    'Losartan',
    'Gabapentin',
    'Sertraline',
    'Montelukast',
    'Furosemide',
    'Tramadol',
    'Trazodone',
    'Albuterol',
    'Pantoprazole',
    'Warfarin',
    'Clopidogrel',
    'Fluticasone',
    'Insulin',
    'Vitamin D',
    'Calcium',
    'Iron',
    'Folic Acid',
    'Vitamin B12',
    'Omega-3',
    'Probiotics'
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateSuggestions(String query) {
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    final filteredSuggestions = _commonMedications
        .where((med) => med.toLowerCase().contains(query.toLowerCase()))
        .take(5)
        .toList();

    setState(() {
      _suggestions = filteredSuggestions;
      _showSuggestions = filteredSuggestions.isNotEmpty;
    });
  }

  void _selectSuggestion(String suggestion) {
    _controller.text = suggestion;
    widget.onChanged(suggestion);
    setState(() {
      _showSuggestions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Medication Name *',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 8),
        Stack(
          children: [
            TextFormField(
              controller: _controller,
              focusNode: widget.focusNode,
              decoration: InputDecoration(
                hintText: 'Enter medication name',
                prefixIcon: CustomIconWidget(
                  iconName: 'medication',
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _controller.clear();
                          widget.onChanged('');
                          _updateSuggestions('');
                        },
                        icon: CustomIconWidget(
                          iconName: 'clear',
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      )
                    : null,
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Medication name is required';
                }
                return null;
              },
              onChanged: (value) {
                widget.onChanged(value);
                _updateSuggestions(value);
              },
              onTap: () {
                if (_controller.text.isNotEmpty) {
                  _updateSuggestions(_controller.text);
                }
              },
            ),
            if (_showSuggestions)
              Positioned(
                top: 56,
                left: 0,
                right: 0,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1,
                      ),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = _suggestions[index];
                        return ListTile(
                          dense: true,
                          leading: CustomIconWidget(
                            iconName: 'medication',
                            color: Theme.of(context).colorScheme.primary,
                            size: 18,
                          ),
                          title: Text(
                            suggestion,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          onTap: () => _selectSuggestion(suggestion),
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'Start typing to see suggestions',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
