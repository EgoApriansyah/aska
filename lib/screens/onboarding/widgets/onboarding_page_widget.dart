// lib/screens/onboarding/widgets/onboarding_page_widget.dart
import 'package:aska/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_styles.dart';
import '../../../widgets/common/aska_logo_widget.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPageData data;
  final bool isLastPage;
  final bool isFirstPage;
  final VoidCallback onNextPressed;
  final VoidCallback onBackPressed;
  final VoidCallback onSkipPressed;
  final int currentPage;
  final int totalPages;

  const OnboardingPageWidget({
    Key? key,
    required this.data,
    required this.isLastPage,
    required this.isFirstPage,
    required this.onNextPressed,
    required this.onBackPressed,
    required this.onSkipPressed,
    required this.currentPage,
    required this.totalPages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Header with logo and skip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AskaLogoWidget(height: 100),
                  TextButton(
                    onPressed: onSkipPressed,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 2),

              // Main content
              Column(
                children: [
                  // Image
                  Image.asset(data.imageUrl, height: 280, fit: BoxFit.contain),
                  const SizedBox(height: 40),

                  // Title
                  Text(
                    data.title,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              const Spacer(flex: 3),

              // Page indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  totalPages,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: currentPage == index ? 24.0 : 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: currentPage == index
                          ? AppColors.primary
                          : AppColors.grey.withOpacity(0.3),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Navigation buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button (hidden on first page)
                  if (!isFirstPage)
                    TextButton(
                      onPressed: onBackPressed,
                      child: const Text(
                        'Kembali',
                        style: TextStyle(
                          color: AppColors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 80),

                  // Next/Start button
                  ElevatedButton(
                    onPressed: onNextPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      elevation: 3,
                      shadowColor: Colors.black.withOpacity(0.2),
                    ),
                    child: Text(
                      isLastPage ? 'Mulai Sekarang' : 'Selanjutnya',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
