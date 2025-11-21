// lib/models/facility_model.dart
class Facility {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String phone;
  String distance;
  final double rating;
  final String openTime;
  final String type;
  final List<String> services;
  final List<String> medicines; // <<< TAMBAHKAN FIELD INI

  Facility({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.distance,
    required this.rating,
    required this.openTime,
    required this.type,
    required this.services,
    this.medicines = const [], // Beri nilai default list kosong
  });
}