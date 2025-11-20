// lib/utils/permission_handler.dart
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static Future<bool> hasLocationPermission() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  static Future<void> requestLocationPermission(BuildContext context) async {
    final status = await Permission.location.request();
    if (!status.isGranted) {
      // Handle denied permission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: const Text('Izin lokasi diperlukan'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
