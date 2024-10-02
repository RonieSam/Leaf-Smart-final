import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  Locale _locale = const Locale('en');
  late SharedPreferences _prefs;

  SettingsProvider() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadSettings();
  }

  void _loadSettings() {
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
    String languageCode = _prefs.getString('languageCode') ?? 'en';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  bool get isDarkMode => _isDarkMode;
  Locale get locale => _locale;

  void setDarkMode(bool value) {
    _isDarkMode = value;
    _prefs.setBool('isDarkMode', value);
    notifyListeners();
  }

  void setLocale(Locale locale) {
    _locale = locale;
    _prefs.setString('languageCode', locale.languageCode);
    notifyListeners();
  }
}