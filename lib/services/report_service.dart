// lib/services/report_service.dart
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class ReportService {
  static Future<void> downloadHealthReport({
    required int healthScore,
    required int heartRate,
    required String bloodPressure,
    required double temperature,
    required int oxygenSaturation,
    required int steps,
    required int sleepMinutes,
    required int stressLevel,
    required String period,
  }) async {
    try {
      // Create PDF document
      final pdf = pw.Document();

      // Add content to PDF
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(),
                pw.SizedBox(height: 20),
                
                // Patient Information
                _buildSectionTitle('Informasi Pasien'),
                _buildPatientInfo(),
                pw.SizedBox(height: 15),
                
                // Health Data
                _buildSectionTitle('Data Kesehatan ($period)'),
                _buildHealthData(
                  healthScore,
                  heartRate,
                  bloodPressure,
                  temperature,
                  oxygenSaturation,
                  steps,
                  sleepMinutes,
                  stressLevel,
                ),
                pw.SizedBox(height: 15),
                
                // Analysis Summary
                _buildSectionTitle('Ringkasan Analisis'),
                _buildAnalysisSummary(healthScore),
                
                // Footer
                pw.Spacer(),
                _buildFooter(),
              ],
            );
          },
        ),
      );

      // Save PDF file
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/laporan_kesehatan_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf");
      
      await file.writeAsBytes(await pdf.save());
      
      // Open the file
      await OpenFile.open(file.path);
      
    } catch (e) {
      throw Exception('Gagal membuat laporan: $e');
    }
  }

  static pw.Widget _buildHeader() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'ASKA Health Report',
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              'Laporan Kesehatan Digital',
              style: pw.TextStyle(fontSize: 12),
            ),
          ],
        ),
        pw.Text(
          DateFormat('dd MMMM yyyy').format(DateTime.now()),
          style: pw.TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  static pw.Widget _buildSectionTitle(String title) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 14,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.blue900,
        ),
      ),
    );
  }

  static pw.Widget _buildPatientInfo() {
    return pw.Row(
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Nama', 'Naufal Wafi'),
              _buildInfoRow('No. BPJS', '1234567890123456'),
              _buildInfoRow('Kelas', '3'),
            ],
          ),
        ),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Usia', '25 Tahun'),
              _buildInfoRow('Jenis Kelamin', 'Laki-laki'),
              _buildInfoRow('Tanggal Laporan', DateFormat('dd/MM/yyyy').format(DateTime.now())),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Row(
      children: [
        pw.Text(
          '$label: ',
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(
          value,
          style: const pw.TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  static pw.Widget _buildHealthData(
    int healthScore,
    int heartRate,
    String bloodPressure,
    double temperature,
    int oxygenSaturation,
    int steps,
    int sleepMinutes,
    int stressLevel,
  ) {
    return pw.Table(
      border: pw.TableBorder.all(),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FlexColumnWidth(1.5),
      },
      children: [
        // Header row
        pw.TableRow(
          children: [
            _buildTableCell('Parameter', isHeader: true),
            _buildTableCell('Nilai', isHeader: true),
            _buildTableCell('Status', isHeader: true),
          ],
        ),
        // Data rows
        _buildTableRow('Skor Kesehatan', '$healthScore/100', _getHealthStatus(healthScore)),
        _buildTableRow('Detak Jantung', '$heartRate bpm', _getHeartRateStatus(heartRate)),
        _buildTableRow('Tekanan Darah', '$bloodPressure mmHg', _getBloodPressureStatus(bloodPressure)),
        _buildTableRow('Suhu Tubuh', '${temperature}°C', _getTemperatureStatus(temperature)),
        _buildTableRow('Saturasi O2', '$oxygenSaturation%', _getOxygenStatus(oxygenSaturation)),
        _buildTableRow('Langkah Harian', '$steps steps', _getStepsStatus(steps)),
        _buildTableRow('Durasi Tidur', '${(sleepMinutes / 60).toStringAsFixed(1)} jam', _getSleepStatus(sleepMinutes)),
        _buildTableRow('Level Stres', '$stressLevel/10', _getStressStatus(stressLevel)),
      ],
    );
  }

  static pw.TableRow _buildTableRow(String parameter, String value, String status) {
    return pw.TableRow(
      children: [
        _buildTableCell(parameter),
        _buildTableCell(value),
        _buildTableCell(status),
      ],
    );
  }

  static pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 8,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  static pw.Widget _buildAnalysisSummary(int healthScore) {
    String summary = '';
    String recommendation = '';

    if (healthScore >= 80) {
      summary = 'Kondisi kesehatan Anda sangat baik. Pertahankan gaya hidup sehat dan rutin berolahraga.';
      recommendation = 'Lanjutkan pola hidup sehat, perbanyak konsumsi buah dan sayuran, serta istirahat yang cukup.';
    } else if (healthScore >= 60) {
      summary = 'Kondisi kesehatan Anda cukup baik. Beberapa parameter perlu diperbaiki.';
      recommendation = 'Tingkatkan aktivitas fisik, perbaiki pola tidur, dan kelola stres dengan baik.';
    } else {
      summary = 'Kondisi kesehatan memerlukan perhatian. Beberapa parameter berada di luar batas normal.';
      recommendation = 'Disarankan berkonsultasi dengan dokter dan melakukan pemeriksaan lebih lanjut.';
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          summary,
          style: const pw.TextStyle(fontSize: 10),
          textAlign: pw.TextAlign.justify,
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          'Rekomendasi:',
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.Text(
          recommendation,
          style: const pw.TextStyle(fontSize: 9),
          textAlign: pw.TextAlign.justify,
        ),
      ],
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            'Catatan:',
            style: pw.TextStyle(
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            'Laporan ini dibuat secara otomatis berdasarkan data yang tercatat. '
            'Untuk diagnosis dan pengobatan, silakan konsultasi dengan tenaga medis profesional.',
            style: const pw.TextStyle(fontSize: 7),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Helper methods for status
  static String _getHealthStatus(int score) {
    if (score >= 80) return 'Sangat Baik';
    if (score >= 60) return 'Baik';
    return 'Perlu Perhatian';
  }

  static String _getHeartRateStatus(int rate) {
    if (rate >= 60 && rate <= 100) return 'Normal';
    if (rate < 60) return 'Rendah';
    return 'Tinggi';
  }

  static String _getBloodPressureStatus(String bp) {
    final parts = bp.split('/');
    if (parts.length == 2) {
      final systolic = int.tryParse(parts[0]) ?? 0;
      if (systolic < 120) return 'Optimal';
      if (systolic < 130) return 'Normal';
      if (systolic < 140) return 'Tinggi Normal';
    }
    return 'Tinggi';
  }

  static String _getTemperatureStatus(double temp) {
    if (temp >= 36 && temp <= 37.5) return 'Normal';
    return 'Perlu Monitor';
  }

  static String _getOxygenStatus(int oxygen) {
    if (oxygen >= 95) return 'Normal';
    return 'Perhatian';
  }

  static String _getStepsStatus(int steps) {
    if (steps >= 10000) return 'Aktif';
    if (steps >= 7500) return 'Cukup';
    return 'Kurang';
  }

  static String _getSleepStatus(int minutes) {
    final hours = minutes / 60;
    if (hours >= 7 && hours <= 9) return 'Cukup';
    if (hours >= 6) return 'Sedang';
    return 'Kurang';
  }

  static String _getStressStatus(int level) {
    if (level <= 3) return 'Rendah';
    if (level <= 6) return 'Sedang';
    return 'Tinggi';
  }
}