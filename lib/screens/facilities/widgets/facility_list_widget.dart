// lib/screens/facilities/widgets/facility_list_widget.dart
import 'package:flutter/material.dart';
import 'package:aska/constants/app_colors.dart';
import 'package:aska/models/facility_model.dart';
import 'package:aska/screens/facilities/widgets/facility_card_widget.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class FacilityListWidget extends StatelessWidget {
  final List<Facility> facilities;
  final MapController? mapController;
  final bool isSearchingMedicine;

  const FacilityListWidget({
    Key? key,
    required this.facilities,
    this.mapController,
    this.isSearchingMedicine = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isSearchingMedicine
                    ? 'Apotek dengan Obat Terdekat'
                    : 'Faskes Terdekat',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Facilities Cards
          Expanded(
            child: ListView.builder(
              itemCount: facilities.length,
              itemBuilder: (context, index) {
                return FacilityCardWidget(
                  facility: facilities[index],
                  mapController: mapController,
                  // Tambahkan callback untuk melihat detail obat
                  onViewMedicines: () {
                    if (facilities[index].type == 'Apotek') {
                      Navigator.pushNamed(
                        context,
                        '/medicine_detail',
                        arguments: facilities[index],
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({String message = 'Tidak ada faskes ditemukan'}) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearchingMedicine ? Icons.medical_services : Icons.search_off,
              size: 64,
              color: AppColors.textLight,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textLight,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coba ubah filter atau kata kunci pencarian Anda',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}