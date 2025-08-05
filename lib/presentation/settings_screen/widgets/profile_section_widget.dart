import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

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
      padding: EdgeInsets.all(4.w),
      color: AppTheme.lightTheme.colorScheme.surface,
      child: Column(
        children: [
          Row(
            children: [
              _buildProfileImage(),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData['name'],
                      style: AppTheme.lightTheme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      userData['email'],
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withAlpha(179),
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: onEditProfile,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  side: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Edit Profile'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    if (userData['profileImage'] != null) {
      return CircleAvatar(
        radius: 8.w,
        backgroundImage: NetworkImage(userData['profileImage']),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary.withAlpha(26),
      );
    } else {
      return Stack(
        children: [
          CircleAvatar(
            radius: 8.w,
            backgroundColor: AppTheme.lightTheme.colorScheme.primary.withAlpha(
              26,
            ),
            child: CustomIconWidget(
              iconName: 'person',
              size: 8.w,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(1.w),
              child: CustomIconWidget(
                iconName: 'camera_alt',
                size: 3.w,
                color: AppTheme.lightTheme.colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      );
    }
  }
}
