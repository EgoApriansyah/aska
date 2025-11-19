import 'package:aska/screens/news/news_screen.dart';
import 'package:flutter/material.dart';
import '../constants/app_routes.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/splash/initial_splash_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/faq_screen.dart';
import '../screens/profile/profile_screen.dart';

class AppRouter {
  static Map<String, WidgetBuilder> getAllRoutes() {
    return {
      AppRoutes.initialSplash: (context) =>
          const InitialSplashScreen(), // Tambahkan ini
      AppRoutes.onboarding: (context) => const OnboardingScreen(),
      AppRoutes.login: (context) => const LoginScreen(),
      AppRoutes.signup: (context) => const SignUpScreen(),
      AppRoutes.home: (context) => const HomeScreen(),
      AppRoutes.faq: (context) => const FAQScreen(),
      AppRoutes.profile: (context) => const ProfileScreen(),
      AppRoutes.news: (context) => const NewsScreen(),
      // AppRoutes.newsDetail: (context) => const NewsDetailScreen(),
    };
  }
}
