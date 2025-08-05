import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_export.dart';

// ProfileSectionWidget
class ProfileSectionWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onEditProfile;

  const ProfileSectionWidget({
    super.key,
    required this.userData,
    required this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: MediaQuery.of(context).size.height * 0.02,
      ),
      color: AppTheme.lightTheme.colorScheme.surface,
      child: Column(
        children: [
          CircleAvatar(
            radius: MediaQuery.of(context).size.width * 0.12,
            backgroundColor: AppTheme.lightTheme.colorScheme.primary.withAlpha(
              26,
            ), // Fix: Replaced withOpacity(0.1) with withAlpha(26)
            child: userData['profileImage'] != null
                ? ClipOval(
                    child: Image.network(
                      userData['profileImage']!,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * 0.24,
                      height: MediaQuery.of(context).size.width * 0.24,
                    ),
                  )
                : CustomIconWidget(
                    iconName: 'person',
                    size: MediaQuery.of(context).size.width * 0.12,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Text(
            userData['name'] ?? 'Guest User',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            userData['email'] ?? '',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface.withAlpha(153),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          OutlinedButton(
            onPressed: onEditProfile,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: AppTheme.lightTheme.colorScheme.primary,
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04,
                vertical: MediaQuery.of(context).size.height * 0.01,
              ),
            ),
            child: Text(
              'Edit Profile',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// SettingsSectionWidget
class SettingsSectionWidget extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSectionWidget({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.01,
            ),
            child: Text(
              title.toUpperCase(),
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
          Card(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

// SettingsSwitchTile
class SettingsSwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String iconName;

  const SettingsSwitchTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.iconName,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.lightTheme.colorScheme.primary,
      secondary: CustomIconWidget(
        // Changed 'leading' to 'secondary'
        iconName: iconName,
        size: 24,
        color: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }
}

// New Widget Class for language options, replacing _buildLanguageOption
class LanguageOptionTile extends StatelessWidget {
  final String language;
  final bool isSelected;
  final ValueChanged<String> onSelected;

  const LanguageOptionTile({
    super.key,
    required this.language,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: isSelected
          ? CustomIconWidget(
              iconName: 'check_circle',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.primary,
            )
          : CustomIconWidget(
              iconName: 'radio_button_unchecked',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.onSurface.withAlpha(153),
            ),
      title: Text(language, style: AppTheme.lightTheme.textTheme.titleMedium),
      onTap: () => onSelected(language),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Settings state
  bool _medicationReminders = true;
  bool _activityGoalAlerts = false;
  String _selectedLanguage = 'English'; // Default language

  // User data
  String _userName = 'Guest User';
  String _userEmail = '';
  final String? _userProfileImage = null; // null means use default icon

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'Guest User';
      _userEmail = prefs.getString('userEmail') ?? '';
    });
  }

  Future<void> _saveUserData(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    await prefs.setString('userEmail', email);
    setState(() {
      _userName = name;
      _userEmail = email;
    });
  }

  void _toggleMedicationReminders(bool value) {
    setState(() {
      _medicationReminders = value;
    });
  }

  void _toggleActivityGoalAlerts(bool value) {
    setState(() {
      _activityGoalAlerts = value;
    });
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.12,
              height: MediaQuery.of(context).size.height * 0.005,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurface.withAlpha(77),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Text(
              'Select Language',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            LanguageOptionTile(
              language: 'English',
              isSelected: _selectedLanguage == 'English',
              onSelected: (language) {
                setState(() {
                  _selectedLanguage = language;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Language changed to $language'),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            LanguageOptionTile(
              language: 'বাংলা', // Bangla
              isSelected: _selectedLanguage == 'বাংলা',
              onSelected: (language) {
                setState(() {
                  _selectedLanguage = language;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Language changed to $language'),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ],
        ),
      ),
    );
  }

  void _showRatingDialog() {
    double rating = 0;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            'Rate our app',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'How would you rate your experience with our app?',
                textAlign: TextAlign.center,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: CustomIconWidget(
                      iconName: index < rating ? 'star' : 'star_border',
                      size: 32,
                      color: index < rating
                          ? Colors.amber
                          : AppTheme.lightTheme.colorScheme.onSurface.withAlpha(
                              153,
                            ),
                    ),
                    onPressed: () {
                      setState(() {
                        rating = index + 1;
                      });
                    },
                  );
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (rating > 0) {
                  // Submit rating
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Thank you for your ${rating.toInt()}-star rating!',
                      ),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _shareApp() {
    // Show a mock sharing sheet
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Sharing functionality would open native sharing options',
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openPrivacyPolicy() {
    // Navigate to privacy policy page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Privacy Policy would open in a new screen'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _checkForUpdates() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Check for Updates'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            const Text('Checking for updates...'),
          ],
        ),
      ),
    );

    // Simulate checking for updates
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pop(context); // Close the progress dialog
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('App is up to date'),
          content: const Text('You are using the latest version of the app.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  void _signOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text(
          'Are you sure you want to sign out of your account?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Perform sign out logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('You have been signed out'),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              foregroundColor: AppTheme.lightTheme.colorScheme.onError,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to permanently delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmDeleteAccount();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              foregroundColor: AppTheme.lightTheme.colorScheme.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount() {
    final TextEditingController deleteConfirmationController =
        TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Final Confirmation'),
        content: TextField(
          controller: deleteConfirmationController,
          decoration: const InputDecoration(
            hintText: 'Type "DELETE" to confirm',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (deleteConfirmationController.text == 'DELETE') {
                Navigator.pop(context);
                // Perform account deletion logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account deletion process initiated'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please type "DELETE" to confirm.'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              foregroundColor: AppTheme.lightTheme.colorScheme.onError,
            ),
            child: const Text('Permanently Delete'),
          ),
        ],
      ),
    ).then((_) {
      deleteConfirmationController
          .dispose(); // Dispose controller after dialog closes
    });
  }

  void _editProfile() async {
    final updatedData = await Navigator.pushNamed(
      context,
      AppRoutes.editProfileScreen,
      arguments: {'name': _userName, 'email': _userEmail},
    );
    if (updatedData != null && updatedData is Map<String, dynamic>) {
      _saveUserData(updatedData['name'], updatedData['email']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            ProfileSectionWidget(
              userData: {
                'name': _userName,
                'email': _userEmail,
                'profileImage': _userProfileImage,
              },
              onEditProfile: _editProfile,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            // Notifications Section
            SettingsSectionWidget(
              title: 'Notifications',
              children: [
                SettingsSwitchTile(
                  title: 'Medication Reminders',
                  subtitle: 'Receive alerts for medication schedules',
                  value: _medicationReminders,
                  onChanged: _toggleMedicationReminders,
                  iconName: 'notifications',
                ),
                SettingsSwitchTile(
                  title: 'Activity Goal Alerts',
                  subtitle:
                      'Get notified when you haven\'t met your step goals',
                  value: _activityGoalAlerts,
                  onChanged: _toggleActivityGoalAlerts,
                  iconName: 'directions_run',
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            // General Section
            SettingsSectionWidget(
              title: 'General',
              children: [
                ListTile(
                  leading: CustomIconWidget(
                    iconName: 'language',
                    size: 24,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  title: const Text('Language'),
                  subtitle: const Text('Select your preferred language'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedLanguage,
                        style: TextStyle(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withAlpha(153),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                      CustomIconWidget(
                        iconName: 'arrow_forward_ios',
                        size: 16,
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withAlpha(102),
                      ),
                    ],
                  ),
                  onTap: _showLanguageSelector,
                ),
                ListTile(
                  leading: CustomIconWidget(
                    iconName: 'star',
                    size: 24,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  title: const Text('Rate us'),
                  subtitle: const Text('Share your feedback'),
                  trailing: CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    size: 16,
                    color: AppTheme.lightTheme.colorScheme.onSurface.withAlpha(
                      102,
                    ),
                  ),
                  onTap: _showRatingDialog,
                ),
                ListTile(
                  leading: CustomIconWidget(
                    iconName: 'share',
                    size: 24,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  title: const Text('Share to'),
                  subtitle: const Text('Tell others about this app'),
                  trailing: CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    size: 16,
                    color: AppTheme.lightTheme.colorScheme.onSurface.withAlpha(
                      102,
                    ),
                  ),
                  onTap: _shareApp,
                ),
                ListTile(
                  leading: CustomIconWidget(
                    iconName: 'privacy_tip',
                    size: 24,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  title: const Text('Privacy Policy'),
                  subtitle: const Text('View our privacy policy'),
                  trailing: CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    size: 16,
                    color: AppTheme.lightTheme.colorScheme.onSurface.withAlpha(
                      102,
                    ),
                  ),
                  onTap: _openPrivacyPolicy,
                ),
                ListTile(
                  leading: CustomIconWidget(
                    iconName: 'system_update',
                    size: 24,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  title: const Text('Check Update'),
                  subtitle: const Text('Check for app updates'),
                  trailing: CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    size: 16,
                    color: AppTheme.lightTheme.colorScheme.onSurface.withAlpha(
                      102,
                    ),
                  ),
                  onTap: _checkForUpdates,
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            // Account Section
            SettingsSectionWidget(
              title: 'Account',
              children: [
                ListTile(
                  leading: CustomIconWidget(
                    iconName: 'logout',
                    size: 24,
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                  title: Text(
                    'Sign Out',
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
                  ),
                  onTap: _signOut,
                ),
                ListTile(
                  leading: CustomIconWidget(
                    iconName: 'delete',
                    size: 24,
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                  title: Text(
                    'Delete Account',
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
                  ),
                  onTap: _deleteAccount,
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ), // Bottom padding
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings App',
      theme: AppTheme.lightTheme,
      home: const SettingsScreen(),
    );
  }
}
