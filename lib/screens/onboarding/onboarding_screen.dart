import 'package:flutter/material.dart';
import 'widgets/onboarding_page_widget.dart';
import '../../constants/app_colors.dart';
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
      body: Stack(
        children: [
          PageView.builder(
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
                onNextPressed: () {
                  if (_currentPage < _pages.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    // *** PERUBAHAN KUNCI: Navigasi ke Login setelah onboarding selesai ***
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  }
                },
                onSkipPressed: () {
                  // Opsional: "Kembali" bisa juga langsung ke login
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
              );
            },
          ),
          // Page Indicator
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _pages.asMap().entries.map((entry) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _currentPage == entry.key ? 24.0 : 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: _currentPage == entry.key
                        ? AppColors.primary
                        : AppColors.grey.withOpacity(0.5),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ... (class OnboardingPageData tetap sama)
class OnboardingPageData {
  final String imageUrl;
  final String title;

  OnboardingPageData({
    required this.imageUrl,
    required this.title,
  });
}