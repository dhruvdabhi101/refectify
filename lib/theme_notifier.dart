/// This class is responsible for managing the theme of the app.
/// It extends [ChangeNotifier] to notify the listeners when the theme is changed.
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkTheme = true;

  /// Returns whether the current theme is dark or not.
  bool get isDarkTheme => _isDarkTheme;

  /// Toggles the theme between dark and light and notifies the listeners.
  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  /// Sets the theme to the given value and notifies the listeners.
  ///
  /// [isDarkTheme] - The value to set the theme to.
  void setTheme(bool isDarkTheme) {
    _isDarkTheme = isDarkTheme;
    notifyListeners();
  }
}
