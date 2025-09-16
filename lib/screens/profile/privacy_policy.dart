import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Privacy Policy")),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your privacy matters to us. This Privacy Policy explains how our Budget Planner app collects, uses, and protects your information.\n\n"
              "1. Information We Collect\n"
              "- Personal Information: When you create an account, we may collect your name, email address, and password.\n"
              "- App Usage Data: We may collect information on how you use the app, such as categories created, expenses added, and reminders set.\n"
              "- Device Information: Basic details like device type, operating system, and app version may be logged to improve performance.\n\n"
              "2. How We Use Your Information\n"
              "We use your data to:\n"
              "- Provide and improve app features\n"
              "- Personalize your experience\n"
              "- Store and manage your expenses locally\n"
              "- Send notifications or reminders (if enabled by you)\n\n"
              "3. Data Storage\n"
              "- All financial data you input (like expenses and categories) is stored locally on your device using secure storage technology.\n"
              "- We do not sell or share your personal data with third parties.\n\n"
              "4. Security\n"
              "We take reasonable measures to protect your data. However, no method of storage is 100% secure. You are responsible for keeping your login details safe.\n\n"
              "5. Your Choices\n"
              "- You can edit or delete your data anytime in the app.\n"
              "- You can disable notifications in your settings.\n"
              "- You can uninstall the app if you no longer wish to use it.\n\n"
              "6. Updates to This Policy\n"
              "We may update this Privacy Policy to reflect changes in the app. Any updates will be available within the app.\n\n"
              "7. Contact Us\n"
              "If you have questions or concerns about this Privacy Policy, please contact us at: [Insert Your Support Email or Website]\n",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
