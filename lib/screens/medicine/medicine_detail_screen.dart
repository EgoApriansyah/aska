// lib/screens/medicine/medicine_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:aska/constants/app_colors.dart';
import 'package:aska/models/facility_model.dart';
import 'package:aska/services/firestore_service.dart';

class MedicineDetailScreen extends StatefulWidget {
  final Facility pharmacy;

  const MedicineDetailScreen({Key? key, required this.pharmacy}) : super(key: key);

  @override
  State<MedicineDetailScreen> createState() => _MedicineDetailScreenState();
}

class _MedicineDetailScreenState extends State<MedicineDetailScreen> {
  List<String> _medicines = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMedicines();
  }

  Future<void> _loadMedicines() async {
    try {
      final medicines =
          await FirestoreService.getPharmacyMedicines(widget.pharmacy.id);

      setState(() {
        _medicines = medicines;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading medicines: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Obat di ${widget.pharmacy.name}'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                /// HEADER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.local_pharmacy,
                              color: AppColors.primary, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.pharmacy.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on,
                                        size: 16, color: AppColors.textLight),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        widget.pharmacy.address,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textLight,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.phone,
                              color: AppColors.textLight, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            widget.pharmacy.phone,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              color: AppColors.textLight, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Buka: ${widget.pharmacy.openTime}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// LIST OBAT
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Daftar Obat Tersedia',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: _medicines.isEmpty
                              ? _buildEmptyMedicinesWidget()
                              : _buildMedicinesList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyMedicinesWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.medication_outlined, size: 64, color: AppColors.textLight),
          SizedBox(height: 16),
          Text(
            'Tidak ada data obat tersedia',
            style: TextStyle(
                fontSize: 16,
                color: AppColors.textLight,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          Text(
            'Silakan coba beberapa saat lagi',
            style: TextStyle(fontSize: 14, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicinesList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _medicines.length,
      itemBuilder: (context, index) {
        return _buildMedicineCard(_medicines[index]);
      },
    );
  }

  Widget _buildMedicineCard(String medicine) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        medicine,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}
