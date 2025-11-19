// import 'package:flutter/material.dart';
// import 'app.dart';

// void main() {
//   runApp(const App());
// }

// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'app.dart';
import 'firebase_options.dart';

void main() async {
  // Pastikan Flutter binding sudah diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi Firebase
  await Firebase.initializeApp();
  runApp(const App());
}
