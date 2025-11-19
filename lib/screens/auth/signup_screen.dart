import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';
import '../../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController ibuController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PENDAFTARAN PENGGUNA',
          style: TextStyle(color: AppColors.textDark),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Email
            TextField(
              controller: emailController,
              decoration: AppStyles.inputDecoration.copyWith(
                labelText: 'Alamat Email',
                prefixIcon: const Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 15),

            // NIK
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
              controller: ibuController,
              decoration: AppStyles.inputDecoration.copyWith(
                labelText: 'Nama Ibu Kandung',
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 15),

            // Password
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: AppStyles.inputDecoration.copyWith(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 15),

            // Confirm Password
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: AppStyles.inputDecoration.copyWith(
                labelText: 'Konfirmasi Password',
                prefixIcon: const Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 30),

            // Register button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if (passwordController.text !=
                      confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Password tidak cocok")),
                    );
                    return;
                  }

                  final result = await _authService.signUp(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );

                  if (result != null) {
                    Navigator.pop(context); // Kembali ke login
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Gagal membuat akun")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Daftar Sekarang',
                  style: AppStyles.primaryButtonText,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
