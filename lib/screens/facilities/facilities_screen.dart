// lib/screens/facilities/facilities_screen.dart
import 'package:aska/services/medicine_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart' as OSM;
import 'package:aska/constants/app_colors.dart';
import 'package:aska/models/facility_model.dart';
import 'package:aska/services/facilities_service.dart';
import 'package:aska/services/firestore_service.dart';
import 'package:aska/screens/facilities/widgets/map_widget.dart';
import 'package:aska/screens/facilities/widgets/facility_list_widget.dart';
import 'package:aska/screens/facilities/widgets/facility_card_widget.dart';

class FacilitiesScreen extends StatefulWidget {
  const FacilitiesScreen({Key? key}) : super(key: key);

  @override
  State<FacilitiesScreen> createState() => _FacilitiesScreenState();
}

class _FacilitiesScreenState extends State<FacilitiesScreen> {
  late OSM.MapController _mapController;
  List<Facility> _allFacilities = []; // Data asli dari API/Firestore
  List<Facility> _filteredFacilities = []; // Data yang sudah difilter untuk ditampilkan
  bool _isLoading = true;
  String _selectedFilter = 'Semua';
  String _searchQuery = '';

  // State untuk mode pencarian
  bool _isMedicineSearchMode = false;

  final List<String> _facilityTypeFilters = [
    'Semua',
    'Rumah Sakit',
    'Klinik',
    'Klinik Dokter',
    'Apotek',
  ];

