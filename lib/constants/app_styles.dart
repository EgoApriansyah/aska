import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyles {
  // Gaya untuk Judul Besar (Splash Screen)
  static const TextStyle splashTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  // Gaya untuk Deskripsi (Splash Screen)
  static const TextStyle splashDescription = TextStyle(
    fontSize: 16,
    color: AppColors.textLight,
    height: 1.5,
  );

  // Gaya untuk Tombol Utama
  static const TextStyle primaryButtonText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  // Gaya untuk Input Field
  static const InputDecoration inputDecoration = InputDecoration(
    filled: true,
    fillColor: AppColors.surfaceColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide.none,
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    hintStyle: TextStyle(color: AppColors.textLight),
  );

  // Gaya untuk Link (Lupa Password, Daftar)
  static const TextStyle linkText = TextStyle(
    color: AppColors.primary,
    fontWeight: FontWeight.bold,
  );
}