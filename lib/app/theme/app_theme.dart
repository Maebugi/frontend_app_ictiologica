import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: false,

    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.loginBlue,
    fontFamily: 'Roboto',

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      foregroundColor: AppColors.textPrimary,
    ),

    // 🔥 CORREGIDO: ya no fuerza color azul en inputs
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.transparent, // 👈 CLAVE (antes era azul)
      hintStyle: const TextStyle(color: Colors.black45),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
    ),

    // 🔥 elimina selección azul
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: Colors.transparent,
      selectionHandleColor: Colors.transparent,
      cursorColor: Colors.black54,
    ),
  );
}