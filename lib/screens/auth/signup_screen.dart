import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PENDAFTARAN PENGGUNA', style: TextStyle(color: AppColors.textDark)),
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textDark),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Form Fields
            TextField(
              decoration: AppStyles.inputDecoration.copyWith(
                labelText: 'No. Kartu BPJS Kesehatan',
                prefixIcon: const Icon(Icons.credit_card),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: AppStyles.inputDecoration.copyWith(
                labelText: 'No. KTP/ NIK',
                prefixIcon: const Icon(Icons.badge),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: AppStyles.inputDecoration.copyWith(
                labelText: 'Nama Ibu Kandung',
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              obscureText: true,
              decoration: AppStyles.inputDecoration.copyWith(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              obscureText: true,
              decoration: AppStyles.inputDecoration.copyWith(
                labelText: 'Konfirmasi Password',
                prefixIcon: const Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 30),
            // Register Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Logika pendaftaran
                  Navigator.pop(context); // Kembali ke halaman login
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: const Text('Daftar Sekarang', style: AppStyles.primaryButtonText),
              ),
            ),
            const SizedBox(height: 30),
            // Divider
            const Row(children: <Widget>[
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text("ATAU"),
              ),
              Expanded(child: Divider()),
            ]),
            const SizedBox(height: 20),
            // Social Login Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Image.asset('assets/images/facebook_logo.png', width: 40),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Image.asset('assets/images/google_logo.png', width: 40),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}