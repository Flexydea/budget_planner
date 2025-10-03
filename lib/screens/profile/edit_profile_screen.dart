import 'package:flutter/material.dart';
import 'package:budget_planner/services/user_prefs.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {
  // 1. Controller for text input
  final TextEditingController _nameController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentName(); // 2. Load saved name on screen open
  }

  /// Load the current user’s saved name using UID
  Future<void> _loadCurrentName() async {
    final savedName =
        await loadUserName(); // from user_prefs.dart
    _nameController.text = savedName;
  }

  /// Save the updated name tied to UID
  Future<void> _saveName() async {
    await saveUserName(
      _nameController.text.trim(),
    ); // from user_prefs.dart

    // 3. Close screen and return 'true' so caller can refresh
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // 4. Input field for name
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter your name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              ),
            ),

            const SizedBox(height: 30),

            // 5. Save button
            SizedBox(
              width: double.infinity,
              height: kToolbarHeight,
              child: TextButton(
                onPressed: _saveName,
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primary,
                  foregroundColor: Theme.of(
                    context,
                  ).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
