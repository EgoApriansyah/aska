import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';
import '../../constants/app_routes.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool isLoading = false;
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MASUK', style: TextStyle(color: AppColors.textDark)),
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Email Input
            TextField(
              controller: emailController,
              decoration: AppStyles.inputDecoration.copyWith(
                hintText: 'Alamat Email',
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),

            const SizedBox(height: 15),

            // Password Input
            TextField(
              controller: passwordController,
              obscureText: !isPasswordVisible,
              decoration: AppStyles.inputDecoration.copyWith(
                hintText: 'Password',
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

            const SizedBox(height: 10),

            // Forgot Password (opsional)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text('Lupa Password?', style: AppStyles.linkText),
              ),
            ),

            const SizedBox(height: 20),

            // GOOGLE BUTTON (belum aktif)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                icon: Image.asset('assets/images/google_logo.png', width: 20),
                label: const Text('Masuk dengan Google'),
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.lightGrey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // FACEBOOK BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: Image.asset('assets/images/facebook_logo.png', width: 20),
                label: const Text('Masuk dengan Facebook'),
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1877F2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Divider
            Row(children: <Widget>[
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  "ATAU",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              const Expanded(child: Divider()),
            ]),

            const SizedBox(height: 30),

            // LOGIN BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() => isLoading = true);

                        final result = await _authService.login(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );

                        setState(() => isLoading = false);

                        if (result != null) {
                          // SUCCESS
                          Navigator.pushReplacementNamed(
                              context, AppRoutes.home);
                        } else {
                          // FAILED
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Email atau password salah")),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Masuk', style: AppStyles.primaryButtonText),
              ),
            ),

            const SizedBox(height: 30),

            // SIGN UP LINK
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Belum Memiliki Akun?'),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.signup);
                  },
                  child: const Text('Daftar/ Aktifasi',
                      style: AppStyles.linkText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