  @override
  void initState() {
    super.initState();
    _mapController = OSM.MapController(
      initMapWithUserPosition: const OSM.UserTrackingOption(
        enableTracking: true,
      ),
    );
    _loadNearbyFacilities();
    // Refresh data obat di background agar tidak mengganggu UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshAllPharmacyMedicines();
    });
  }

  Future<void> _refreshAllPharmacyMedicines() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('facilities')
          .where('type', isEqualTo: 'Apotek')
          .get();

      for (var doc in querySnapshot.docs) {
        final facilityData = doc.data() as Map<String, dynamic>;
        final medicines = List<String>.from(facilityData['medicines'] ?? []);
        
        if (medicines.isEmpty) {
          final newMedicines = MedicineService.generateRandomMedicineList();
          await FirestoreService.updatePharmacyMedicines(doc.id, newMedicines);
        }
      }
    } catch (e) {
      print('Gagal refresh data obat: $e');
    }
  }

  Future<void> _loadNearbyFacilities() async {
    if (mounted) setState(() => _isLoading = true);
    try {
      final position = await FacilitiesService.getCurrentLocation();
      
      List<Facility> firestoreFacilities = await FirestoreService.getNearbyFacilities(
          position.latitude, position.longitude, 50.0);

      List<Facility> finalFacilities;

      if (firestoreFacilities.isNotEmpty) {
        finalFacilities = firestoreFacilities;
      } else {
        final apiFacilities = await FacilitiesService.fetchNearbyFacilities(
            position.latitude, position.longitude);
        if (apiFacilities.isNotEmpty) {
          await FirestoreService.saveFacilities(apiFacilities);
        }
        finalFacilities = apiFacilities;
      }

      await _mapController.moveTo(
        OSM.GeoPoint(latitude: position.latitude, longitude: position.longitude),
      );

      if (mounted) {
        setState(() {
          _allFacilities = finalFacilities;
          _filteredFacilities = finalFacilities;
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().contains('Exception') 
              ? e.toString().replaceFirst('Exception: ', '') 
              : 'Gagal memuat data faskes.')),
        );
      }
    }
  }

  // Fungsi utama untuk menerapkan semua filter
  Future<void> _applyFilters() async {
    if (mounted) setState(() => _isLoading = true);

    try {
      if (_isMedicineSearchMode && _searchQuery.isNotEmpty) {
        // --- MODE PENCARIAN OBAT (BARU) ---
        final position = await FacilitiesService.getCurrentLocation();
        // 1. Ambil SEMUA apotek terdekat
        final allNearbyPharmacies =
            await FirestoreService.getNearbyPharmacies(
                position.latitude, position.longitude, 100.0); // Cari dalam radius 10km

        // 2. Filter di sisi klien
        final List<Facility> results = [];
        for (var pharmacy in allNearbyPharmacies) {
          // Periksa apakah ada obat di apotek ini yang cocok dengan query
          print(pharmacy);
          final hasMedicine = pharmacy.medicines.any((med) =>
              med.toLowerCase().contains(_searchQuery.toLowerCase()));

          if (hasMedicine) {
            results.add(pharmacy);
          }
        }

        if (mounted) {
          setState(() {
            _filteredFacilities = results;
            _isLoading = false;
          });
        }
      } else {
        // --- MODE PENCARIAN FASKES (TIDAK BERUBAH) ---
        final List<Facility> tempList = _allFacilities.where((facility) {
          final matchesSearch = facility.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
          final matchesFilter = _selectedFilter == 'Semua' ||
              facility.type == _selectedFilter;
          return matchesSearch && matchesFilter;
        }).toList();

        if (mounted) {
          setState(() {
            _filteredFacilities = tempList;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error applying filters: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(_isMedicineSearchMode ? 'Cari Obat' : 'Cari Faskes'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: Column(
        children: [
          // Bagian Pencarian dan Filter
          _buildSearchAndFilterSection(),

          // Bagian Peta
          Expanded(
            flex: 2,
            child: MapWidget(
              mapController: _mapController,
              facilities: _filteredFacilities,
              onRefresh: _loadNearbyFacilities,
            ),
          ),

          // Bagian Daftar Faskes
          Expanded(
            flex: 3,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredFacilities.isEmpty
                    ? _buildEmptyState()
                    : FacilityListWidget(
                        facilities: _filteredFacilities,
                        mapController: _mapController,
                        isSearchingMedicine: _isMedicineSearchMode,
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          // Search Bar
          TextField(
            onChanged: (query) {
              _searchQuery = query;
              // Debounce sederhana: tunggu hingga user berhenti mengetik
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted && _searchQuery == query) {
                  _applyFilters();
                }
              });
            },
            decoration: InputDecoration(
              hintText: _isMedicineSearchMode
                  ? 'Ketik nama obat (misal: Paracetamol)...'
                  : 'Cari nama faskes...',
              prefixIcon: Icon(
                _isMedicineSearchMode ? Icons.medical_services : Icons.search,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchQuery = '';
                        _applyFilters();
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          ),

          const SizedBox(height: 12),

          // Toggle Pencarian & Filter Chips
          Row(
            children: [
              // Toggle untuk mode pencarian
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (_isMedicineSearchMode) {
                              setState(() {
                                _isMedicineSearchMode = false;
                                _searchQuery = '';
                              });
                              _applyFilters();
                            }
                          },
                          child: Container(
                            height: 36,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: !_isMedicineSearchMode
                                  ? AppColors.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              'Cari Faskes',
                              style: TextStyle(
                                color: !_isMedicineSearchMode
                                    ? Colors.white
                                    : AppColors.textDark,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (!_isMedicineSearchMode) {
                              setState(() {
                                _isMedicineSearchMode = true;
                                _searchQuery = '';
                              });
                              _applyFilters();
                            }
                          },
                          child: Container(
                            height: 36,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _isMedicineSearchMode
                                  ? AppColors.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              'Cari Obat',
                              style: TextStyle(
                                color: _isMedicineSearchMode
                                    ? Colors.white
                                    : AppColors.textDark,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Filter Chips untuk Faskes (hanya muncul di mode Cari Faskes)
          if (!_isMedicineSearchMode) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _facilityTypeFilters.length,
                itemBuilder: (context, index) {
                  final filter = _facilityTypeFilters[index];
                  final isSelected = filter == _selectedFilter;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildFilterChip(filter, isSelected),
                  );
                },
              ),
            ),
          ],

          // Informasi mode pencarian obat
          if (_isMedicineSearchMode) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Menampilkan apotek yang mungkin menyediakan obat yang Anda cari. Mohon konfirmasi ketersediaan obat ke apotek.',
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filter, bool isSelected) {
    return GestureDetector(
      onTap: () {
        _selectedFilter = filter;
        _applyFilters();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Text(
          filter,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textDark,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _isMedicineSearchMode ? Icons.medical_services : Icons.search_off,
            size: 64,
            color: AppColors.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            _isMedicineSearchMode
                ? 'Tidak ada apotek yang menyediakan obat ini.'
                : 'Tidak ada faskes ditemukan.',
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textLight,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
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
    );
  }
}