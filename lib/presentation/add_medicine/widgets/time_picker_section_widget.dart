


import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

// lib/presentation/add_medicine/widgets/time_picker_section_widget.dart

class TimePickerSectionWidget extends StatefulWidget {
  final List<String> selectedTimes;
  final Map<String, TimeOfDay> customTimes;
  final Function(List<String>, Map<String, TimeOfDay>) onTimesChanged;

  const TimePickerSectionWidget({
    super.key,
    required this.selectedTimes,
    required this.customTimes,
    required this.onTimesChanged,
  });

  @override
  State<TimePickerSectionWidget> createState() =>
      _TimePickerSectionWidgetState();
}

class _TimePickerSectionWidgetState extends State<TimePickerSectionWidget> {
  final List<Map<String, dynamic>> _timeSlots = [
    {
      'id': 'morning',
      'name': 'Morning',
      'icon': 'wb_sunny',
      'defaultTime': TimeOfDay(hour: 8, minute: 0),
      'description': '8:00 AM',
    },
    {
      'id': 'noon',
      'name': 'Noon',
      'icon': 'wb_sunny_outlined',
      'defaultTime': TimeOfDay(hour: 12, minute: 0),
      'description': '12:00 PM',
    },
    {
      'id': 'evening',
      'name': 'Evening',
      'icon': 'wb_twilight',
      'defaultTime': TimeOfDay(hour: 18, minute: 0),
      'description': '6:00 PM',
    },
    {
      'id': 'night',
      'name': 'Night',
      'icon': 'nights_stay',
      'defaultTime': TimeOfDay(hour: 22, minute: 0),
      'description': '10:00 PM',
    },
  ];

  void _toggleTimeSlot(String timeId) {
    List<String> newSelectedTimes = List.from(widget.selectedTimes);
    Map<String, TimeOfDay> newCustomTimes = Map.from(widget.customTimes);

    if (newSelectedTimes.contains(timeId)) {
      newSelectedTimes.remove(timeId);
      newCustomTimes.remove(timeId);
    } else {
      newSelectedTimes.add(timeId);
      final timeSlot = _timeSlots.firstWhere((slot) => slot['id'] == timeId);
      newCustomTimes[timeId] = timeSlot['defaultTime'];
    }

    widget.onTimesChanged(newSelectedTimes, newCustomTimes);
  }

  Future<void> _selectCustomTime(String timeId) async {
    final currentTime = widget.customTimes[timeId] ?? TimeOfDay.now();

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).colorScheme.surface,
              hourMinuteTextColor: Theme.of(context).colorScheme.onSurface,
              dialHandColor: Theme.of(context).colorScheme.primary,
              dialBackgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      Map<String, TimeOfDay> newCustomTimes = Map.from(widget.customTimes);
      newCustomTimes[timeId] = selectedTime;
      widget.onTimesChanged(widget.selectedTimes, newCustomTimes);
    }
  }

  

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour == 0 ? 12 : hour}:$minute $period';
  }

  Widget _buildTimeSlot(Map<String, dynamic> timeSlot) {
    final isSelected = widget.selectedTimes.contains(timeSlot['id']);
    final customTime = widget.customTimes[timeSlot['id']];
    final displayTime =
        customTime != null ? _formatTime(customTime) : timeSlot['description'];

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
              iconName: timeSlot['icon'],
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
        ),
        title: Text(
          timeSlot['name'],
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
        ),
        subtitle: Text(
          displayTime,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              IconButton(
                onPressed: () => _selectCustomTime(timeSlot['id']),
                icon: CustomIconWidget(
                  iconName: 'schedule',
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                tooltip: 'Set custom time',
              ),
            Checkbox(
              value: isSelected,
              onChanged: (value) => _toggleTimeSlot(timeSlot['id']),
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
        onTap: () => _toggleTimeSlot(timeSlot['id']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Medication Times *',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 8),
        if (widget.selectedTimes.isEmpty)
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'warning',
                  color: Theme.of(context).colorScheme.onErrorContainer,
                  size: 20,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Please select at least one time',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                  ),
                ),
              ],
            ),
          ),
        SizedBox(height: 8),
        Column(
          children:
              _timeSlots.map((timeSlot) => _buildTimeSlot(timeSlot)).toList(),
        ),
        SizedBox(height: 8),
        Text(
          'Select when you want to take this medication. Tap the clock icon to set custom times.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
