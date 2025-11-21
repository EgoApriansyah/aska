import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aska/models/facility_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:aska/services/medicine_service.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _collectionName = 'facilities';

  /// SIMPAN DATA FASILITAS (STATIC)
  static Future<void> saveFacilities(List<Facility> facilities) async {
    final batch = _db.batch();

    for (var facility in facilities) {
      final docRef = _db.collection(_collectionName).doc(facility.id);
      final docSnapshot = await docRef.get();

      Map<String, dynamic> dataToSave = {
        'name': facility.name,
        'address': facility.address,
        'location': GeoPoint(facility.latitude, facility.longitude),
        'phone': facility.phone,
        'type': facility.type,
        'openTime': facility.openTime,
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      if (facility.type == 'Apotek') {
        List<String> existingMedicines = await getPharmacyMedicines(facility.id);

        if (existingMedicines.isNotEmpty) {
          dataToSave['medicines'] = existingMedicines;
          print('Menggunakan data obat yang sudah ada di Firestore untuk ${facility.name}');
        } else {
          List<String> newMedicines = MedicineService.generateRandomMedicineList();
          dataToSave['medicines'] = newMedicines;
          print('Membuat data obat dummy baru untuk ${facility.name}');
        }
      }

      if (!docSnapshot.exists) {
        batch.set(docRef, dataToSave);
      } else {
        batch.update(docRef, dataToSave);
      }
    }

    await batch.commit();
    print('Berhasil menyimpan ${facilities.length} faskes ke Firestore.');
  }

  /// UPDATE DATA OBAT DI APOTEK
  static Future<void> updatePharmacyMedicines(String pharmacyId, List<String> medicines) async {
    try {
      final docRef = _db.collection(_collectionName).doc(pharmacyId);

      await docRef.update({
        'medicines': medicines,
        'medicinesUpdated': FieldValue.serverTimestamp(),
      });

      print('Berhasil memperbarui data obat untuk apotek $pharmacyId');
    } catch (e) {
      print('Gagal memperbarui data obat: $e');
    }
  }

  /// AMBIL DATA OBAT DARI FIRESTORE — versi aman
  static Future<List<String>> getPharmacyMedicines(String pharmacyId) async {
    try {
      final docSnapshot =
          await _db.collection(_collectionName).doc(pharmacyId).get();

      if (!docSnapshot.exists) return [];

      final data = docSnapshot.data() as Map<String, dynamic>?;

      if (data == null) return [];

      final medicinesData = data['medicines'];

      if (medicinesData == null) {
        return [];
      } else if (medicinesData is String) {
        // Format: "Paracetamol, Ibuprofen"
        return medicinesData
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();
      } else if (medicinesData is List) {
        return medicinesData
            .map((s) => s.toString().trim())
            .where((s) => s.isNotEmpty)
            .toList();
      }

      return [];
    } catch (e) {
      print('Gagal mengambil data obat: $e');
      return [];
    }
  }

  static Future<List<Facility>> getNearbyPharmacies(
      double userLat, double userLon, double radiusInKm) async {
    try {
      final latOffset = radiusInKm / 111.0;
      final lonOffset = radiusInKm / (111.0 * cos(userLat * pi / 180));

      final lowerLat = userLat - latOffset;
      final lowerLon = userLon - lonOffset;
      final upperLat = userLat + latOffset;
      final upperLon = userLon + lonOffset;

      QuerySnapshot querySnapshot = await _db
          .collection(_collectionName)
          .where('type', isEqualTo: 'Apotek')
          .where('location', isGreaterThan: GeoPoint(lowerLat, lowerLon))
          .where('location', isLessThan: GeoPoint(upperLat, upperLon))
          .limit(50) // Batasi jumlah hasil agar tidak terlalu berat
          .get();

      final List<Facility> results = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final geoPoint = data['location'] as GeoPoint;
        final medicines = List<String>.from(data['medicines'] ?? []);

        return Facility(
          id: doc.id,
          name: data['name'] ?? '',
          address: data['address'] ?? '',
          latitude: geoPoint.latitude,
          longitude: geoPoint.longitude,
          phone: data['phone'] ?? 'Tidak tersedia',
          distance: '0 km', // Akan dihitung nanti
          rating: 0.0,
          openTime: data['openTime'] ?? 'Jam tidak diketahui',
          type: data['type'] ?? 'Faskes Lainnya',
          services: [],
          medicines: medicines,
        );
      }).toList();

      // Hitung jarak
      for (var facility in results) {
        final distance = Geolocator.distanceBetween(
            userLat, userLon, facility.latitude, facility.longitude);
        facility.distance = '${(distance / 1000).toStringAsFixed(1)} km';
      }

      // Urutkan berdasarkan jarak
      results.sort((a, b) => double.parse(a.distance.split(' ')[0])
          .compareTo(double.parse(b.distance.split(' ')[0])));

      return results;
    } catch (e) {
      print('Gagal mengambil data apotek terdekat: $e');
      return [];
    }
  }

  /// AMBIL FASKES TERDEKAT DALAM RADIUS
  static Future<List<Facility>> getNearbyFacilities(
      double userLat, double userLon, double radiusInKm) async {

    final latOffset = radiusInKm / 111.0;
    final lonOffset = radiusInKm / (111.0 * cos(userLat * pi / 180));

    final lowerLat = userLat - latOffset;
    final lowerLon = userLon - lonOffset;
    final upperLat = userLat + latOffset;
    final upperLon = userLon + lonOffset;

    try {
      QuerySnapshot querySnapshot = await _db
          .collection(_collectionName)
          .where('location', isGreaterThan: GeoPoint(lowerLat, lowerLon))
          .where('location', isLessThan: GeoPoint(upperLat, upperLon))
          .get();

      final List<Facility> facilities = querySnapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final geo = data['location'] as GeoPoint?;
            final name = data['name'] as String?;

            if (geo == null || name == null || name.trim().isEmpty) {
              return null;
            }

            return Facility(
              id: doc.id,
              name: name,
              address: data['address'] ?? '',
              latitude: geo.latitude,
              longitude: geo.longitude,
              phone: data['phone'] ?? 'Tidak tersedia',
              distance: '0 km',
              rating: 0.0,
              openTime: data['openTime'] ?? 'Jam tidak diketahui',
              type: data['type'] ?? 'Faskes Lainnya',
              services: [],
            );
          })
          .where((f) => f != null)
          .cast<Facility>()
          .toList();

      // Hitung jarak
      for (var f in facilities) {
        final distance = Geolocator.distanceBetween(
            userLat, userLon, f.latitude, f.longitude);
        f.distance = '${(distance / 1000).toStringAsFixed(1)} km';
      }

      facilities.sort((a, b) =>
          double.parse(a.distance.split(' ')[0])
              .compareTo(double.parse(b.distance.split(' ')[0])));

      return facilities;
    } catch (e) {
      print('Gagal mengambil fasilitas: $e');
      return [];
    }
  }

  /// Mencari apotek berdasarkan nama obat
  static Future<List<Facility>> searchPharmaciesWithMedicine(
      String medicineName, double userLat, double userLon) async {
    try {
      final latOffset = 5.0 / 111.0;
      final lonOffset = 5.0 / (111.0 * cos(userLat * pi / 180));

      final lowerLat = userLat - latOffset;
      final lowerLon = userLon - lonOffset;
      final upperLat = userLat + latOffset;
      final upperLon = userLon + lonOffset;

      QuerySnapshot querySnapshot = await _db
          .collection(_collectionName)
          .where('type', isEqualTo: 'Apotek')
          .where('location', isGreaterThan: GeoPoint(lowerLat, lowerLon))
          .where('location', isLessThan: GeoPoint(upperLat, upperLon))
          .where('medicines', arrayContains: medicineName)
          .limit(20)
          .get();

      final userPosition = GeoPoint(userLat, userLon);
      final List<Facility> results = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final geoPoint = data['location'] as GeoPoint;
        final medicines = List<String>.from(data['medicines'] ?? []);

        return Facility(
          id: doc.id,
          name: data['name'] ?? '',
          address: data['address'] ?? '',
          latitude: geoPoint.latitude,
          longitude: geoPoint.longitude,
          phone: data['phone'] ?? 'Tidak tersedia',
          distance: '0 km',
          rating: 0.0,
          openTime: data['openTime'] ?? 'Jam tidak diketahui',
          type: data['type'] ?? 'Faskes Lainnya',
          services: [],
          medicines: medicines,
        );
      }).toList();

      // Hitung jarak
      for (var facility in results) {
        final facilityPosition = GeoPoint(facility.latitude, facility.longitude);
        final distance = Geolocator.distanceBetween(
            userPosition.latitude, userPosition.longitude,
            facilityPosition.latitude, facilityPosition.longitude);
        facility.distance = '${(distance / 1000).toStringAsFixed(1)} km';
      }

      // Urutkan berdasarkan jarak
      results.sort((a, b) => double.parse(a.distance.split(' ')[0])
          .compareTo(double.parse(b.distance.split(' ')[0])));

      return results;
    } catch (e) {
      print('Gagal mencari apotek dengan obat: $e');
      return [];
    }
  }
}
