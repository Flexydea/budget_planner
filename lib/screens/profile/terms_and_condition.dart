import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms & Conditions"),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "These Terms & Conditions (“Terms”) govern your use of the Budget Planner app. By downloading or using the app, you agree to these Terms.\n\n"
              "1. Use of the App\n"
              "- The app is provided for personal finance tracking only.\n"
              "- You must not use the app for unlawful purposes.\n"
              "- You agree not to copy, modify, or distribute the app without permission.\n\n"
              "2. User Accounts\n"
              "- If you create an account, you are responsible for keeping your login details secure.\n"
              "- You must provide accurate information when registering.\n"
              "- We may suspend or terminate accounts that violate these Terms.\n\n"
              "3. Data and Storage\n"
              "- Your expense and category data are stored locally on your device.\n"
              "- We are not responsible for data loss caused by device damage, loss, or uninstallation of the app.\n"
              "- Backing up your data is your responsibility.\n\n"
              "4. Notifications\n"
              "- The app may send reminders or notifications if you enable them.\n"
              "- You can disable notifications in your device settings or within the app.\n\n"
              "5. Intellectual Property\n"
              "- All logos, designs, and content within the app are owned by [Your App/Company Name].\n"
              "- You may not reproduce or distribute the app’s content without permission.\n\n"
              "6. Limitation of Liability\n"
              "- The app is provided “as is.”\n"
              "- We make no guarantees regarding accuracy, reliability, or availability.\n"
              "- We are not responsible for any financial losses, damages, or errors resulting from use of the app.\n\n"
              "7. Updates and Changes\n"
              "- We may update or improve the app at any time.\n"
              "- We may also update these Terms, and changes will be reflected within the app.\n\n"
              "8. Governing Law\n"
              "These Terms shall be governed by and interpreted under the laws of [Insert Your Country/Region].\n\n"
              "9. Contact Us\n"
              "For questions about these Terms, contact us at: [Insert Your Support Email or Website]\n",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
