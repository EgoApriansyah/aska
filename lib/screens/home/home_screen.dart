import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // Fungsi logout
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  // Popup konfirmasi (Alert Dialog)
  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Konfirmasi Logout"),
          content: const Text("Apakah Anda yakin ingin keluar dari akun?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Tutup dialog
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // tutup dialog dulu
                logout(context);        // baru logout
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Beranda ASKA"),
        actions: [
          IconButton(
            onPressed: () => showLogoutDialog(context),
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
          ),
        ],
      ),
      body: const Center(
        child: Text(
          "Selamat datang di Beranda ASKA!",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
