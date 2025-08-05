import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mtcare/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/dose_selector_widget.dart';
import './widgets/duration_selector_widget.dart';
import './widgets/meal_instruction_widget.dart';
import './widgets/pill_name_input_widget.dart';
import './widgets/pill_shape_selector_widget.dart';
import './widgets/reminder_settings_widget.dart';
import './widgets/time_picker_section_widget.dart';

class AddMedicine extends StatefulWidget {
  final int? medicationId;

  const AddMedicine({super.key, this.medicationId});

  @override
  State<AddMedicine> createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _pillNameFocusNode = FocusNode();

  // Form data
  String _pillName = '';
  String _selectedDose = '';
  String _selectedDoseUnit = 'mg';
  String _selectedPillShape = 'round';
  List<String> _selectedTimes = [];
  Map<String, TimeOfDay> _customTimes = {};
  String _selectedDuration = '7 days';
  DateTime? _customStartDate;
  DateTime? _customEndDate;
  String _mealInstruction = 'Before meals';
  bool _reminderEnabled = true;
  String _reminderSound = 'Default';
  String? _selectedRingtonePath;
  bool _hasUnsavedChanges = false;

  // Validation state
  bool get _isFormValid {
    return _pillName.isNotEmpty &&
        _selectedDose.isNotEmpty &&
        _selectedTimes.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _pillNameFocusNode.addListener(_onFocusChange);
    if (widget.medicationId != null) {
      _loadMedicationData();
    }
  }

