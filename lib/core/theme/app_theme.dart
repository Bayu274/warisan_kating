import 'package:flutter/material.dart';

/// App-wide theme data.
class AppTheme {
  AppTheme._();

  static const Color _primaryColor = Color(0xFF4E7D56); // earthy green
  static const Color _accentColor = Color(0xFFF2A65A);  // warm amber

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: _primaryColor,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: _primaryColor,
          unselectedItemColor: Colors.grey[600],
          type: BottomNavigationBarType.fixed,
        ),
      );
}
