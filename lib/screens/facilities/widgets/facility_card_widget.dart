// lib/screens/facilities/widgets/facility_card_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:aska/constants/app_colors.dart';
import 'package:aska/models/facility_model.dart';

class FacilityCardWidget extends StatelessWidget {
  final Facility facility;
  final MapController? mapController;
  final VoidCallback? onTap;
  final VoidCallback? onViewMedicines;

  const FacilityCardWidget({
    Key? key,
    required this.facility,
    this.mapController,
    this.onTap,
    this.onViewMedicines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              _buildDetails(),
              const SizedBox(height: 12),
              _buildServices(),
              const SizedBox(height: 16), // Tambah sedikit jarak sebelum tombol
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                facility.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      facility.address,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetails() {
    return Wrap( // Menggunakan Wrap agar responsif jika teks panjang
      spacing: 8,
      runSpacing: 4,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getTypeColor(facility.type),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            facility.type,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        _buildDetailChip(Icons.directions_walk, facility.distance),
        _buildDetailChip(Icons.access_time, 'Buka: ${facility.openTime}'),
      ],
    );
  }

  Widget _buildDetailChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.textLight),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: AppColors.textLight),
        ),
      ],
    );
  }

  Widget _buildServices() {
    if (facility.type == 'Apotek' && facility.medicines.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Beberapa obat tersedia:',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: facility.medicines.take(3).map((medicine) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  medicine,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.purple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
          if (facility.medicines.length > 3)
            Text(
              '...dan ${facility.medicines.length - 3} lainnya',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textLight,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  // PERUBAHAN UTAMA ADA DI SINI
  Widget _buildActionButtons(BuildContext context) {
    // Tombol untuk Apotek
    if (facility.type == 'Apotek') {
      return Column(
        children: [
          // Tombol "Lihat Obat" (Full Width)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.medical_services, size: 16),
              label: const Text('Lihat Obat'),
              onPressed: onViewMedicines,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Tombol "Hubungi" dan "Navigasi" (Side by Side)
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.call, size: 16),
                  label: const Text('Hubungi'),
                  onPressed: facility.phone != 'Tidak tersedia'
                      ? () => _makePhoneCall(context, facility.phone)
                      : null,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.directions, size: 16),
                  label: const Text('Navigasi'),
                  onPressed: () => _drawRouteToFacility(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    // Tombol untuk Faskes Lainnya (Rumah Sakit, Klinik, dll.)
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.call, size: 16),
            label: const Text('Hubungi'),
            onPressed: facility.phone != 'Tidak tersedia'
                ? () => _makePhoneCall(context, facility.phone)
                : null,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.directions, size: 16),
            label: const Text('Navigasi'),
            onPressed: () => _drawRouteToFacility(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getTypeColor(String type) {
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

  void _makePhoneCall(BuildContext context, String phone) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    if (!await launchUrl(launchUri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka aplikasi telepon')),
      );
    }
  }

  void _drawRouteToFacility() async {
    if (mapController == null) {
      print("MapController is null, cannot draw route.");
      return;
    }

    try {
      await mapController!.clearAllRoads();

      final userLocation = await mapController!.myLocation();
      if (userLocation != null) {
        final destinationPoint = GeoPoint(
          latitude: facility.latitude,
          longitude: facility.longitude,
        );

        await mapController!.drawRoad(
          userLocation,
          destinationPoint,
          roadOption: const RoadOption(
            roadColor: AppColors.primary,
            roadWidth: 6.0,
          ),
        );

        await mapController!.zoomToBoundingBox(
          BoundingBox.fromGeoPoints([userLocation, destinationPoint]),
          paddinInPixel: 50,
        );
      } else {
        print("User location is null, cannot draw route.");
      }
    } catch (e) {
      print("Error drawing route: $e");
    }
  }
}