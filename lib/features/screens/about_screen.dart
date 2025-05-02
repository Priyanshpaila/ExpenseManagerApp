import 'package:flutter/material.dart';
import 'package:my_app_one/widgets/footer_widget.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About '),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primaryContainer,
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          /// 📱 App Icon & Name
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  child: Image(
                    image: AssetImage('assets/images/logo.png'),
                    height: 80,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Expense Manager',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Track. Analyze. Save.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          /// 🔍 Summary
          _sectionTitle('What does this app do?', theme),
          const SizedBox(height: 8),
          _sectionBody(
            "Expense Manager is your personal finance companion, helping you "
            "track daily spending, visualize your expenses, and set budgets effortlessly.",
            theme,
          ),

          const SizedBox(height: 24),

          /// 🛠 Features
          _sectionTitle('Key Features', theme),
          const SizedBox(height: 8),
          _bulletPoint("📊 Beautiful charts for category and daily spending"),
          _bulletPoint("💰 Budget setting and real-time status tracking"),
          _bulletPoint("🧾 Add, delete, and categorize expenses instantly"),
          _bulletPoint("🎨 Personalize themes and color styles"),
          _bulletPoint("🧑 Customizable user profile and greeting"),
          _bulletPoint("📤 Export expense reports as professional PDF"),

          const SizedBox(height: 24),

          /// 🤝 Credits
          _sectionTitle('Built With ❤️', theme),
          const SizedBox(height: 8),
          _sectionBody(
            "Crafted using Flutter, Riverpod, and a clean Material Design. "
            "Developed by Priyansh to empower better financial habits.",
            theme,
          ),

          const SizedBox(height: 30.0),

          const FooterWidget(),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _sectionBody(String text, ThemeData theme) {
    return Text(text, style: theme.textTheme.bodyMedium);
  }

  Widget _bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 18, color: Colors.teal),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
