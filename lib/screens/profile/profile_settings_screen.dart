import 'package:budget_planner/screens/profile/change_password_screen.dart';
import 'package:budget_planner/screens/profile/currency_selector_screen.dart';
import 'package:budget_planner/screens/profile/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() =>
      _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState
    extends State<ProfileSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 8),
                    const Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Godwin Igbokwe',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Flexy_dea@yahoo.com',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.black,
                      child: const Text(
                        'GI',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 8,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            //search bar
            const SizedBox(height: 40),

            /// Account Section
            _buildSectionTitle('Account'),
            _buildGroupedAccount(
              icon1: Icons.edit_outlined,
              title1: 'Edit Profile',
              onTap1: () {
                context.push('/settings/edit-profile');
              },
              icon2: Icons.lock_outline,
              title2: 'Change password',
              onTap2: () {
                context.push('/settings/change-password');
              },
            ),

            /// Security Section
            const SizedBox(height: 20),
            _buildSectionTitle('Security'),
            _buildGroupedTileCardSecurity(
              icon2: Icons.face_outlined, // Face ID icon
              title2: 'Face ID',
              faceIdEnabled: _faceIdEnabled,
              onFaceIdToggle: (value) {
                setState(() {
                  _faceIdEnabled = value;
                });
              },
              icon3: Icons.lock_outline,
              title3: 'Hide balance',
              balanceEnabled: _balanceEnabled,
              onBalanceToggle: (value) {
                setState(() {
                  _balanceEnabled = value;
                });
              },
            ),

            /// Preferences
            const SizedBox(height: 20),
            _buildSectionTitle('Preferences'),
            _buildGroupedTileCardPreference(
              icon1: Icons.monetization_on_outlined,
              title1: 'Currency',
              onTap1: () {
                context.push('/settings/currency');
              },
              icon2: Icons
                  .notifications_active_outlined, // Face ID icon
              title2: 'Notification',
              notificationEnabled: _notificationEnabled,
              onNotificationToggle: (value) {
                setState(() {
                  _notificationEnabled = value;
                });
              },
            ),

            /// Legal
            const SizedBox(height: 20),
            _buildSectionTitle('Legal'),
            _buildGroupedLegal(
              icon1: Icons.delete_forever,
              title1: 'Close account',
              onTap1: () {
                // Handle Edit Profile
              },
              icon2: Icons.logout,
              title2: 'Logout',
              onTap2: () {
                // Handle Change Password
              },
            ),

            /// Danger Zone
            const SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('App Version - 1.0'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildGroupedAccount({
    required IconData icon1,
    required String title1,
    required VoidCallback onTap1,
    required IconData icon2,
    required String title2,
    required VoidCallback onTap2,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon1, color: Colors.black),
            title: Text(title1, style: const TextStyle()),

            onTap: onTap1,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon2, color: Colors.black),
            title: Text(title2, style: const TextStyle()),

            onTap: onTap2,
          ),
        ],
      ),
    );
  }

  bool _faceIdEnabled = false;
  bool _balanceEnabled = false;
  Widget _buildGroupedTileCardSecurity({
    required IconData icon2,
    required String title2,
    required bool faceIdEnabled,
    required bool balanceEnabled,
    required ValueChanged<bool> onFaceIdToggle,
    required ValueChanged<bool> onBalanceToggle,
    required IconData icon3,
    required String title3,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon2, color: Colors.black),
            title: Text(title2, style: const TextStyle()),
            trailing: Switch(
              value: faceIdEnabled,
              onChanged: onFaceIdToggle,
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon3, color: Colors.black),
            title: Text(title3, style: const TextStyle()),
            trailing: Switch(
              value: balanceEnabled,
              onChanged: onBalanceToggle,
            ),
          ),
        ],
      ),
    );
  }

  bool _notificationEnabled = false;
  Widget _buildGroupedTileCardPreference({
    required IconData icon1,
    required String title1,
    required VoidCallback onTap1,
    required IconData icon2,
    required String title2,
    required bool notificationEnabled,
    required ValueChanged<bool> onNotificationToggle,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon1, color: Colors.black),
            title: Text(title1, style: const TextStyle()),

            onTap: onTap1,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon2, color: Colors.black),
            title: Text(title2, style: const TextStyle()),
            trailing: Switch(
              value: notificationEnabled,
              onChanged: onNotificationToggle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedLegal({
    required IconData icon1,
    required String title1,
    required VoidCallback onTap1,
    required IconData icon2,
    required String title2,
    required VoidCallback onTap2,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon1, color: Colors.red),
            title: Text(
              title1,
              style: const TextStyle(color: Colors.red),
            ),

            onTap: onTap1,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon2, color: Colors.black),
            title: Text(title2, style: const TextStyle()),

            onTap: onTap2,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleTile({
    required String title,
    required bool value,
  }) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      value: value,
      onChanged: (val) {},
    );
  }
}
