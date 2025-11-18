import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../widgets/common/aska_logo_widget.dart';
import '../onboarding_screen.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPageData data;
  final bool isLastPage;
  final VoidCallback onNextPressed;
  final VoidCallback onSkipPressed;

  const OnboardingPageWidget({
    Key? key,
    required this.data,
    required this.isLastPage,
    required this.onNextPressed,
    required this.onSkipPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo Baru di pojok kiri atas
          Align(
            alignment: Alignment.topLeft,
            // --- PERUBAHAN DI SINI ---
            // Tinggi logo dikurangi dari 30 menjadi 25 agar lebih kecil di pojok
            child: const AskaLogoWidget(height: 65),
          ),
          const Spacer(),
          // Gambar Utama
          Image.asset(data.imageUrl, height: 300),
          const SizedBox(height: 40),
          // Judul
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          // Tombol Navigasi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: onSkipPressed,
                child: const Text('Kembali', style: TextStyle(color: AppColors.grey)),
              ),
              ElevatedButton(
                onPressed: onNextPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(isLastPage ? 'Mulai Sekarang' : 'Selanjutnya'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}