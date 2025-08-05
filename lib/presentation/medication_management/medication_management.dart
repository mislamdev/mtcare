import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/medication_card_widget.dart';

class MedicationManagement extends StatefulWidget {
  const MedicationManagement({super.key});

  @override
  State<MedicationManagement> createState() => _MedicationManagementState();
}

class _MedicationManagementState extends State<MedicationManagement>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Map<String, dynamic>> _medicationsData = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadMedications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMedications() async {
    final prefs = await SharedPreferences.getInstance();
    final medicationsString = prefs.getString('medications');
    if (medicationsString != null) {
      setState(() {
        _medicationsData = (jsonDecode(medicationsString) as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
      });
    }
  }

  Future<void> _saveMedications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('medications', jsonEncode(_medicationsData));
  }

  List<Map<String, dynamic>> get _filteredMedications {
    final currentDay = _tabController.index == 0 ? "today" : "tomorrow";
    return _medicationsData.where((medication) {
      final matchesDay = medication["day"] == currentDay;
      final matchesSearch =
          _searchQuery.isEmpty ||
          medication["name"].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          medication["nameBangla"].contains(_searchQuery);
      return matchesDay && matchesSearch;
    }).toList();
  }

  void _markAsTaken(int medicationId) {
    setState(() {
      final index = _medicationsData.indexWhere(
        (med) => med["id"] == medicationId,
      );
      if (index != -1) {
        _medicationsData[index]["taken"] = true;
        _medicationsData[index]["completedDoses"]++;
      }
    });
    _saveMedications();

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Medication marked as taken'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _editMedication(int medicationId) {
    // Navigate to edit medication screen
    Navigator.pushNamed(
      context,
      '/add-medicine',
      arguments: medicationId,
    ).then((_) => _loadMedications());
  }

  void _deleteMedication(int medicationId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Medication'),
          content: Text('Are you sure you want to delete this medication?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _medicationsData.removeWhere(
                    (med) => med["id"] == medicationId,
                  );
                });
                _saveMedications();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Medication deleted'),
                    backgroundColor: AppTheme.lightTheme.colorScheme.error,
                  ),
                );
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _snoozeMedication(int medicationId) {
    setState(() {
      final index = _medicationsData.indexWhere(
        (med) => med["id"] == medicationId,
      );
      if (index != -1) {
        // This is a simplified implementation
        _medicationsData[index]["time"] = "Snoozed for 15 min";
      }
    });
    _saveMedications();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Medication snoozed for 15 minutes'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }

  void _showMedicationDetails(Map<String, dynamic> medication) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
                  Text(
                    'Medication Details',
                    style: AppTheme.lightTheme.textTheme.headlineSmall,
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                medication["name"],
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              Text(
                medication["nameBangla"],
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 16),
              _buildDetailRow('Dosage', medication["dosage"]),
              _buildDetailRow('Time', medication["time"]),
              _buildDetailRow('Instructions', medication["instructions"]),
              _buildDetailRow('Next Dose', medication["nextDose"]),
              _buildDetailRow(
                'Progress',
                '${medication["completedDoses"]}/${medication["totalDoses"]} doses taken',
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _editMedication(medication["id"]);
                  },
                  child: Text('Edit Medication'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: AppTheme.lightTheme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshMedications() async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));
    _loadMedications();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Medications updated'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Medication Management'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(
              context,
              '/add-medicine',
            ).then((_) => _loadMedications()),
            icon: CustomIconWidget(
              iconName: 'add',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search medications...',
                    prefixIcon: CustomIconWidget(
                      iconName: 'search',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                            icon: CustomIconWidget(
                              iconName: 'clear',
                              color: AppTheme
                                  .lightTheme
                                  .colorScheme
                                  .onSurfaceVariant,
                              size: 20,
                            ),
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              // Tab bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppTheme.lightTheme.primaryColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelColor: AppTheme.lightTheme.colorScheme.onPrimary,
                  unselectedLabelColor:
                      AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(text: 'Today'),
                    Tab(text: 'Tomorrow'),
                  ],
                  onTap: (index) {
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildMedicationList(), _buildMedicationList()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(
          context,
          '/add-medicine',
        ).then((_) => _loadMedications()),
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildMedicationList() {
    final medications = _filteredMedications;
    final pendingMedications = medications
        .where((med) => !med["taken"])
        .toList();
    final completedMedications = medications
        .where((med) => med["taken"])
        .toList();

    if (medications.isEmpty) {
      return EmptyStateWidget(
        day: _tabController.index == 0 ? 'today' : 'tomorrow',
        onAddMedicine: () => Navigator.pushNamed(
          context,
          '/add-medicine',
        ).then((_) => _loadMedications()),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshMedications,
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          if (pendingMedications.isNotEmpty)
            _buildSectionHeader('Pending', pendingMedications.length),
          ...pendingMedications.map(
            (medication) => MedicationCardWidget(
              medication: medication,
              onTaken: () => _markAsTaken(medication["id"]),
              onEdit: () => _editMedication(medication["id"]),
              onDelete: () => _deleteMedication(medication["id"]),
              onSnooze: () => _snoozeMedication(medication["id"]),
              onLongPress: () => _showMedicationDetails(medication),
            ),
          ),
          if (completedMedications.isNotEmpty)
            _buildSectionHeader('Completed', completedMedications.length),
          ...completedMedications.map(
            (medication) => MedicationCardWidget(
              medication: medication,
              onTaken: () => _markAsTaken(medication["id"]),
              onEdit: () => _editMedication(medication["id"]),
              onDelete: () => _deleteMedication(medication["id"]),
              onSnooze: () => _snoozeMedication(medication["id"]),
              onLongPress: () => _showMedicationDetails(medication),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              count.toString(),
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
