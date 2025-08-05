import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

// lib/presentation/add_medicine/widgets/duration_selector_widget.dart

class DurationSelectorWidget extends StatefulWidget {
  final String selectedDuration;
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(String, DateTime?, DateTime?) onDurationChanged;

  const DurationSelectorWidget({
    super.key,
    required this.selectedDuration,
    this.startDate,
    this.endDate,
    required this.onDurationChanged,
  });

  @override
  State<DurationSelectorWidget> createState() => _DurationSelectorWidgetState();
}

class _DurationSelectorWidgetState extends State<DurationSelectorWidget> {
  final List<Map<String, dynamic>> _presetDurations = [
    {
      'id': '7 days',
      'name': '7 Days',
      'description': 'One week course',
      'icon': 'calendar_today',
    },
    {
      'id': '14 days',
      'name': '14 Days',
      'description': 'Two weeks course',
      'icon': 'calendar_today',
    },
    {
      'id': '30 days',
      'name': '30 Days',
      'description': 'One month supply',
      'icon': 'calendar_month',
    },
    {
      'id': 'ongoing',
      'name': 'Ongoing',
      'description': 'No end date',
      'icon': 'all_inclusive',
    },
    {
      'id': 'custom',
      'name': 'Custom Range',
      'description': 'Set specific dates',
      'icon': 'date_range',
    },
  ];

  void _selectDuration(String durationId) {
    if (durationId == 'custom') {
      _showDateRangePicker();
    } else {
      widget.onDurationChanged(durationId, null, null);
    }
  }

  Future<void> _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      initialDateRange: widget.startDate != null && widget.endDate != null
          ? DateTimeRange(start: widget.startDate!, end: widget.endDate!)
          : null,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Theme.of(context).colorScheme.surface,
              headerBackgroundColor: Theme.of(context).colorScheme.primary,
              headerForegroundColor: Theme.of(context).colorScheme.onPrimary,
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Theme.of(context).colorScheme.primary;
                }
                return null;
              }),
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Theme.of(context).colorScheme.onPrimary;
                }
                return Theme.of(context).colorScheme.onSurface;
              }),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      widget.onDurationChanged('custom', picked.start, picked.end);
    }
  }

  String _formatDateRange() {
    if (widget.startDate != null && widget.endDate != null) {
      final start = widget.startDate!;
      final end = widget.endDate!;
      final duration = end.difference(start).inDays + 1;
      return '${start.day}/${start.month}/${start.year} - ${end.day}/${end.month}/${end.year} ($duration days)';
    }
    return 'Select date range';
  }

  Widget _buildDurationOption(Map<String, dynamic> duration) {
    final isSelected = widget.selectedDuration == duration['id'];
    final isCustom = duration['id'] == 'custom';

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: duration['icon'],
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
        ),
        title: Text(
          duration['name'],
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
        ),
        subtitle: Text(
          isCustom && isSelected ? _formatDateRange() : duration['description'],
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        trailing: Radio<String>(
          value: duration['id'],
          groupValue: widget.selectedDuration,
          onChanged: (value) {
            if (value != null) {
              _selectDuration(value);
            }
          },
          activeColor: Theme.of(context).colorScheme.primary,
        ),
        onTap: () => _selectDuration(duration['id']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Duration',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 8),
        Column(
          children: _presetDurations
              .map((duration) => _buildDurationOption(duration))
              .toList(),
        ),
        SizedBox(height: 8),
        Text(
          'Select how long you need to take this medication',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
