// lib/screens/auth/signup_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';
import '../../constants/app_routes.dart';
import '../../services/auth_service.dart';
import '../../widgets/common/aska_logo_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController bpjsController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController motherNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final AuthService _authService = AuthService();

  bool isLoading = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 100),

            // Logo ASKA di tengah
            Image.asset(
              'assets/images/aska2.png',
              height: 100, // Tinggi default
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 30),

            // No. Kartu BPJS Kesehatan
            TextField(
              controller: bpjsController,
              decoration: AppStyles.inputDecoration.copyWith(
                labelText: 'No. Kartu BPJS Kesehatan',
                prefixIcon: const Icon(Icons.credit_card),
              ),
            ),

            const SizedBox(height: 15),

            // No. KTP/ NIK
            TextField(
              controller: nikController,
              decoration: AppStyles.inputDecoration.copyWith(
                labelText: 'No. KTP/ NIK',
                prefixIcon: const Icon(Icons.badge),
              ),
            ),

            const SizedBox(height: 15),

            // Nama Ibu Kandung
            TextField(
              controller: motherNameController,
              decoration: AppStyles.inputDecoration.copyWith(
                labelText: 'Nama Ibu Kandung',
                prefixIcon: const Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 15),

            // Password
            TextField(
              controller: passwordController,
              obscureText: !isPasswordVisible,
              decoration: AppStyles.inputDecoration.copyWith(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Konfirmasi Password
            TextField(
              controller: confirmPasswordController,
              obscureText: !isConfirmPasswordVisible,
              decoration: AppStyles.inputDecoration.copyWith(
                labelText: 'Konfirmasi Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    isConfirmPasswordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      isConfirmPasswordVisible = !isConfirmPasswordVisible;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            // DAFTAR SEKARANG Button dengan shadow
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (passwordController.text !=
                            confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Password dan konfirmasi password tidak cocok",
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        setState(() => isLoading = true);

                        // TODO: Implementasi Firebase registration
                        // final result = await _authService.register(
                        //   email: emailController.text.trim(),
                        //   password: passwordController.text.trim(),
                        //   bpjsNumber: bpjsController.text.trim(),
                        //   nik: nikController.text.trim(),
                        //   motherName: motherNameController.text.trim(),
                        // );

                        setState(() => isLoading = false);

                        // Simulasi delay
                        await Future.delayed(const Duration(seconds: 2));

                        // Navigasi ke login setelah registrasi
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.login,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.3),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Daftar Sekarang',
                        style: AppStyles.primaryButtonText,
                      ),
              ),
            ),

            const SizedBox(height: 30),

            // Divider
            const Row(
              children: <Widget>[
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text("ATAU"),
                ),
                Expanded(child: Divider()),
              ],
            ),

            const SizedBox(height: 20),

            // Social Login Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Facebook Button
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Image.asset(
                      'assets/images/facebook_logo.png',
                      width: 24,
                    ),
                    label: const Text('Facebook'),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1877F2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                // Google Button
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Image.asset(
                      'assets/images/google_logo.png',
                      width: 24,
                    ),
                    label: const Text('Google'),
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.lightGrey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Sudah Memiliki Akun? Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Sudah Memiliki Akun?'),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  },
                  child: const Text(
                    'MASUK',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