  Future<void> _loadMedicationData() async {
    final prefs = await SharedPreferences.getInstance();
    final medicationsString = prefs.getString('medications');
    if (medicationsString != null) {
      final medications = (jsonDecode(medicationsString) as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      final medication = medications.firstWhere(
        (med) => med['id'] == widget.medicationId,
        orElse: () => {},
      );
      if (medication.isNotEmpty) {
        setState(() {
          _pillName = medication['name'];
          _selectedDose = medication['dosage'].replaceAll(
            RegExp(r'[^0-9]'),
            '',
          );
          _selectedDoseUnit = medication['dosage'].replaceAll(
            RegExp(r'[0-9]'),
            '',
          );
          _selectedPillShape = medication['shape'];

          // Handle new and old times format
          final dynamic timesData = medication['times'];
          if (timesData is List) {
            if (timesData.isNotEmpty && timesData[0] is Map) {
              // New format: List<Map<String, dynamic>>
              _selectedTimes = (timesData)
                  .map((e) => e['time'].toString())
                  .toList();
              _customTimes = { for (var e in timesData) e['time'].toString() : TimeOfDay.fromDateTime(
                  DateTime.parse('2000-01-01 ${e['time']}'),
                ) };
            } else {
              // Old format: List<String>
              _selectedTimes = List<String>.from(timesData);
              _customTimes = { for (var time in _selectedTimes) time : TimeOfDay.fromDateTime(DateTime.parse('2000-01-01 $time')) };
            }
          }

          _selectedDuration = medication['duration'];
          _mealInstruction = medication['instructions'];
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pillNameFocusNode.removeListener(_onFocusChange);
    _pillNameFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_pillNameFocusNode.hasFocus) {
      Future.delayed(Duration(milliseconds: 300), () {
        _scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void _updatePillName(String value) {
    setState(() {
      _pillName = value;
      _hasUnsavedChanges = true;
    });
  }

  void _updateDose(String dose, String unit) {
    setState(() {
      _selectedDose = dose;
      _selectedDoseUnit = unit;
      _hasUnsavedChanges = true;
    });
  }

  void _updatePillShape(String shape) {
    setState(() {
      _selectedPillShape = shape;
      _hasUnsavedChanges = true;
    });
  }

  void _updateSelectedTimes(
    List<String> times,
    Map<String, TimeOfDay> customTimes,
  ) {
    setState(() {
      _selectedTimes = times;
      _customTimes = customTimes;
      _hasUnsavedChanges = true;
    });
  }

  void _updateDuration(
    String duration,
    DateTime? startDate,
    DateTime? endDate,
  ) {
    setState(() {
      _selectedDuration = duration;
      _customStartDate = startDate;
      _customEndDate = endDate;
      _hasUnsavedChanges = true;
    });
  }

  void _updateMealInstruction(String instruction) {
    setState(() {
      _mealInstruction = instruction;
      _hasUnsavedChanges = true;
    });
  }

  void _updateReminderSettings(
    bool enabled,
    String sound, {
    String? soundPath,
  }) {
    setState(() {
      _reminderEnabled = enabled;
      _reminderSound = sound;
      _selectedRingtonePath = soundPath;
      _hasUnsavedChanges = true;
    });
  }

  Future<bool> _showUnsavedChangesDialog() async {
    if (!_hasUnsavedChanges) return true;

    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Unsaved Changes'),
              content: const Text(
                'You have unsaved changes. Do you want to discard them?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Discard'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    _saveMedication();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void _saveMedication() async {
    if (!_formKey.currentState!.validate() || !_isFormValid) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in all required fields'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Show loading indicator
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final medicationsString = prefs.getString('medications');
    List<Map<String, dynamic>> medications = [];
    if (medicationsString != null) {
      medications = (jsonDecode(medicationsString) as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();
    }

    final List<Map<String, dynamic>> newTimesData = _selectedTimes
        .map((time) => {'time': time, 'isTaken': false})
        .toList();

    final newMedication = {
      'id': widget.medicationId ?? DateTime.now().millisecondsSinceEpoch,
      'name': _pillName,
      'nameBangla': ' ', // Add a way to input this if needed
      'dosage': '$_selectedDose$_selectedDoseUnit',
      'times': newTimesData, // Changed to list of maps
      'timeType': 'morning', // This should be determined from the time
      'shape': _selectedPillShape,
      'color': '#FFFFFF', // This should be selectable
      'day': 'today', // This should be determined from the duration
      'instructions': _mealInstruction,
      'nextDose': '', // This should be calculated
      'totalDoses': _selectedTimes.length,
      'completedDoses': 0,
      'duration': _selectedDuration,
      'taken': false,
    };

    if (widget.medicationId != null) {
      final index = medications.indexWhere(
        (med) => med['id'] == widget.medicationId,
      );
      if (index != -1) {
        medications[index] = newMedication;
      }
    } else {
      medications.add(newMedication);
    }

    await prefs.setString('medications', jsonEncode(medications));

    if (_reminderEnabled) {
      for (var time in _selectedTimes) {
        final timeOfDay = _customTimes[time]!;
        final now = DateTime.now();
        DateTime scheduledTime = DateTime(
          now.year,
          now.month,
          now.day,
          timeOfDay.hour,
          timeOfDay.minute,
        );

        // Schedule notification 5 minutes before the actual alarm time
        scheduledTime = scheduledTime.subtract(const Duration(minutes: 5));

        // Format the alarm time for the notification message
        final String formattedAlarmTime =
            "${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}";

        notificationService.scheduleNotification(
          id: newMedication['id'] as int,
          title: 'Upcoming Medication: $_pillName',
          body:
              'Your medication $_pillName is due at $formattedAlarmTime. Prepare to take your dose.',
          scheduledTime: scheduledTime,
          soundPath: _selectedRingtonePath,
        );
      }
    }

    if (!mounted) return;
    Navigator.of(context).pop(); // Dismiss loading dialog

    // Show success message
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Medication saved successfully!'),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        action: SnackBarAction(
          label: 'Add Another',
          onPressed: () {
            // Reset form
            setState(() {
              _pillName = '';
              _selectedDose = '';
              _selectedTimes.clear();
              _customTimes.clear();
              _hasUnsavedChanges = false;
            });
          },
        ),
      ),
    );

    // Navigate back
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        final shouldPop = await _showUnsavedChangesDialog();
        if (shouldPop) {
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            widget.medicationId == null ? 'Add Medicine' : 'Edit Medicine',
          ),
          leading: IconButton(
            onPressed: () async {
              final shouldPop = await _showUnsavedChangesDialog();
              if (shouldPop) {
                if (!mounted) return;
                Navigator.of(context).pop();
              }
            },
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Dismiss keyboard
                FocusScope.of(context).unfocus();
              },
              child: Text('Done'),
            ),
          ],
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              children: [
                // Pill Name Input
                PillNameInputWidget(
                  focusNode: _pillNameFocusNode,
                  initialValue: _pillName,
                  onChanged: _updatePillName,
                ),
                SizedBox(height: 24),

                // Dose Selector
                DoseSelectorWidget(
                  initialDose: _selectedDose,
                  initialUnit: _selectedDoseUnit,
                  onDoseChanged: _updateDose,
                ),
                SizedBox(height: 24),

                // Pill Shape Selector
                PillShapeSelectorWidget(
                  selectedShape: _selectedPillShape,
                  onShapeChanged: _updatePillShape,
                ),
                SizedBox(height: 24),

                // Time Picker Section
                TimePickerSectionWidget(
                  selectedTimes: _selectedTimes,
                  customTimes: _customTimes,
                  onTimesChanged: _updateSelectedTimes,
                ),
                SizedBox(height: 24),

                // Duration Selector
                DurationSelectorWidget(
                  selectedDuration: _selectedDuration,
                  startDate: _customStartDate,
                  endDate: _customEndDate,
                  onDurationChanged: _updateDuration,
                ),
                SizedBox(height: 24),

                // Meal Instruction
                MealInstructionWidget(
                  selectedInstruction: _mealInstruction,
                  onInstructionChanged: _updateMealInstruction,
                ),
                SizedBox(height: 24),

                // Reminder Settings
                ReminderSettingsWidget(
                  reminderEnabled: _reminderEnabled,
                  reminderSound: _reminderSound,
                  selectedRingtonePath: _selectedRingtonePath,
                  onSettingsChanged: (enabled, sound, {soundPath}) {
                    _updateReminderSettings(
                      enabled,
                      sound,
                      soundPath: soundPath,
                    );
                  },
                ),
                SizedBox(height: 32),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isFormValid ? _saveMedication : null,
                    child: Text(
                      'Save Medication',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
