import 'dart:convert';
import '../../models/facility_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class FacilitiesService {
  // URL untuk Overpass API
  static const String _overpassUrl = 'https://overpass-api.de/api/interpreter';

  // Fungsi untuk mendapatkan lokasi pengguna saat ini
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Cek apakah layanan lokasi aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Layanan lokasi tidak aktif. Silakan aktifkan di pengaturan.');
    }

    // Cek izin lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Izin lokasi ditolak.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Izin lokasi ditolak secara permanen.');
    }

    // Dapatkan posisi saat ini
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // di dalam class FacilitiesService

// ... kode lainnya

  // Fungsi untuk mengambil data faskes dari Overpass API
  static Future<List<Facility>> fetchNearbyFacilities(
      double userLat, double userLon) async {
    // Radius pencarian dalam meter (misalnya 5 km)
    const int searchRadius = 50000;

    // Query Overpass QL yang DIPERBAIKI
    // 1. Cari cara (way) yang memiliki tag amenity
    // 2. Cari relasi (relation) yang memiliki tag amenity
    // 3. Cari node (node) HANYA jika memiliki tag amenity dan name
    final String query = '''
    [out:json][timeout:25];
    (
      // Amenity (utama)
      way["amenity"~"hospital|clinic|pharmacy|doctors"](around:$searchRadius,$userLat,$userLon);
      node["amenity"~"hospital|clinic|pharmacy|doctors"](around:$searchRadius,$userLat,$userLon);
      relation["amenity"~"hospital|clinic|pharmacy|doctors"](around:$searchRadius,$userLat,$userLon);

      // Healthcare (tambahan)
      way["healthcare"~"hospital|clinic|doctor|pharmacy"](around:$searchRadius,$userLat,$userLon);
      node["healthcare"~"hospital|clinic|doctor|pharmacy"](around:$searchRadius,$userLat,$userLon);
      relation["healthcare"~"hospital|clinic|doctor|pharmacy"](around:$searchRadius,$userLat,$userLon);

      // Shop (untuk apotek tertentu)
      way["shop"="chemist"](around:$searchRadius,$userLat,$userLon);
      node["shop"="chemist"](around:$searchRadius,$userLat,$userLon);
      relation["shop"="chemist"](around:$searchRadius,$userLat,$userLon);
    );
    out body;
    >;
    out skel qt;
    ''';

    try {
      final response = await http.post(
        Uri.parse(_overpassUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'data=$query',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseOverpassResponse(data, userLat, userLon);
      } else {
        throw Exception('Gagal mengambil data faskes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching facilities: $e');
      // Kembalikan list kosong jika terjadi error agar aplikasi tidak crash
      return [];
    }
  }

  // Fungsi untuk parsing response JSON dari Overpass
  static List<Facility> _parseOverpassResponse(
      Map<String, dynamic> data, double userLat, double userLon) {
    final List<Facility> facilities = [];
    final elements = data['elements'] as List;

    for (var element in elements) {
      final tags = element['tags'] as Map<String, dynamic>? ?? {};
      final name = tags['name'] as String?;

      // <<< FILTER: Lewati jika tidak ada nama atau nama kosong >>>
      if (name == null || name.trim().isEmpty) {
        print('Skipping element without name: ${element['id']}');
        continue; // Lanjut ke elemen berikutnya
      }
      // <<< AKHIR FILTER >>>

      final type = _determineFacilityType(tags['amenity'] as String?);

      // Ambil koordinat
      double lat = 0.0;
      double lon = 0.0;
      if (element['lat'] != null && element['lon'] != null) {
        lat = element['lat'].toDouble();
        lon = element['lon'].toDouble();
      } else if (element['center'] != null) {
        lat = element['center']['lat'].toDouble();
        lon = element['center']['lon'].toDouble();
      } else {
        continue; // Lewati jika tidak ada koordinat
      }

      // Buat alamat dari data yang ada
      final address = _formatAddress(tags);

      // Hitung jarak
      final distance = Geolocator.distanceBetween(userLat, userLon, lat, lon);
      final distanceString = '${(distance / 1000).toStringAsFixed(1)} km';

      facilities.add(Facility(
        id: element['id'].toString(),
        name: name, // Gunakan nama yang sudah dipastikan tidak kosong
        address: address,
        latitude: lat,
        longitude: lon,
        phone: tags['phone'] as String? ?? 'Tidak tersedia',
        distance: distanceString,
        rating: 0.0,
        openTime: tags['opening_hours'] as String? ?? 'Jam tidak diketahui',
        type: type,
        services: [],
      ));
    }

    // Urutkan berdasarkan jarak terdekat
    facilities.sort((a, b) => double.parse(a.distance.split(' ')[0])
        .compareTo(double.parse(b.distance.split(' ')[0])));

    return facilities;
  }

  // Fungsi helper untuk menentukan tipe faskes
  static String _determineFacilityType(String? amenity) {
    switch (amenity) {
      case 'hospital':
        return 'Rumah Sakit';
      case 'clinic':
        return 'Klinik';
      case 'pharmacy':
        return 'Apotek';
      case 'doctors':
        return 'Klinik Dokter';
      default:
        return 'Faskes Lainnya';
    }
  }

  // Fungsi helper untuk memformat alamat
  static String _formatAddress(Map<String, dynamic> tags) {
    final parts = <String>[];
    if (tags['addr:housenumber'] != null) parts.add(tags['addr:housenumber']);
    if (tags['addr:street'] != null) parts.add(tags['addr:street']);
    if (tags['addr:city'] != null) parts.add(tags['addr:city']);
    if (tags['addr:subdistrict'] != null) parts.add(tags['addr:subdistrict']);

    return parts.isNotEmpty ? parts.join(', ') : 'Alamat tidak diketahui';
  }
}