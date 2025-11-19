// lib/screens/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'widgets/onboarding_page_widget.dart';
import '../../constants/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      imageUrl: 'assets/images/onboarding_1_watch.png',
      title: 'Pantau Kesehatanmu Setiap Saat',
    ),
    OnboardingPageData(
      imageUrl: 'assets/images/onboarding_2_map.png',
      title: 'Dapatkan Rekomendasi Faskes Terdekat Secara Otomatis.',
    ),
    OnboardingPageData(
      imageUrl: 'assets/images/onboarding_3_phone.png',
      title: 'Terhubung dengan Sistem BPJS untuk Penanganan Cepat & Tepat',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: _pages.length,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        itemBuilder: (context, index) {
          return OnboardingPageWidget(
            data: _pages[index],
            isLastPage: index == _pages.length - 1,
            isFirstPage: index == 0,
            currentPage: index,
            totalPages: _pages.length,
            onNextPressed: () {
              if (_currentPage < _pages.length - 1) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              }
            },
            onBackPressed: () {
              if (_currentPage > 0) {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            onSkipPressed: () {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          );
        },
      ),
    );
  }
}

class OnboardingPageData {
  final String imageUrl;
  final String title;

  OnboardingPageData({required this.imageUrl, required this.title});
}
