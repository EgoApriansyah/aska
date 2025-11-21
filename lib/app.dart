import 'package:aska/constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'constants/app_colors.dart';
import 'routes/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ASKA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      // PASTIKAN initialRoute DISET KE initialSplash
      initialRoute: AppRoutes.facilities,
      routes: AppRouter.getAllRoutes(),
    );
  }
}