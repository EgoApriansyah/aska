import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Beranda ASKA"),
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