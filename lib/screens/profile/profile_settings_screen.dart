import 'package:budget_planner/providers/auth_provider.dart'
    as custom_auth;
import 'package:budget_planner/screens/auth/widgets/close_account_dialog.dart';
import 'package:budget_planner/services/user_prefs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:budget_planner/providers/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() =>
      _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState
    extends State<ProfileSettingsScreen> {
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  Future<void> _loadName() async {
    final savedName = await loadUserName();
    if (mounted) {
      setState(() {
        _userName = savedName;
      });
    }
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return "U";
    final parts = name.trim().split(" ");
    return parts.length == 1
        ? parts[0][0].toUpperCase()
        : (parts[0][0] + parts[1][0]).toUpperCase();
  }

  bool _faceIdEnabled = false;
  bool _balanceEnabled = false;
  bool _notificationEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).colorScheme.background,
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
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userName ?? "User",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          FirebaseAuth
                                  .instance
                                  .currentUser
                                  ?.email ??
                              'No email',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
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
                      child: Text(
                        _getInitials(_userName),
                        style: const TextStyle(
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
                          color: Theme.of(
                            context,
                          ).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 8,
                          color: Theme.of(
                            context,
                          ).colorScheme.surface,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 40),

            /// Account Section
            _buildSectionTitle('Account'),
            _buildGroupedAccount(
              icon1: Icons.edit_outlined,
              title1: 'Edit Profile',
              onTap1: () async {
                final updated = await context.push(
                  '/settings/edit-profile',
                );
                if (updated == true) {
                  await _loadName(); // refresh
                }
              },
              icon2: Icons.lock_outline,
              title2: 'Change password',
              onTap2: () =>
                  context.push('/settings/change-password'),
            ),

            /// Security Section
            const SizedBox(height: 20),
            _buildSectionTitle('Security'),
            _buildGroupedTileCardSecurity(
              icon2: Icons.face_outlined,
              title2: 'Face ID',
              faceIdEnabled: _faceIdEnabled,
              onFaceIdToggle: (value) =>
                  setState(() => _faceIdEnabled = value),
              icon3: Icons.lock_outline,
              title3: 'Hide balance',
              balanceEnabled: _balanceEnabled,
              onBalanceToggle: (value) =>
                  setState(() => _balanceEnabled = value),
            ),

            /// Preferences
            const SizedBox(height: 20),
            _buildSectionTitle('Preferences'),
            Consumer<ThemeProvider>(
              builder: (context, themeProv, _) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 6,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.dark_mode),
                    title: const Text('Dark Mode'),
                    trailing: Switch(
                      value: themeProv.isDarkMode,
                      onChanged: (val) => context
                          .read<ThemeProvider>()
                          .toggleTheme(val),
                    ),
                  ),
                );
              },
            ),
            _buildGroupedTileCardPreference(
              icon1: Icons.monetization_on_outlined,
              title1: 'Currency',
              onTap1: () =>
                  context.push('/settings/currency'),
              icon2: Icons.notifications_active_outlined,
              title2: 'Notification',
              notificationEnabled: _notificationEnabled,
              onNotificationToggle: (value) => setState(
                () => _notificationEnabled = value,
              ),
            ),

            const SizedBox(height: 20),

            /// Legal
            _buildSectionTitle('Legal'),
            _buildGroupedLegal(
              icon1: Icons.shield_outlined,
              title1: 'Privacy policy',
              onTap1: () =>
                  context.push('/settings/privacy'),
              icon2: Icons.description_outlined,
              title2: 'Terms & condition',
              onTap2: () => context.push('/settings/terms'),
            ),

            const SizedBox(height: 20),

            /// Close Account & Logout
            _buildGroupedCloseLogout(
              icon1: Icons.delete_forever,
              title1: 'Close account',
              onTap1: () => showDialog(
                context: context,
                builder: (ctx) =>
                    const CloseAccountDialog(),
              ),
              icon2: Icons.logout,
              title2: 'Logout',
              onTap2: () async {
                await context
                    .read<custom_auth.AuthProvider>()
                    .signOut();
                if (mounted) context.go('/login');
              },
            ),

            const SizedBox(height: 30),
            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text('App Version - 1.0'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widgets...
  Widget _buildSectionTitle(String title) => Text(
    title,
    style: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Colors.grey,
    ),
  );

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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon1),
            title: Text(title1),
            onTap: onTap1,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon2),
            title: Text(title2),
            onTap: onTap2,
          ),
        ],
      ),
    );
  }

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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon2),
            title: Text(title2),
            trailing: Switch(
              value: faceIdEnabled,
              onChanged: onFaceIdToggle,
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon3),
            title: Text(title3),
            trailing: Switch(
              value: balanceEnabled,
              onChanged: onBalanceToggle,
            ),
          ),
        ],
      ),
    );
  }

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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon1),
            title: Text(title1),
            onTap: onTap1,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon2),
            title: Text(title2),
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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon1),
            title: Text(title1),
            onTap: onTap1,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon2),
            title: Text(title2),
            onTap: onTap2,
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedCloseLogout({
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
        color: Theme.of(context).colorScheme.surface,
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
            leading: Icon(icon2),
            title: Text(title2),
            onTap: onTap2,
          ),
        ],
      ),
    );
  }
}
