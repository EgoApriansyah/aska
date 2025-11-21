import 'package:aska/services/report_service.dart';
import 'package:aska/services/share_service.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';
import '../../services/health_analysis_service.dart';

class HealthDetailScreen extends StatefulWidget {
  const HealthDetailScreen({super.key});

  @override
  State<HealthDetailScreen> createState() => _HealthDetailScreenState();
}

class _HealthDetailScreenState extends State<HealthDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Minggu Ini';

  // Variables for AI Analysis
  String _aiAnalysis = '';
  bool _isAnalyzing = false;
  List<Map<String, dynamic>> _weeklyData = [];

  // Health score variable - bisa diganti untuk testing
  int _healthScore = 85; // Ganti ke < 50 untuk test tombol faskes

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    ); // Kurangi jadi 2 tab saja
    _loadDummyData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadDummyData() {
    setState(() {
      _weeklyData = [
        {
          'date': 'Sen',
          'heartRate': 72,
          'steps': 8234,
          'sleepHours': 7.2,
          'stressLevel': 4,
        },
        {
          'date': 'Sel',
          'heartRate': 75,
          'steps': 9456,
          'sleepHours': 6.8,
          'stressLevel': 5,
        },
        {
          'date': 'Rab',
          'heartRate': 71,
          'steps': 7123,
          'sleepHours': 7.5,
          'stressLevel': 3,
        },
        {
          'date': 'Kam',
          'heartRate': 73,
          'steps': 8678,
          'sleepHours': 6.5,
          'stressLevel': 6,
        },
        {
          'date': 'Jum',
          'heartRate': 74,
          'steps': 9234,
          'sleepHours': 7.0,
          'stressLevel': 4,
        },
        {
          'date': 'Sab',
          'heartRate': 72,
          'steps': 5678,
          'sleepHours': 8.2,
          'stressLevel': 2,
        },
        {
          'date': 'Min',
          'heartRate': 73,
          'steps': 6345,
          'sleepHours': 7.8,
          'stressLevel': 3,
        },
      ];
    });
  }

  Future<void> _getAIAnalysis() async {
    setState(() {
      _isAnalyzing = true;
      _aiAnalysis = '';
    });

    try {
      final analysis = await HealthAnalysisService.generateHealthAnalysis(
        healthScore: _healthScore,
        heartRate: 72,
        bloodPressure: '120/80',
        temperature: 36.5,
        oxygenSaturation: 98,
        steps: 12457,
        sleepMinutes: 452,
        stressLevel: 4,
        period: _selectedPeriod,
      );

      setState(() {
        _aiAnalysis = analysis;
      });
    } catch (e) {
      setState(() {
        _aiAnalysis = '❌ Error: $e';
      });
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  void _navigateToHealthFacility() {
    // TODO: Implement navigation to health facility
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pergi ke Faskes Terdekat'),
        content: const Text(
          'Skor kesehatan Anda rendah. Disarankan untuk berkonsultasi dengan tenaga medis.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Open maps or facility list
            },
            child: const Text('Cari Faskes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Detail Kesehatan'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              try {
                // Show loading
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Mempersiapkan data untuk dibagikan...'),
                    duration: Duration(seconds: 1),
                  ),
                );

                await ShareService.shareHealthData(
                  healthScore: 85, // Ganti dengan data aktual
                  heartRate: 72,
                  bloodPressure: '120/80',
                  temperature: 36.5,
                  oxygenSaturation: 98,
                  steps: 12457,
                  sleepMinutes: 452,
                  stressLevel: 4,
                  period: _selectedPeriod,
                );
              } catch (e) {
                // Error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gagal berbagi: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),

          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              try {
                // Show loading
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Membuat laporan kesehatan...'),
                    duration: Duration(seconds: 2),
                  ),
                );

                await ReportService.downloadHealthReport(
                  healthScore: 85, // Ganti dengan data aktual
                  heartRate: 72,
                  bloodPressure: '120/80',
                  temperature: 36.5,
                  oxygenSaturation: 98,
                  steps: 12457,
                  sleepMinutes: 452,
                  stressLevel: 4,
                  period: _selectedPeriod,
                );

                // Success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Laporan berhasil didownload!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                // Error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period Selector
            _buildPeriodSelector(),

            const SizedBox(height: 20),

            // Overall Health Score
            _buildHealthScoreCard(),

            // Tombol Faskes jika skor < 50
            if (_healthScore < 50) ...[
              const SizedBox(height: 16),
              _buildHealthFacilityButton(),
            ],

            const SizedBox(height: 20),

            // Vitals Section
            _buildVitalsSection(),

            const SizedBox(height: 20),

            // Health Metrics Tabs (Hanya Grafik & Riwayat)
            _buildHealthMetricsTabs(),

            const SizedBox(height: 20),

            // AI Analysis Section (Dipindah ke bawah)
            _buildAIAnalysisSection(),

            const SizedBox(height: 20),

            // Health Insights
            _buildHealthInsights(),

            const SizedBox(height: 20),

            // Recommendations
            _buildRecommendations(),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthFacilityButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: Colors.red[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Perhatian! Skor Kesehatan Rendah',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Disarankan untuk berkonsultasi dengan tenaga medis',
                  style: TextStyle(fontSize: 12, color: Colors.red),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/facilities'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Faskes Terdekat'),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          const Icon(Icons.date_range, color: AppColors.primary),
          const SizedBox(width: 12),
          const Text(
            'Periode:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: DropdownButton<String>(
              value: _selectedPeriod,
              underline: const SizedBox(),
              isDense: true,
              items: ['Hari Ini', 'Minggu Ini', 'Bulan Ini', 'Tahun Ini'].map((
                period,
              ) {
                return DropdownMenuItem(value: period, child: Text(period));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPeriod = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthScoreCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Skor Kesehatan Keseluruhan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Circular Progress Indicator
          SizedBox(
            height: 150,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: CircularProgressIndicator(
                    value: _healthScore / 100,
                    strokeWidth: 12,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _healthScore >= 70 ? Colors.white : Colors.orange,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$_healthScore',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _healthScore >= 70
                          ? 'Baik'
                          : _healthScore >= 50
                          ? 'Cukup'
                          : 'Perhatian',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildScoreItem('BMI', 'Normal', Colors.green),
              _buildScoreItem('Aktivitas', 'Cukup', Colors.orange),
              _buildScoreItem('Stress', 'Rendah', Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVitalsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          const Text(
            'Tanda Vital',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 20),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _buildVitalCard(
                'Detak Jantung',
                '72 bpm',
                Icons.favorite,
                Colors.red,
                'Normal',
                '60-100 bpm',
              ),
              _buildVitalCard(
                'Tekanan Darah',
                '120/80',
                Icons.monitor_heart,
                Colors.blue,
                'Normal',
                '90-120/60-80',
              ),
              _buildVitalCard(
                'Suhu Tubuh',
                '36.5°C',
                Icons.thermostat,
                Colors.orange,
                'Normal',
                '36-37°C',
              ),
              _buildVitalCard(
                'Saturasi O2',
                '98%',
                Icons.air,
                Colors.green,
                'Baik',
                '95-100%',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVitalCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String status,
    String normalRange,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Normal: $normalRange',
            style: TextStyle(color: Colors.grey[500], fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthMetricsTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Tab Bar (Hanya 2 tab sekarang)
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: 'Grafik'),
              Tab(text: 'Riwayat'),
            ],
          ),

          // Tab Content
          SizedBox(
            height: 400,
            child: TabBarView(
              controller: _tabController,
              children: [_buildChartTab(), _buildHistoryTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Heart Rate Chart
          _buildMetricChart('Detak Jantung (7 hari terakhir)', [
            72,
            75,
            71,
            73,
            74,
            72,
            73,
          ], Colors.red),
          const SizedBox(height: 30),
          // Steps Chart - FIXED
          _buildMetricChart('Langkah Harian (7 hari terakhir)', [
            8234,
            9456,
            7123,
            8678,
            9234,
            5678,
            6345,
          ], Colors.green),
        ],
      ),
    );
  }

  Widget _buildMetricChart(String title, List<double> data, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: LineChart(
              LineChartData(
                backgroundColor: Colors.white,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _calculateInterval(
                    data,
                  ), // Interval dinamis
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.1), // LEBIH TERANG
                      strokeWidth: 0.5, // LEBIH TIPIS
                    );
                  },
                ),
                borderData: FlBorderData(
                  show: false, // MATIKAN BORDER - INI PENYEBAB HITAM
                ),
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = [
                          'Sen',
                          'Sel',
                          'Rab',
                          'Kam',
                          'Jum',
                          'Sab',
                          'Min',
                        ];
                        return Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            days[value.toInt()],
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: data
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value))
                        .toList(),
                    isCurved: true,
                    color: color,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(show: false),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 3,
                          color: color,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                  ),
                ],
                minX: 0,
                maxX: 6,
                minY: data.reduce((a, b) => a < b ? a : b) - 10,
                maxY: data.reduce((a, b) => a > b ? a : b) + 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function untuk menghitung interval yang sesuai
  double _calculateInterval(List<double> data) {
    final maxVal = data.reduce((a, b) => a > b ? a : b);
    final minVal = data.reduce((a, b) => a < b ? a : b);
    final range = maxVal - minVal;

    if (range > 1000) return 2000; // Untuk data steps
    if (range > 100) return 50; // Untuk data besar
    if (range > 10) return 10; // Untuk data sedang
    return 5; // Untuk data kecil
  }

  Widget _buildHistoryTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _weeklyData.length,
        itemBuilder: (context, index) {
          final data = _weeklyData[index];
          return _buildHistoryItem(
            data['date'] as String,
            '${data['heartRate']} bpm',
            '${data['steps']} steps',
            '${data['sleepHours']} jam',
            '${data['stressLevel']}/10',
          );
        },
      ),
    );
  }

  Widget _buildHistoryItem(
    String date,
    String heartRate,
    String steps,
    String sleep,
    String stress,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              date,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildHistoryMetric('❤️', heartRate),
                _buildHistoryMetric('👣', steps),
                _buildHistoryMetric('😴', sleep),
                _buildHistoryMetric('🧠', stress),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryMetric(String icon, String value) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // AI Analysis Section yang dipindah ke bawah
  Widget _buildAIAnalysisSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Analisis AI',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),

            // Button untuk generate analysis
            Center(
              child: ElevatedButton(
                onPressed: _isAnalyzing ? null : _getAIAnalysis,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isAnalyzing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome, size: 20),
                          SizedBox(width: 8),
                          Text('Dapatkan Analisis AI'),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 20),

            // Hasil Analisis AI
            _aiAnalysis.isEmpty
                ? const Column(
                    children: [
                      Icon(Icons.auto_awesome, size: 48, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Klik tombol di atas untuk mendapatkan analisis kesehatan dari AI',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      _aiAnalysis,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthInsights() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          const Text(
            'Wawasan Kesehatan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),

          _buildInsightCard(
            '💧',
            'Hidrasi',
            'Anda minum 6 gelas air hari ini. Tambah 2 gelas lagi untuk mencapai target.',
            Colors.blue,
          ),

          const SizedBox(height: 12),

          _buildInsightCard(
            '🏃',
            'Aktivitas Fisik',
            'Langkah Anda hari ini: 6,234. Tambah 2,766 lagi untuk mencapai target 9,000.',
            Colors.green,
          ),

          const SizedBox(height: 12),

          _buildInsightCard(
            '😴',
            'Kualitas Tidur',
            'Durasi tidur: 6.5 jam. Coba tidur lebih awal untuk hasil yang lebih baik.',
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(
    String icon,
    String title,
    String description,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange[400]!, Colors.orange[300]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rekomendasi Personal',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          _buildRecommendationItem(
            'Jadwalkan pemeriksaan kesehatan rutin setiap 6 bulan',
            Icons.calendar_today,
          ),

          const SizedBox(height: 12),

          _buildRecommendationItem(
            'Tingkatkan asupan serat dalam makanan sehari-hari',
            Icons.restaurant,
          ),

          const SizedBox(height: 12),

          _buildRecommendationItem(
            'Luangkan waktu 10 menit untuk meditasi setiap pagi',
            Icons.self_improvement,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
