import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

// lib/presentation/add_medicine/widgets/reminder_settings_widget.dart

class ReminderSettingsWidget extends StatefulWidget {
  final bool reminderEnabled;
  final String reminderSound;
  final String? selectedRingtonePath;
  final Function(bool, String, {String? soundPath}) onSettingsChanged;

  const ReminderSettingsWidget({
    super.key,
    required this.reminderEnabled,
    required this.reminderSound,
    this.selectedRingtonePath,
    required this.onSettingsChanged,
  });

  @override
  State<ReminderSettingsWidget> createState() => _ReminderSettingsWidgetState();
}

class _ReminderSettingsWidgetState extends State<ReminderSettingsWidget> {
  final List<Map<String, dynamic>> _reminderSounds = [
    {
      'id': 'Default',
      'name': 'Default',
      'description': 'System default sound',
      'icon': 'volume_up',
    },
    {
      'id': 'Gentle',
      'name': 'Gentle Chime',
      'description': 'Soft notification sound',
      'icon': 'music_note',
    },
    {
      'id': 'Alert',
      'name': 'Alert Tone',
      'description': 'Clear attention sound',
      'icon': 'notification_important',
    },
    {
      'id': 'Medical',
      'name': 'Medical Beep',
      'description': 'Hospital-style beep',
      'icon': 'medical_services',
    },
    {
      'id': 'Nature',
      'name': 'Nature Sound',
      'description': 'Calming natural sound',
      'icon': 'nature',
    },
    {
      'id': 'Vibrate',
      'name': 'Vibrate Only',
      'description': 'Silent with vibration',
      'icon': 'vibration',
    },
  ];

  void _toggleReminder(bool enabled) {
    widget.onSettingsChanged(enabled, widget.reminderSound, soundPath: widget.selectedRingtonePath);
  }

  void _selectSound(String soundId, {String? soundPath}) {
    widget.onSettingsChanged(widget.reminderEnabled, soundId, soundPath: soundPath);
  }

  Future<void> _pickSoundFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      _selectSound('Custom', soundPath: result.files.single.path!);
      if (mounted) Navigator.pop(context); // Dismiss the bottom sheet
    }
  }

  void _showSoundSelector() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (BuildContext context) {
          return Container(
              padding: EdgeInsets.all(24),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Reminder Sound',
                              style: Theme.of(context).textTheme.headlineSmall),
                          IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: CustomIconWidget(
                                  iconName: 'close',
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  size: 24)),
                        ]),
                    SizedBox(height: 16),
                    Container(
                        constraints: BoxConstraints(maxHeight: 400),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _reminderSounds.length + 1, // +1 for custom sound
                                                        itemBuilder: (context, index) {
                              if (index < _reminderSounds.length) {
                                final sound = _reminderSounds[index];
                                final isSelected =
                                    widget.reminderSound == sound['id'];

                                return ListTile(
                                    leading: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: isSelected
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .surfaceContainerHighest,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Center(
                                            child: CustomIconWidget(
                                                iconName: sound['icon'],
                                                color: isSelected
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                                size: 20))),
                                    title: Text(sound['name'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                                color: isSelected
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .onSurface,
                                                fontWeight: isSelected
                                                    ? FontWeight.w600
                                                    : FontWeight.w500)),
                                    subtitle: Text(sound['description'], style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                                    trailing: Radio<String>(
                                        value: sound['id'],
                                        groupValue: widget.reminderSound,
                                        onChanged: (value) {
                                          if (value != null) {
                                            _selectSound(value);
                                            Navigator.pop(context);
                                          }
                                        },
                                        activeColor: Theme.of(context).colorScheme.primary),
                                    onTap: () {
                                      _selectSound(sound['id']);
                                      Navigator.pop(context);
                                    });
                              } else {
                                // Custom sound option
                                final isSelected = widget.reminderSound == 'Custom';
                                return ListTile(
                                  leading: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: isSelected
                                              ? Theme.of(context).colorScheme.primary
                                              : Theme.of(context).colorScheme.surfaceContainerHighest,
                                          borderRadius: BorderRadius.circular(20)),
                                      child: Center(
                                          child: CustomIconWidget(
                                              iconName: 'folder_open',
                                              color: isSelected
                                                  ? Theme.of(context).colorScheme.onPrimary
                                                  : Theme.of(context).colorScheme.onSurfaceVariant,
                                              size: 20))),
                                  title: Text('Select from Storage',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                              color: isSelected
                                                  ? Theme.of(context).colorScheme.primary
                                                  : Theme.of(context).colorScheme.onSurface,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w500)),
                                  subtitle: Text(
                                      widget.selectedRingtonePath != null
                                          ? widget.selectedRingtonePath!.split('/').last
                                          : 'Choose an audio file from your device',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.onSurfaceVariant)),
                                  trailing: Radio<String>(
                                      value: 'Custom',
                                      groupValue: widget.reminderSound,
                                      onChanged: (value) {
                                        if (value != null) {
                                          _pickSoundFile();
                                        }
                                      },
                                      activeColor: Theme.of(context).colorScheme.primary),
                                  onTap: _pickSoundFile,
                                );
                              }
                            })),
                  ]));
        });
  }

  @override
  Widget build(BuildContext context) {
    final selectedSound = widget.reminderSound == 'Custom'
        ? {
            'id': 'Custom',
            'name': widget.selectedRingtonePath != null
                ? widget.selectedRingtonePath!.split('/').last
                : 'Custom Sound',
            'description': 'Selected from device storage',
            'icon': 'folder_open',
          }
        : _reminderSounds.firstWhere(
            (sound) => sound['id'] == widget.reminderSound,
            orElse: () => _reminderSounds[0]);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Reminder Settings',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600)),
      SizedBox(height: 16),

      // Reminder toggle
      Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: Theme.of(context).colorScheme.outline, width: 1)),
          child: Row(children: [
            Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: widget.reminderEnabled
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                    child: CustomIconWidget(
                        iconName: 'notifications',
                        color: widget.reminderEnabled
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        size: 20))),
            SizedBox(width: 16),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Set Reminder',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w500)),
                  Text('Get notified when it\'s time to take medication',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant)),
                ])),
            Switch(
                value: widget.reminderEnabled,
                onChanged: _toggleReminder,
                activeColor: Theme.of(context).colorScheme.primary),
          ])),

      if (widget.reminderEnabled) ...[
        SizedBox(height: 16),

        // Sound selector
        GestureDetector(
            onTap: _showSoundSelector,
            child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1)),
                child: Row(children: [
                  Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: CustomIconWidget(
                              iconName: selectedSound['icon'],
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 20))),
                  SizedBox(width: 16),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text('Reminder Sound',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w500)),
                        Text(selectedSound['name'],
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500)),
                      ])),
                  CustomIconWidget(
                      iconName: 'chevron_right',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 20),
                ]))),
      ],

      SizedBox(height: 8),
      Text(
          widget.reminderEnabled
              ? 'Reminders will be scheduled for selected times'
              : 'Enable reminders to get notified about your medication',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant)),
    ]);
  }
}
