import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';
import '../../constants/app_routes.dart';
import '../../widgets/common/aska_logo_widget.dart';

class InitialSplashScreen extends StatefulWidget {
  const InitialSplashScreen({Key? key}) : super(key: key);

  @override
  State<InitialSplashScreen> createState() => _InitialSplashScreenState();
}

class _InitialSplashScreenState extends State<InitialSplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _imageController;
  late final Animation<double> _imageScale;

  late final AnimationController _logoController;
  late final Animation<double> _logoOpacity;

  @override
  void initState() {
    super.initState();

    _imageController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _imageScale = Tween<double>(begin: 1.1, end: 1.0).animate(
      CurvedAnimation(
        parent: _imageController,
        curve: Curves.easeOut,
      ),
    );

    _logoController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeIn,
      ),
    );

    _imageController.forward();
    _logoController.forward();
  }

  @override
  void dispose() {
    _imageController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: SafeArea(
        child: LayoutBuilder(
          // --- PERUBAHAN UTAMA: Menggunakan LayoutBuilder ---
          builder: (context, constraints) {
            // Hitung tinggi gambar, misalnya 45% dari tinggi layar yang tersedia
            final double imageHeight = constraints.maxHeight * 0.45;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Lebarkan anak-anak Column
              children: [

                AnimatedBuilder(
                  animation: _imageController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _imageScale.value,
                      child: child,
                    );
                  },
                  child: SizedBox(
                    height: imageHeight * 1.6,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // --- Gambar Utama ---
                        Image.asset(
                          'assets/images/splash_family.png',
                          fit: BoxFit.cover, // gambar tetap full dari atas ke tengah
                        ),

                        // --- Logo ASKA di atas gambar ---
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: FadeTransition(
                                opacity: _logoOpacity,
                                child: const AskaLogoWidget(height: 65),
                              ),
                            ),
                          ),
                        ),

                        // --- Gradasi di bagian bawah gambar ---
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: imageHeight * 0.55, // gradasi 50–55% bagian bawah
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  AppColors.splashBackground.withOpacity(0.7),
                                  AppColors.splashBackground,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),



                const SizedBox(height: 20),

                // 2. Gambar Keluarga di tengah dengan tinggi dinamis
                
                // Spacer akan mengisi sisa ruang kosong dan mendorong widget di bawahnya
                const Spacer(),

                // 3. Bagian Teks dan Tombol di bawah
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                  child: Column(
                    children: [
                      // Teks Judul
                      Text(
                        'Selamat Datang di ASKA',
                        style: AppStyles.splashTitle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      // Teks Deskripsi
                      Text(
                        'Platform Digital Terpadu untuk Mewujudkan Kesehatan Cerdas dan Terhubung',
                        style: AppStyles.splashDescription,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      // Tombol "Mulai Sekarang"
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Mulai Sekarang',
                            style: AppStyles.primaryButtonText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}