// lib/screens/facilities/widgets/map_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:aska/constants/app_colors.dart';
import 'package:aska/models/facility_model.dart';

class MapWidget extends StatefulWidget {
  final MapController mapController;
  final List<Facility> facilities;
  final VoidCallback onRefresh;

  const MapWidget({
    Key? key,
    required this.mapController,
    required this.facilities,
    required this.onRefresh,
  }) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  // Kita perlu menyimpan posisi marker yang kita tambahkan
  // agar bisa dihapus nanti
  final List<GeoPoint> _facilityMarkerPositions = [];
  bool _isAddingMarkers = false;

  @override
  void didUpdateWidget(MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Hapus marker lama dan tambahkan marker baru jika daftar fasilitas berubah
    if (oldWidget.facilities != widget.facilities) {
      _clearFacilityMarkers();
      _addFacilityMarkers();
    }
  }

  Future<void> _clearFacilityMarkers() async {
    if (_facilityMarkerPositions.isNotEmpty) {
      // Gunakan removeMarkers dengan daftar posisi marker yang kita simpan
      await widget.mapController.removeMarkers(_facilityMarkerPositions);
      _facilityMarkerPositions.clear();
    }
  }

  Future<void> _addFacilityMarkers() async {
    if (_isAddingMarkers) return;
    _isAddingMarkers = true;

    for (var facility in widget.facilities) {
      final geoPoint = GeoPoint(
        latitude: facility.latitude,
        longitude: facility.longitude,
      );

      // Tambahkan marker ke peta
      await widget.mapController.addMarker(
        geoPoint,
        markerIcon: MarkerIcon(
          icon: Icon(
            _getIconDataForType(facility.type),
            color: _getColorForType(facility.type),
            size: 48,
          ),
        ),
      );

      // Simpan posisi marker untuk dihapus nanti
      _facilityMarkerPositions.add(geoPoint);
    }

    _isAddingMarkers = false;
  }

  IconData _getIconDataForType(String type) {
    switch (type) {
      case 'Rumah Sakit':
        return Icons.local_hospital;
      case 'Klinik':
      case 'Klinik Dokter':
        return Icons.medical_services; // Bisa diganti Icons.medical_services
      case 'Apotek':
        return Icons.local_pharmacy;
      default:
        return Icons.location_on;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'Rumah Sakit':
        return Colors.red;
      case 'Klinik':
      case 'Klinik Dokter':
        return Colors.blue;
      case 'Apotek':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          OSMFlutter(
            controller: widget.mapController,
            osmOption: OSMOption(
              zoomOption: const ZoomOption(
                initZoom: 16, // <<< INI ZOOM AWAL YANG DIINGINKAN
                stepZoom: 1.0,
                minZoomLevel: 2,
                maxZoomLevel: 19,
              ),
              userLocationMarker: UserLocationMaker(
                personMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.my_location,
                    color: Colors.blue,
                    size: 48,
                  ),
                ),
                directionArrowMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.person, // <<< DIUBAH DARI Icons.double_arrow
                    color: Colors.red,
                    size: 48,
                  ),
                ),
              ),
              // Hapus konfigurasi jalan yang tidak diperlukan
              // roadConfiguration: const RoadConfiguration(
              //   roadColor: Colors.yellowAccent,
              //   zoomIn: true,
              // ),
            ),
          ),
          // Current Location Button
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              mini: true,
              onPressed: widget.onRefresh,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.my_location, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}