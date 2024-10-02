import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'SettingsProvider.dart';
import 'about.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        final l10n = AppLocalizations.of(context)!;
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.settingsTitle),
            backgroundColor: Colors.green,
            elevation: 0,
          ),
          body: ListView(
            children: [
              const SizedBox(height: 20),
              _buildSection(
                title: l10n.preferences,
                children: [
                  _buildSwitchTile(
                    title: l10n.darkMode,
                    subtitle: l10n.darkModeSubtitle,
                    value: settings.isDarkMode,
                    onChanged: (value) {
                      settings.setDarkMode(value);
                    },
                  ),
                  _buildLanguageSelector(context, settings),
                ],
              ),
              _buildSection(
                title: l10n.appInformation,
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: Colors.green),
                    title: Text(l10n.aboutLeafSmart),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AboutScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.update, color: Colors.green),
                    title: Text(l10n.version),
                    subtitle: const Text('1.0.0'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageSelector(BuildContext context, SettingsProvider settings) {
    return ListTile(
      leading: const Icon(Icons.language, color: Colors.green),
      title: const Text('Language'),
      trailing: DropdownButton<String>(
        value: settings.locale.languageCode,
        onChanged: (String? newValue) {
          if (newValue != null) {
            settings.setLocale(Locale(newValue));
          }
        },
        items: const [
          DropdownMenuItem(
            value: 'en',
            child: Text('English'),
          ),
          DropdownMenuItem(
            value: 'hi',
            child: Text('हिंदी'),
          ),
          DropdownMenuItem(
            value: 'ta',
            child: Text('தமிழ்'),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.green,
    );
  }
}