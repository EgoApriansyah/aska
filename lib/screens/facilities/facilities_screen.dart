// lib/screens/facilities/facilities_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';
import '../../constants/app_routes.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class FacilitiesScreen extends StatefulWidget {
  const FacilitiesScreen({Key? key}) : super(key: key);

  @override
  State<FacilitiesScreen> createState() => _FacilitiesScreenState();
}

class _FacilitiesScreenState extends State<FacilitiesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Semua';
  late MapController _mapController;

  @override
  void initState() {
    super.initState();

    _mapController = MapController(
      initMapWithUserPosition: const UserTrackingOption(),
    );
  }

  // Sample data for facilities
  final List<Facility> _facilities = [
    Facility(
      id: '1',
      name: 'RSUD Cibabat',
      address: 'Jl. Pemuda No. 123, Cibabat, Cimahi Selatan',
      latitude: -6.9217,
      longitude: 107.6191,
      phone: '022-42212345',
      distance: '1.2 km',
      rating: 4.5,
      openTime: '07:00 - 21:00',
      type: 'Rumah Sakit',
      services: ['IGD', 'Rawat Inap', 'ICU', 'Laboratorium'],
    ),
    Facility(
      id: '2',
      name: 'Klinik Medika Stania',
      address: 'Jl. Sukajadi No. 45, Sukajadi, Cimahi Selatan',
      latitude: -6.9175,
      longitude: 107.6185,
      phone: '022-42267890',
      distance: '2.5 km',
      rating: 4.2,
      openTime: '08:00 - 20:00',
      type: 'Klinik',
      services: ['Umum', 'Gigi', 'Kandungan'],
    ),
    Facility(
      id: '3',
      name: 'Puskesmas Sukajadi',
      address: 'Jl. Ir. H. Juanda No. 89, Sukajadi, Cimahi Selatan',
      latitude: -6.9188,
      longitude: 107.6178,
      phone: '022-42298765',
      distance: '3.1 km',
      rating: 4.0,
      openTime: '07:00 - 15:00',
      type: 'Puskesmas',
      services: ['Kesehatan Umum', 'Imunisasi', 'KIA'],
    ),
    Facility(
      id: '4',
      name: 'Apotek Sehat',
      address: 'Jl. Karangsetra No. 56, Cimahi Selatan',
      latitude: -6.9205,
      longitude: 107.6205,
      phone: '022-42234567',
      distance: '0.8 km',
      rating: 4.3,
      openTime: '08:00 - 22:00',
      type: 'Apotek',
      services: ['Obat', 'Alat Kesehatan', 'Resep'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Faskes Terdekat'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: Column(
        children: [
          // Search and Filter Section
          _buildSearchAndFilter(),

          // Map Section
          Expanded(flex: 2, child: _buildMap()),

          // Facilities List
          Expanded(flex: 3, child: _buildFacilitiesList()),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari faskes...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
              ),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Filter Chips
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                final filters = [
                  'Semua',
                  'Rumah Sakit',
                  'Klinik',
                  'Puskesmas',
                  'Apotek',
                ];
                final isSelected = filters[index] == _selectedFilter;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedFilter = filters[index];
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.grey[300]!,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        filters[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textDark,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    final MapController _mapController = MapController(
      initMapWithUserPosition: const UserTrackingOption(
        enableTracking: true,
        unFollowUser: false,
      ),
    );

    // Fungsi untuk menambahkan marker semua fasilitas
    Future<void> _addFacilityMarkers() async {
      for (var facility in _facilities) {
        await _mapController.addMarker(
          GeoPoint(latitude: facility.latitude, longitude: facility.longitude),
          markerIcon: const MarkerIcon(
            icon: Icon(Icons.location_on, color: Colors.red, size: 48),
          ),
        );
      }

      // Zoom agar semua marker terlihat
      if (_facilities.isNotEmpty) {
        final geoPoints = _facilities
            .map((f) => GeoPoint(latitude: f.latitude, longitude: f.longitude))
            .toList();
        await _mapController.zoomToBoundingBox(
          BoundingBox.fromGeoPoints(geoPoints),
          paddinInPixel: 50,
        );
      }
    }

    return OSMFlutter(
      controller: _mapController,
      osmOption: const OSMOption(
        zoomOption: ZoomOption(initZoom: 12),
        userTrackingOption: UserTrackingOption(
          enableTracking: true,
          unFollowUser: false,
        ),
      ),
      // Callback ini dipanggil ketika map sudah siap
      onMapIsReady: (isReady) {
        if (isReady) {
          _addFacilityMarkers();
        }
      },
      onGeoPointClicked: (point) {
        final facility = _facilities.firstWhere(
          (f) => f.latitude == point.latitude && f.longitude == point.longitude,
        );

        if (facility != null) {
          showDialog(
            context: context,
            builder: (context) => PointerInterceptor(
              child: AlertDialog(
                title: Text(facility.name),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (facility.address.isNotEmpty)
                      Text('Address: ${facility.address}'),
                    if (facility.phone.isNotEmpty)
                      Text('Phone: ${facility.phone}'),
                    if (facility.distance.isNotEmpty)
                      Text('Distance: ${facility.distance}'),
                    if (facility.rating != 0)
                      Text('Rating: ${facility.rating}'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildFacilitiesList() {
    // Filter facilities based on selected filter
    List<Facility> filteredFacilities = _selectedFilter == 'Semua'
        ? _facilities
        : _facilities
              .where((facility) => facility.type == _selectedFilter)
              .toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Faskes Terdekat',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Show all facilities
                },
                child: const Text('Lihat Semua'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Facilities Cards
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredFacilities.length,
              itemBuilder: (context, index) {
                return _buildFacilityCard(filteredFacilities[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityCard(Facility facility) {
    return Container(
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
            // Header with name and rating
            Row(
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
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: AppColors.primary,
                          ),
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getRatingColor(facility.rating),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        facility.rating.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Type, distance, and open time
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
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
                const SizedBox(width: 8),
                Icon(Icons.directions_walk, size: 16, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  facility.distance,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.access_time, size: 16, color: AppColors.textLight),
                const SizedBox(width: 4),
                Text(
                  'Buka: ${facility.openTime}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Services
            Text(
              'Layanan: ${facility.services.join(', ')}',
              style: const TextStyle(fontSize: 12, color: AppColors.textLight),
            ),

            const SizedBox(height: 12),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.call, size: 16),
                    label: const Text('Hubungi'),
                    onPressed: () {
                      _makePhoneCall(facility.phone);
                    },
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
                    onPressed: () {
                      _openMapsNavigation(facility);
                    },
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
        ),
      ),
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 4.5) return Colors.green;
    if (rating >= 4.0) return Colors.orange;
    return Colors.red;
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Rumah Sakit':
        return Colors.red;
      case 'Klinik':
        return Colors.blue;
      case 'Puskesmas':
        return Colors.green;
      case 'Apotek':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _showFacilityDetails(Facility facility) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                facility.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                facility.address,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  const Icon(Icons.phone, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    facility.phone,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                'Jam Buka: ${facility.openTime}',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Layanan: ${facility.services.join(', ')}',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _makePhoneCall(facility.phone);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Hubungi'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _openMapsNavigation(facility);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Navigasi'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _makePhoneCall(String phone) {
    // TODO: Implement phone call functionality
    print('Calling $phone');
  }

  void _openMapsNavigation(Facility facility) {
    // TODO: Open in external map app or implement navigation
    print('Navigating to ${facility.name}');
  }

  void _getCurrentLocation() {
    // TODO: Get current location
    print('Getting current location');
  }
}

class Facility {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String phone;
  final String distance;
  final double rating;
  final String openTime;
  final String type;
  final List<String> services;

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
  });
}
