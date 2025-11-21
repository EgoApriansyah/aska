import 'package:share_plus/share_plus.dart';

class ShareService {
  static Future<void> shareHealthData({
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
      final healthSummary = _generateHealthSummary(
        healthScore,
        heartRate,
        bloodPressure,
        temperature,
        oxygenSaturation,
        steps,
        sleepMinutes,
        stressLevel,
        period,
      );

      // Share ke semua aplikasi yang support (WhatsApp, Telegram, dll)
      await Share.share(
        healthSummary,
        subject: '📊 Laporan Kesehatan ASKA - $period',
      );
      
    } catch (e) {
      throw Exception('Gagal berbagi data: $e');
    }
  }

  static String _generateHealthSummary(
    int healthScore,
    int heartRate,
    String bloodPressure,
    double temperature,
    int oxygenSaturation,
    int steps,
    int sleepMinutes,
    int stressLevel,
    String period,
  ) {
    return '''
📊 *LAPORAN KESEHATAN ASKA - $period*

*DATA KESEHATAN:*
❤️ *Kesehatan Umum*
• Skor Kesehatan: $healthScore/100 ${_getHealthEmoji(healthScore)}
• Detak Jantung: $heartRate bpm ${_getHeartRateEmoji(heartRate)}
• Tekanan Darah: $bloodPressure mmHg ${_getBloodPressureEmoji(bloodPressure)}

🌡️ *Parameter Fisik*
• Suhu Tubuh: ${temperature}°C 🌡️
• Saturasi Oksigen: $oxygenSaturation% 💨

💪 *Aktivitas & Gaya Hidup*
• Langkah Harian: $steps steps 🚶‍♂️
• Durasi Tidur: ${(sleepMinutes / 60).toStringAsFixed(1)} jam 😴
• Level Stres: $stressLevel/10 ${_getStressEmoji(stressLevel)}

*STATUS KESELURUHAN:*
${_getOverallStatus(healthScore)}

*CATATAN:*
Laporan ini dibuat otomatis oleh Aplikasi ASKA. Untuk konsultasi medis, silakan hubungi tenaga kesehatan profesional.

#ASKAHealth #KesehatanDigital
''';
  }

  static String _getHealthEmoji(int score) {
    if (score >= 80) return '🎉';
    if (score >= 60) return '👍';
    return '⚠️';
  }

  static String _getHeartRateEmoji(int rate) {
    if (rate >= 60 && rate <= 100) return '✅';
    if (rate < 60) return '🔻';
    return '🔺';
  }

  static String _getBloodPressureEmoji(String bp) {
    final parts = bp.split('/');
    if (parts.length == 2) {
      final systolic = int.tryParse(parts[0]) ?? 0;
      if (systolic < 120) return '✅';
      if (systolic < 130) return '👍';
      if (systolic < 140) return '⚠️';
    }
    return '🔺';
  }

  static String _getStressEmoji(int level) {
    if (level <= 3) return '😊';
    if (level <= 6) return '😐';
    return '😰';
  }

  static String _getOverallStatus(int healthScore) {
    if (healthScore >= 80) {
      return 'Kondisi kesehatan SANGAT BAIK! Pertahankan gaya hidup sehat Anda! 🌟';
    } else if (healthScore >= 60) {
      return 'Kondisi kesehatan BAIK. Beberapa area bisa ditingkatkan! 💪';
    } else {
      return 'Kondisi kesehatan PERLU PERHATIAN. Disarankan konsultasi dengan dokter. 🩺';
    }
  }
}