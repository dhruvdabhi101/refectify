import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkTheme = true;

  bool get isDarkTheme => _isDarkTheme;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }
  void setTheme(bool isDarkTheme) {
    _isDarkTheme = isDarkTheme;
    notifyListeners();
  }
}
